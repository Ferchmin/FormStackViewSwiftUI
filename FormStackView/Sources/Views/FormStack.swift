//
//  FormStackView.swift
//  FormStackViewApp
//
//  Created by Paweł Zgoda-Ferchmin on 18/07/2022.
//

import Combine
import SwiftUI

public struct FormStack: View {
    @StateObject private var viewModel: FormStackViewModel

    private let focusState: FocusState<String?> = .init()
    private let focusOrder: [FormKey]

    private let alignment: HorizontalAlignment
    private let spacing: CGFloat?
    private let content: [any View]
    private let toolbarBuilder: (() -> any View)?

    public var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            ForEach(content.indices, id: \.self) { index in
                content[index].any
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                if !focusOrder.isEmpty { toolbarBuilder?().any }
            }
        }
        .environmentObject(viewModel)
        .environment(\.focusState, focusState)
        .environment(\.focusOrder, focusOrder)
    }

    public init(alignment: HorizontalAlignment = .center,
                spacing: CGFloat? = nil,
                values: Binding<[FormValue]>,
                validateSubject: PassthroughSubject<Void, Never> = .init(),
                isValid: Binding<Bool> = .constant(true),
                toolbarBuilder: @escaping @autoclosure () -> some View,
                @ArrayBuilder<View> content: @escaping () -> [any View]) {
        self.focusOrder = content().compactMap { ($0 as? any Focusable)?.key }
        self.alignment = alignment
        self.spacing = spacing
        self.toolbarBuilder = toolbarBuilder
        self.content = content()

        self._viewModel = StateObject(wrappedValue: .init(values: values,
                                                          keys: content().compactMap { ($0 as? any Validatable)?.key },
                                                          isValid: isValid,
                                                          validateSubject: validateSubject))
    }
}

public extension FormStack {
    init(alignment: HorizontalAlignment = .center,
         spacing: CGFloat? = nil,
         values: Binding<[FormValue]>,
         validateSubject: PassthroughSubject<Void, Never> = .init(),
         isValid: Binding<Bool> = .constant(true),
         @ArrayBuilder<View> content: @escaping () -> [any View]) {
        self.focusOrder = content().compactMap { ($0 as? any Focusable)?.key }
        self.alignment = alignment
        self.spacing = spacing
        self.toolbarBuilder = { DefaultKeyboardToolbar().any }
        self.content = content()

        self._viewModel = StateObject(wrappedValue: .init(values: values,
                                                          keys: content().compactMap { ($0 as? any Validatable)?.key },
                                                          isValid: isValid,
                                                          validateSubject: validateSubject))
    }

    init(alignment: HorizontalAlignment = .center,
         spacing: CGFloat? = nil,
         values: Binding<[FormValue]>,
         validateSubject: PassthroughSubject<Void, Never> = .init(),
         isValid: Binding<Bool> = .constant(true),
         toolbarBuilder: (() -> some View)?,
         @ArrayBuilder<View> content: @escaping () -> [any View]) {
        self.focusOrder = content().compactMap { ($0 as? any Focusable)?.key }
        self.alignment = alignment
        self.spacing = spacing
        self.toolbarBuilder = toolbarBuilder
        self.content = content()

        self._viewModel = StateObject(wrappedValue: .init(values: values,
                                                          keys: content().compactMap { ($0 as? any Validatable)?.key },
                                                          isValid: isValid,
                                                          validateSubject: validateSubject))
    }
}

public class FormStackViewModel: ObservableObject {
    @Published var values: [FormValue]
    @Published var isValid: Bool = true
    @Published var validationErrors: [String: ValidationError?] = [:]

    let validateSubject: PassthroughSubject<Void, Never>

    private var subscriptions: [AnyCancellable] = []
    private let keys: [FormKey]

    public init(values: Binding<[FormValue]> = .constant([]),
                keys: [FormKey] = [],
                isValid: Binding<Bool> = .constant(true),
                validateSubject: PassthroughSubject<Void, Never> = .init()) {
        self.values = values.wrappedValue
        self.validateSubject = validateSubject
        self.keys = keys

        setupBinding(valuesBinding: values, isValidBinding: isValid)
    }

    private func setupBinding(valuesBinding: Binding<[FormValue]>, isValidBinding: Binding<Bool>) {
        $values
            .sink { valuesBinding.wrappedValue = $0 }
            .store(in: &subscriptions)

        validateSubject
            .map { [unowned self] in
                keys.map { validationErrors[$0.rawValue] ?? $0.validationType.validate(values.value(for: $0)) }
            }
            .map { $0.allSatisfy { $0 == nil } }
            .sink { isValidBinding.wrappedValue = $0 }
            .store(in: &subscriptions)

        $validationErrors
            .map { errors -> Bool in errors.values.allSatisfy { $0 == nil } }
            .sink { isValidBinding.wrappedValue = $0 }
            .store(in: &subscriptions)
    }
}

private struct FormStackView_Previews: PreviewProvider {
    private static let emailKey = ExampleFormKey.email
    private static let termsKey = ExampleFormKey.terms

    public static var previews: some View {
        FormStack(values: .constant([])) {
            TextInputReader(key: emailKey) { TextField("Email", text: $0.text) }
            ToggleInputReader(key: termsKey) { Toggle("Terms", isOn: $0.isOn) }
        }
    }
}
