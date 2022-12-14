//
//  FormViewKey.swift
//  FormStackViewApp
//
//  Created by Paweł Zgoda-Ferchmin on 06/09/2022.
//

import FormStackView
import Foundation
import SwiftUI

public enum ExampleFormKey: String, CaseIterableFormKey {
    case email
    case password
    case firstName
    case number
    case country
    case terms
    case marketing

    public var validationType: ValidationType {
        switch self {
        case .password: return .password
        case .terms: return .terms
        case .email: return .email
        default: return .none
        }
    }

    public var keyboardType: UIKeyboardType {
        switch self {
        case .number: return .phonePad
        case .email: return .emailAddress
        default: return .default
        }
    }
}
