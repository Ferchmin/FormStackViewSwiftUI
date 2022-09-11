//
//  CaseIterable+Advanced.swift
//  FormStackViewApp
//
//  Created by Paweł Zgoda-Ferchmin on 25/07/2022.
//

import Foundation
import SwiftUI

public typealias CaseIterableFormKey = FormKey & CaseIterable & Equatable

public protocol FormKey {
    var validationType: ValidationType { get }
    var keyboardType: UIKeyboardType { get }

    var next: Self? { get }
    var previous: Self? { get }

    var rawValue: String { get }

    init?(rawValue: String)
}

public extension FormKey {
    var validationType: ValidationType { .none }
    var keyboardType: UIKeyboardType { .default }
}

enum ExampleFormKey: String, CaseIterableFormKey {
    case username
    case email
    case password
    case number
    case terms
}

public extension FormKey where Self: CaseIterable & Equatable {
    var next: Self? { advanced(by: 1) }
    var previous: Self? { advanced(by: -1) }

    private func advanced(by n: Int) -> Self? {
        let all = Array(Self.allCases)
        let index = all.firstIndex(of: self)! + n
        guard all.indices.contains(index) else { return nil }
        return all[index]
    }
}
