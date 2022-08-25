//
//  Binding+Map.swift
//  FormStackViewApp
//
//  Created by Paweł Zgoda-Ferchmin on 25/07/2022.
//

import Foundation
import SwiftUI

public extension Binding {
    func map<T>(get: @escaping (Value) -> T, set: @escaping (T) -> Value) -> Binding<T> {
        Binding<T>(get: { get(wrappedValue) },
                   set: { wrappedValue = set($0) })
    }
}
