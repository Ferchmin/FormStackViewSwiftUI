//
//  FormValues.swift
//  FormStackViewApp
//
//  Created by Paweł Zgoda-Ferchmin on 25/07/2022.
//

import Combine
import Foundation
import SwiftUI

public class FormValues<Key: FormKey>: ObservableObject {
    @Published public var values: [FormValue]
    // TODO: Move focus handling from FormValues to FormStackView
    @Published public var focused: Key?
    // @Published var isValid: Bool? // TODO: Add isValid to form

    public let validateSubject = PassthroughSubject<Void, Never>()

    public init(values: [FormValue] = []) {
        self.values = values
    }
}

// Needs parameterized extensions to work (https://github.com/apple/swift/blob/main/docs/GenericsManifesto.md#parameterized-extensions).
// Now logic moved to InputViewReader.
//extension<Key: FormKeys> EnvironmentObject.Wrapper where ObjectType: FormValues<Key> {
//    func text(for key: Key) -> Binding<String> {
//        self.values
//            .map(get: { $0.first(where: { $0.key == key.rawValue }) ?? .text(text: "", key: key.rawValue) },
//                 set: { self.values.wrappedValue.replaced(value: $0) })
//            .map(get: { $0.text ?? "" },
//                 set: { .text(text: $0, key: key.rawValue) })
//    }
//
//    func isOn(for key: Key) -> Binding<Bool> {
//        self.values
//            .map(get: { $0.first(where: { $0.key == key.rawValue }) ?? .checkbox(value: false, key: key.rawValue) },
//                 set: { self.values.wrappedValue.replaced(value: $0) })
//            .map(get: { $0.isOn ?? false },
//                 set: { .checkbox(value: $0, key: key.rawValue) })
//    }
//}
