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

    private let valuesBinding: Binding<[FormValue]>

    private let focusState: FocusState<String?>
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
        .onChange(of: valuesBinding.wrappedValue) { viewModel.values = $0 }
        .environmentObject(viewModel)
        .environment(\.focusState, focusState)
        .environment(\.focusOrder, focusOrder)
    }

    public init(alignment: HorizontalAlignment = .center,
                spacing: CGFloat? = nil,
                values: Binding<[FormValue]>,
                validateSubject: PassthroughSubject<ValidationType, Never> = .init(),
                isValid: Binding<Bool> = .constant(true),
                topErrorKeySubject: PassthroughSubject<FormKey?, Never> = .init(),
                focusState: FocusState<String?> = .init(),
                toolbarBuilder: @escaping @autoclosure () -> some View,
                @ArrayBuilder<View> content: @escaping () -> [any View]) {
        self.focusOrder = content().compactMap { ($0 as? any Focusable)?.key }
        self.alignment = alignment
        self.spacing = spacing
        self.toolbarBuilder = toolbarBuilder
        self.content = content()
        self.focusState = focusState

        self.valuesBinding = values

        self._viewModel = StateObject(wrappedValue: .init(values: values,
                                                          keys: content().compactMap { ($0 as? any Validatable)?.key },
                                                          isValid: isValid,
                                                          topErrorKeySubject: topErrorKeySubject,
                                                          validateSubject: validateSubject))
    }
}

public extension FormStack {
    init(alignment: HorizontalAlignment = .center,
         spacing: CGFloat? = nil,
         values: Binding<[FormValue]>,
         validateSubject: PassthroughSubject<ValidationType, Never> = .init(),
         isValid: Binding<Bool> = .constant(true),
         topErrorKeySubject: PassthroughSubject<FormKey?, Never> = .init(),
         focusState: FocusState<String?> = .init(),
         @ArrayBuilder<View> content: @escaping () -> [any View]) {
        self.focusOrder = content().compactMap { ($0 as? any Focusable)?.key }
        self.alignment = alignment
        self.spacing = spacing
        self.toolbarBuilder = { DefaultKeyboardToolbar().any }
        self.content = content()
        self.focusState = focusState

        self.valuesBinding = values

        self._viewModel = StateObject(wrappedValue: .init(values: values,
                                                          keys: content().compactMap { ($0 as? any Validatable)?.key },
                                                          isValid: isValid,
                                                          topErrorKeySubject: topErrorKeySubject,
                                                          validateSubject: validateSubject))
    }

    init(alignment: HorizontalAlignment = .center,
         spacing: CGFloat? = nil,
         values: Binding<[FormValue]>,
         validateSubject: PassthroughSubject<ValidationType, Never> = .init(),
         isValid: Binding<Bool> = .constant(true),
         topErrorKeySubject: PassthroughSubject<FormKey?, Never> = .init(),
         focusState: FocusState<String?> = .init(),
         toolbarBuilder: (() -> some View)?,
         @ArrayBuilder<View> content: @escaping () -> [any View]) {
        self.focusOrder = content().compactMap { ($0 as? any Focusable)?.key }
        self.alignment = alignment
        self.spacing = spacing
        self.toolbarBuilder = toolbarBuilder
        self.content = content()
        self.focusState = focusState

        self.valuesBinding = values

        self._viewModel = StateObject(wrappedValue: .init(values: values,
                                                          keys: content().compactMap { ($0 as? any Validatable)?.key },
                                                          isValid: isValid,
                                                          topErrorKeySubject: topErrorKeySubject,
                                                          validateSubject: validateSubject))
    }
}

public class FormStackViewModel: ObservableObject {
    @Published var values: [FormValue]
    @Published var isValid: Bool = true
    @Published var validationErrors: [String: ValidationError?] = [:]

    let validateSubject: PassthroughSubject<ValidationType, Never>

    private var subscriptions: [AnyCancellable] = []
    private let keys: [FormKey]

    public init(values: Binding<[FormValue]> = .constant([]),
                keys: [FormKey] = [],
                isValid: Binding<Bool> = .constant(true),
                topErrorKeySubject: PassthroughSubject<FormKey?, Never> = .init(),
                validateSubject: PassthroughSubject<ValidationType, Never> = .init()) {
        self.values = values.wrappedValue
        self.validateSubject = validateSubject
        self.keys = keys

        setupBinding(valuesBinding: values, isValidBinding: isValid, topErrorKeySubject: topErrorKeySubject)
    }

    private func setupBinding(valuesBinding: Binding<[FormValue]>,
                              isValidBinding: Binding<Bool>,
                              topErrorKeySubject: PassthroughSubject<FormKey?, Never>) {
        $values
            .sink { valuesBinding.wrappedValue = $0 }
            .store(in: &subscriptions)

        validateSubject
            .sink { [unowned self] validationType in
                let errors = self.keys
                    .filter { validationType.shouldValidate(key: $0) }
                    .map { ($0, $0.validator.validate(values.value(for: $0))) }
                    .filter { $0.1 != nil }

                self.validationErrors = errors.reduce([String: ValidationError?]()) { result, element in
                    var newResult = result
                    newResult[element.0.rawValue] = element.1
                    return newResult
                }

                isValidBinding.wrappedValue = validationErrors.values.allSatisfy { $0 == nil }
                topErrorKeySubject.send(errors.first?.0)
            }
            .store(in: &subscriptions)
    }
}
