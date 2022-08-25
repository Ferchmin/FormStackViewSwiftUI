//
//  CaseIterable+Advanced.swift
//  FormStackViewApp
//
//  Created by Paweł Zgoda-Ferchmin on 25/07/2022.
//

import Foundation
import SwiftUI

public protocol FormKey: Hashable, CaseIterable {
    var validationType: ValidationType { get }
    var keyboardType: UIKeyboardType { get }
    var rawValue: String { get }
}

// TODO: Next/prev based on order in FormView not of enum
public extension FormKey {
    func advanced(by n: Int) -> Self {
        let all = Array(Self.allCases)
        let idx = (all.firstIndex(of: self)! + n) % all.count
        if idx >= 0 {
            return all[idx]
        } else {
            return all[all.count + idx]
        }
    }
}
