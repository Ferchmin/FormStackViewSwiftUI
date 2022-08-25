//
//  FormViewKey.swift
//  FormStackViewApp
//
//  Created by Paweł Zgoda-Ferchmin on 14/08/2022.
//

import Foundation
import SwiftUI

enum FormViewKey: String, FormKey {
    case username
    case email
    case passowrd
    case firstName
    case lastName
    case number
    case country
    case terms
    case marketing

    var validationType: ValidationType {
        switch self {
        case .username: return .username
        case .passowrd: return .password
        case .terms: return .terms
        case .email: return .email
        default: return .none
        }
    }

    var keyboardType: UIKeyboardType {
        switch self {
        case .number: return .phonePad
        case .email: return .emailAddress
        default: return .default
        }
    }
}
