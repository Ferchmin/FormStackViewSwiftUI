//
//  Validator.swift
//  FormStackViewApp
//
//  Created by Paweł Zgoda-Ferchmin on 19/07/2022.
//

import Foundation
import SwiftUI

public enum ValidationError: Error {
    case empty
    case notNumber

    case usernameEmpty
    case usernameTooShort

    case emailEmpty
    case emailInvalid

    case passwordEmpty
    case passwordTooSimple
    case passwordsDoNotMatch

    case fieldIsRequired

    public var message: String {
        let messages: [ValidationError: String] = [
            .empty: "validation_field_is_required",
            .notNumber: "validation_field_not_number",
            .usernameEmpty: "validation_username_empty",
            .usernameTooShort: "validation_username_too_short",
            .emailEmpty: "validation_email_empty",
            .emailInvalid: "validation_email_invalid",
            .passwordEmpty: "validation_password_empty",
            .passwordTooSimple: "validation_password_too_simple",
            .fieldIsRequired: "validation_field_is_required",
            .passwordsDoNotMatch: "passwords_do_not_match"
        ]
        return messages[self] ?? String(describing: self)
    }
}

public extension ValidationError {
    var errorDescription: String {
        switch self {
        default: return String(reflecting: self)
        }
    }
}

public protocol ValidationType {
    var textValidator: TextValidator.Type? { get }
    var checkboxValidator: CheckBoxValidator.Type? { get }
}

public enum Validation: ValidationType {
    case none
    case username
    case email
    case password
    case newPassword
    case terms

    public var textValidator: TextValidator.Type? {
        switch self {
        case .username: return UsernameValidator.self
        case .email: return EmailValidator.self
        case .password: return PasswordValidator.self
        case .newPassword: return NewPasswordValidator.self
        case .none: return AlwaysValidValidator.self
        case .terms: return nil
        }
    }

    public var checkboxValidator: CheckBoxValidator.Type? {
        switch self {
        case .terms: return CheckboxRequiredValidator.self
        default: return nil
        }
    }
}

public protocol TextValidator {
    static func validate(text: String) -> ValidationError?
}

public protocol CheckBoxValidator {
    static func validate(isOn: Bool) -> ValidationError?
}

public struct PasswordValidator: TextValidator {
    public static func validate(text: String) -> ValidationError? {
        guard !text.isEmpty else { return .passwordEmpty }
        return nil
    }
}

public struct NewPasswordValidator: TextValidator {
    public static func validate(text: String) -> ValidationError? {
        guard !text.isEmpty else { return .passwordEmpty }

        guard text.count >= 8 else { return .passwordTooSimple }
        guard text.rangeOfCharacter(from: .uppercaseLetters) != nil else { return .passwordTooSimple }
        guard text.rangeOfCharacter(from: .decimalDigits) != nil else { return .passwordTooSimple }

        return nil
    }
}

public struct UsernameValidator: TextValidator {
    public static func validate(text: String) -> ValidationError? {
        guard !text.isEmpty else { return .usernameEmpty }
        guard text.count >= 2 else { return .usernameTooShort }
        return nil
    }
}

public struct AlwaysValidValidator: TextValidator {
    public static func validate(text: String) -> ValidationError? { return nil }
}

public struct CheckboxRequiredValidator: CheckBoxValidator {
    public static func validate(isOn: Bool) -> ValidationError? {
        isOn ? nil : .fieldIsRequired
    }
}

public struct EmailValidator: TextValidator {
    public static func validate(text: String) -> ValidationError? {
        guard !text.isEmpty else {
            return .emailEmpty
        }
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        guard predicate.evaluate(with: text) else {
            return .emailInvalid
        }
        return nil
    }
}
