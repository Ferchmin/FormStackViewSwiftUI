//
//  FormViewKey.swift
//  FormStackViewApp
//
//  Created by Paweł Zgoda-Ferchmin on 06/09/2022.
//

import FormStackView
import Foundation
import SwiftUI

public enum ExampleFormKey: String, FormKey {
    case email
    case password
    case firstName
    case country
    case number
    case terms
    case marketing

    public var validator: ValidatorProtocol {
        switch self {
        case .password: return ExampleValidator.password
        case .terms: return ExampleValidator.terms
        case .email: return ExampleValidator.email
        default: return ExampleValidator.none
        }
    }

    public var keyboardType: UIKeyboardType {
        switch self {
        case .number: return .phonePad
        case .email: return .emailAddress
        case .password: return .asciiCapable
        default: return .default
        }
    }
}
