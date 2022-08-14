//
//  FormValues.swift
//  FormStackViewApp
//
//  Created by Paweł Zgoda-Ferchmin on 25/07/2022.
//

import Combine
import Common
import Foundation
import SwiftUI

class FormValues: ObservableObject {
    @Published var values: [FormValue]
    // TODO: Move this from FormValues to FormStackView
    @Published var focused: FormViewKey?
    // TODO: Add isValid to form
    // @Published var isValid: Bool?

    let validateSubject = PassthroughSubject<Void, Never>()

    init(values: [FormValue] = []) {
        self.values = values
    }
}

extension EnvironmentObject.Wrapper where ObjectType == FormValues {
    func text(for key: FormViewKey) -> Binding<String> {
        self.values
            .map(get: { $0.first(where: { $0.key == key.rawValue }) ?? .text(text: "", key: key.rawValue) },
                 set: { self.values.wrappedValue.replaced(value: $0) })
            .map(get: { $0.text ?? "" },
                 set: { .text(text: $0, key: key.rawValue) })
    }

    func isOn(for key: FormViewKey) -> Binding<Bool> {
        self.values
            .map(get: { $0.first(where: { $0.key == key.rawValue }) ?? .checkbox(value: false, key: key.rawValue) },
                 set: { self.values.wrappedValue.replaced(value: $0) })
            .map(get: { $0.isOn ?? false },
                 set: { .checkbox(value: $0, key: key.rawValue) })
    }
}
