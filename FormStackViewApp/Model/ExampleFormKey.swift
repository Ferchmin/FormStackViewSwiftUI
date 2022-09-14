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

    public var validationType: ValidationType {
        switch self {
        case .password: return Validation.password
        case .terms: return Validation.terms
        case .email: return Validation.email
        default: return Validation.none
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
