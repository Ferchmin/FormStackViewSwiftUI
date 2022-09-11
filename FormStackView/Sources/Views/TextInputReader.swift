//
//  TextInputReader.swift
//  
//
//  Created by Paweł Zgoda-Ferchmin on 11/09/2022.
//

import SwiftUI

public struct TextInputReader<Content: View>: View {
    @Environment(\.focusedKey) private var focusedKey
    @Environment(\.formValues) private var values
    @Environment(\.validateSubject) private var validateSubject
    @Environment(\.valuesValidities) private var isValid

    @State private var validationError: ValidationError?
    @State private var shouldValidate: Bool = false

    @FocusState private var isFocused: Bool

    private let key: FormKey
    private let content: (TextInputReaderProxy) -> Content

    private var text: Binding<String> { values.text(for: key) }
    private var proxy: TextInputReaderProxy {
        TextInputReaderProxy(text: text,
                             validationError: validationError?.message,
                             isFocused: isFocused)
    }

    public var body: some View {
        content(proxy)
            .onChange(of: isFocused) { if $0 { focusedKey.wrappedValue = key } }
            .focused($isFocused)
            .onChange(of: isFocused) { if !$0 { shouldValidate = true; validate(text.wrappedValue) } }
            .onChange(of: focusedKey.wrappedValue?.rawValue) { isFocused = $0 == key.rawValue }
            .onChange(of: text.wrappedValue) { if shouldValidate { validate($0) } }
            .onReceive(validateSubject) { shouldValidate = true; validate(text.wrappedValue) }
            .keyboardType(key.keyboardType)
            .submitLabel(focusedKey.wrappedValue?.next == nil ? .done : .next)
            .onSubmit { focusedKey.wrappedValue = focusedKey.wrappedValue?.next }
    }

    public init(key: FormKey, content: @escaping (TextInputReaderProxy) -> Content) {
        self.key = key
        self.content = content
    }

    private func validate(_ text: String) {
        validationError = key.validationType.textValidator?.validate(text: text)
        isValid.wrappedValue[key.rawValue] = validationError == nil
    }
}
