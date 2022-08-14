//
//  InputView.swift
//  FormStackViewApp
//
//  Created by Paweł Zgoda-Ferchmin on 25/07/2022.
//

import Foundation
import SwiftUI


// TODO: Is this protocol needed?
// TODO: Make key any enum eg. protocol FormKey?
protocol InputView: View {
    var key: FormViewKey { get }
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

struct InputViewReader<Content: View>: InputView {
    @EnvironmentObject var formValues: FormValues
    @State var validationError: ValidationError?
    @FocusState var isFocused: Bool

    @State private var shouldValidate: Bool = false

    var key: FormViewKey
    var content: (InputViewProxy) -> Content

    private var text: Binding<String> { $formValues.text(for: key) }
    private var isOn: Binding<Bool> { $formValues.isOn(for: key) }

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
}

struct InputViewProxy {
    var text: Binding<String>
    var isOn: Binding<Bool>
    var validationError: String?
    var isFocused: Bool
}
