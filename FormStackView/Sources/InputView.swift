//
//  InputView.swift
//  FormStackViewApp
//
//  Created by Paweł Zgoda-Ferchmin on 25/07/2022.
//

import Foundation
import SwiftUI

// TODO: Is this protocol needed?
protocol InputView: View {
    associatedtype Key: FormKey
    var key: Key { get }
    var validationError: ValidationError? { get nonmutating set }
}

extension InputView {
    var textValidator: TextValidator.Type? { key.validationType.textValidator }
    var checkboxValidator: CheckBoxValidator.Type? { key.validationType.checkboxValidator }

    func validate(_ text: String) {
        guard let textValidator = textValidator else { return }
        validationError = textValidator.validate(text: text)
    }

    func validate(_ isOn: Bool) {
        guard let checkboxValidator = checkboxValidator else { return }
        validationError = checkboxValidator.validate(isOn: isOn)
    }
}

struct InputViewReader<Content: View, Key: FormKey>: InputView {
    internal init(key: Key, content: @escaping (InputViewProxy) -> Content) {
        self.key = key
        self.content = content
    }

    @EnvironmentObject var formValues: FormValues<Key>
    @State var validationError: ValidationError?
    @FocusState var isFocused: Bool

    @State private var shouldValidate: Bool = false

    var key: Key
    var content: (InputViewProxy) -> Content

    private var text: Binding<String> { text(for: key) }
    private var isOn: Binding<Bool> { isOn(for: key) }

    private var proxy: InputViewProxy {
        InputViewProxy(text: text,
                       isOn: isOn,
                       validationError: validationError?.message,
                       isFocused: isFocused)
    }

    var body: some View {
        content(proxy)
            .focused($isFocused)
            .onChange(of: isFocused) { if !$0 { shouldValidate = true; validate(text.wrappedValue) } }
            .onChange(of: isFocused) { if $0 { formValues.focused = key } }
            .onReceive(formValues.$focused) { isFocused = $0 == key }
            .onChange(of: text.wrappedValue) { if shouldValidate { validate($0) } }
            .onReceive(formValues.validateSubject) { shouldValidate = true; validate(text.wrappedValue) }
            .onChange(of: isOn.wrappedValue) { validate($0) }
            .onReceive(formValues.validateSubject) { validate(isOn.wrappedValue) }
            .keyboardType(key.keyboardType)
    }

    private func text(for key: Key) -> Binding<String> {
        $formValues.values
            .map(get: { $0.first(where: { $0.key == key.rawValue }) ?? .text(text: "", key: key.rawValue) },
                 set: { formValues.values.replaced(value: $0) })
            .map(get: { $0.text ?? "" },
                 set: { .text(text: $0, key: key.rawValue) })
    }

    private func isOn(for key: Key) -> Binding<Bool> {
        $formValues.values
            .map(get: { $0.first(where: { $0.key == key.rawValue }) ?? .checkbox(value: false, key: key.rawValue) },
                 set: { formValues.values.replaced(value: $0) })
            .map(get: { $0.isOn ?? false },
                 set: { .checkbox(value: $0, key: key.rawValue) })
    }
}

struct InputViewProxy {
    var text: Binding<String>
    var isOn: Binding<Bool>
    var validationError: String?
    var isFocused: Bool
}
