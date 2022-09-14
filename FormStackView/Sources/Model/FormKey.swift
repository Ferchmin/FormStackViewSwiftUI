//
//  CaseIterable+Advanced.swift
//  FormStackViewApp
//
//  Created by Paweł Zgoda-Ferchmin on 25/07/2022.
//

import Foundation
import SwiftUI

public protocol FormKey {
    var validationType: ValidationType { get }
    var keyboardType: UIKeyboardType { get }
    var rawValue: String { get }

    init?(rawValue: String)
}

enum ExampleFormKey: String, FormKey {
    case username
    case email
    case password
    case number
    case terms

    var validationType: ValidationType { Validation.none }
    var keyboardType: UIKeyboardType { .default }
}

public extension Array where Element: Equatable {
    func advanced(by n: Int, from element: Element) -> Element? {
        guard let index = firstIndex(of: element),
              indices.contains(index + n) else { return nil }
        return self[index+n]
    }
}
