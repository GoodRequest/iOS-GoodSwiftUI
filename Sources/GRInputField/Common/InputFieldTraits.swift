//
//  InputFieldTraits.swift
//  benu
//
//  Created by Filip Šašala on 04/08/2022.
//

import UIKit

public struct InputFieldTraits: Sendable {

    public var textContentType: UITextContentType?
    public var autocapitalizationType: UITextAutocapitalizationType = .none
    public var autocorrectionType: UITextAutocorrectionType = .default
    public var keyboardType: UIKeyboardType = .default
    public var returnKeyType: UIReturnKeyType = .default
    public var numpadReturnKeyTitle: String?
    /// If text field is secure, clear button is always disabled.
    public var clearButtonMode: UITextField.ViewMode = .whileEditing
    public var isSecureTextEntry: Bool = false
    public var isHapticsAllowed: Bool = true
    /// Regex limitation of the input string
    public var textLimitation: String? = .none

    public init(
        textContentType: UITextContentType? = nil,
        autocapitalizationType: UITextAutocapitalizationType = .none,
        autocorrectionType: UITextAutocorrectionType = .default,
        keyboardType: UIKeyboardType = .default,
        returnKeyType: UIReturnKeyType = .default,
        numpadReturnKeyTitle: String? = nil,
        clearButtonMode: UITextField.ViewMode = .whileEditing,
        isSecureTextEntry: Bool = false,
        isHapticsAllowed: Bool = true,
        textLimitation: String? = .none
    ) {
        self.textContentType = textContentType
        self.autocapitalizationType = autocapitalizationType
        self.autocorrectionType = autocorrectionType
        self.keyboardType = keyboardType
        self.returnKeyType = returnKeyType
        self.numpadReturnKeyTitle = numpadReturnKeyTitle
        self.clearButtonMode = clearButtonMode
        self.isSecureTextEntry = isSecureTextEntry
        self.isHapticsAllowed = isHapticsAllowed
        self.textLimitation = textLimitation
    }

    public static let `default` = InputFieldTraits()

}
