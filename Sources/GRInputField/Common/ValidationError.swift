//
//  ValidationError.swift
//  benu
//
//  Created by Filip Šašala on 11/06/2024.
//

import Foundation
import GoodExtensions

// MARK: - Validation errors

public protocol ValidationError: LocalizedError {}

public enum InternalValidationError: ValidationError {

    case invalid
    case required
    case mismatch
    case external(MainSupplier<String>)

    public var errorDescription: String? {
        switch self {
        case .invalid:
            Bundle.main.localizedString(forKey: "invalid", value: "Invalid", table: "InternalValidationError")

        case .required:
            Bundle.main.localizedString(forKey: "required", value: "Required", table: "InternalValidationError")

        case .mismatch:
            Bundle.main.localizedString(forKey: "mismatch", value: "Mismatch", table: "InternalValidationError")

        case .external(let description):
            MainActor.assumeIsolated {
                description()
            }
        }
    }

}

// MARK: - Default criteria

public extension Criterion {

    /// Always succeeds
    static let alwaysValid = Criterion { _ in true }

    /// Always fails
    static let alwaysError = Criterion { _ in false }
        .failWith(error: InternalValidationError.invalid)

    /// Accepts any input with length > 0, excluding leading/trailing whitespace
    static let nonEmpty = Criterion { !($0 ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        .failWith(error: InternalValidationError.required)

    /// Accepts an input if it is equal with another input
    static func matches(_ other: String?) -> Criterion {
        Criterion { this in this == other }
            .failWith(error: InternalValidationError.mismatch)
    }

    /// Accepts an empty input, see ``nonEmpty``.
    ///
    /// - Parameter criterion: Criteria for validation of non-empty input
    /// - Returns: `true` if input is empty or valid
    ///
    /// If input is empty, validation **succeeds** and input is deemed valid.
    /// If input is non-empty, validation continues by criterion specified as a parameter.
    static func acceptEmpty(_ criterion: Criterion) -> Criterion {
        Criterion { Criterion.nonEmpty.validate(input: $0) ? criterion.validate(input: $0) : true }
            .failWith(error: criterion.error)
    }

    static func external(error: @MainActor @escaping () -> (any LocalizedError)?) -> Criterion {
        Criterion { _ in error().isNil }
            .failWith(error: InternalValidationError.external { error()?.localizedDescription ?? " " })
    }

}

// MARK: - Commonly used

public extension Criterion {

    /// Email validator similar to RFC-5322 standards, modified for Swift compatibility, case-insensitive
    static let email = Criterion(regex: """
                                        (?i)\\A(?=[a-z0-9@.!#$%&'*+\\/=?^_'{|}~-]{6,254}\
                                        \\z)(?=[a-z0-9.!#$%&'*+\\/=?^_'{|}~-]{1,64}@)\
                                        [a-z0-9!#$%&'*+\\/=?^_'{|}~-]+(?:\\.[a-z0-9!#$%&'*+\\/=?^_'{|}~-]+)\
                                        *@(?:(?=[a-z0-9-]{1,63}\\.)[a-z0-9]\
                                        (?:[a-z0-9-]*[a-z0-9])?\\.)+(?=[a-z0-9-]{1,63}\\z)\
                                        [a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\z
                                        """)

    /// Accepts only valid zip codes
    static let zipCode = Criterion(regex: "^[0-9]{5}$")

}
