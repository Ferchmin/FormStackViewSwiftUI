//
//  ExampleValidator.swift
//  FormStackViewApp
//
//  Created by Paweł Zgoda-Ferchmin on 19/01/2023.
//

import Foundation
import FormStackView

public enum ExampleValidator: ValidatorProtocol {
    case email
    case password
    case terms
    case none

    public var textValidator: TextValidator? {
        switch self {
        case .email: return EmailValidator()
        case .password: return PasswordValidator()
        case .none: return AlwaysValidValidator()
        case .terms: return nil
        }
    }

    public var checkboxValidator: CheckBoxValidator? {
        switch self {
        case .terms: return CheckboxRequiredValidator()
        default: return nil
        }
    }
}

public enum ExampleValidationError: ValidationError {
    case empty
    case emailEmpty
    case emailInvalid
    case passwordEmpty
    case passwordTooSimple
    case passwordsDoNotMatch
    case fieldIsRequired

    public var message: String {
        let messages: [Self: String] = [
            .empty: "validation_field_is_required",
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

public struct PasswordValidator: TextValidator {
    public func validate(text: String) -> ValidationError? {
        guard !text.isEmpty else { return ExampleValidationError.passwordEmpty }
        guard text.count >= 8 else { return ExampleValidationError.passwordTooSimple }
        guard text.rangeOfCharacter(from: .uppercaseLetters) != nil else { return ExampleValidationError.passwordTooSimple }
        guard text.rangeOfCharacter(from: .decimalDigits) != nil else { return ExampleValidationError.passwordTooSimple }

        return nil
    }
}

public struct AlwaysValidValidator: TextValidator {
    public func validate(text: String) -> ValidationError? { return nil }
}

public struct CheckboxRequiredValidator: CheckBoxValidator {
    public func validate(isOn: Bool) -> ValidationError? {
        isOn ? nil : ExampleValidationError.fieldIsRequired
    }
}

public struct EmailValidator: TextValidator {
    public func validate(text: String) -> ValidationError? {
        guard !text.isEmpty else {
            return ExampleValidationError.emailEmpty
        }
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        guard predicate.evaluate(with: text) else {
            return ExampleValidationError.emailInvalid
        }
        return nil
    }
}
