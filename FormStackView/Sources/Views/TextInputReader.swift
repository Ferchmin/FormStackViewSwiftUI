//
//  TextInputReader.swift
//  
//
//  Created by Paweł Zgoda-Ferchmin on 11/09/2022.
//

import Combine
import SwiftUI

public typealias FocusableValidatable = Validatable & Focusable

public protocol Validatable {
    associatedtype Key: FormKey
    var key: Key { get }
}

public protocol Focusable {
    associatedtype Key: FormKey
    var key: Key { get }
}

public struct TextInputReader<Content: View, Key: FormKey>: View {
    @EnvironmentObject private var formViewModel: FormStackViewModel
    @Environment(\.focusState) private var focusState
    @Environment(\.focusOrder) private var focusOrder
    @State private var shouldValidate: Bool = false

    public let key: Key

    private var text: Binding<String> { $formViewModel.values.text(for: key) }
    private var isFocused: Bool { focusState.wrappedValue == key.rawValue }
    private var next: String? { focusOrder?.map { $0.rawValue }.advanced(by: 1, from: key.rawValue) }
    private var proxy: TextInputReaderProxy {
        TextInputReaderProxy(text: text,
                             validationError: formViewModel.validationErrors[key.rawValue]??.message,
                             isFocused: isFocused)
    }

    public var body: some View {
        content(proxy)
            .focused(focusState.projectedValue, equals: key.rawValue)
            .onChange(of: isFocused) { if !$0 { shouldValidate = true; validate(text.wrappedValue) } }
            .onChange(of: text.wrappedValue) { if shouldValidate { validate($0) } }
            .onReceive(formViewModel.validateSubject) { shouldValidate = true; validate(text.wrappedValue) }
            .keyboardType(key.keyboardType)
            .submitLabel(next == nil ? .done : .next)
            .onSubmit { focusState.wrappedValue = next }
            .id(key.rawValue)
    }

    private let content: (TextInputReaderProxy) -> Content

    public init(key: Key, content: @escaping (TextInputReaderProxy) -> Content) {
        self.key = key
        self.content = content
    }

    private func validate(_ text: String) {
        formViewModel.validationErrors[key.rawValue] = key.validationType.textValidator?.validate(text: text)
    }
}

public struct TextInputReaderProxy: Equatable {
    public var text: Binding<String>
    public var validationError: String?
    public var isFocused: Bool

    public static func == (lhs: TextInputReaderProxy, rhs: TextInputReaderProxy) -> Bool {
        lhs.isFocused == rhs.isFocused && lhs.validationError == rhs.validationError && lhs.text.wrappedValue == rhs.text.wrappedValue
    }
}
