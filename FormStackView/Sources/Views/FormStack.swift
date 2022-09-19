//
//  FormStackView.swift
//  FormStackViewApp
//
//  Created by Paweł Zgoda-Ferchmin on 18/07/2022.
//

import Combine
import SwiftUI

public struct FormStack: View {
    @Binding private var values: [FormValue]
    @Binding private var isValid: Bool
    @State private var valuesValidities: [String: Bool] = [:]

    private let focusState: FocusState<String?> = .init()
    private let focusOrder: [FormKey]
    private let validateSubject: PassthroughSubject<Void, Never>
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
        .environment(\.formValues, $values)
        .environment(\.focusState, focusState)
        .environment(\.focusOrder, focusOrder)
        .environment(\.validateSubject, validateSubject)
        .environment(\.valuesValidities, $valuesValidities)
        .onChange(of: valuesValidities) { isValid = $0.allSatisfy { $0.value } }
    }

    public init(alignment: HorizontalAlignment = .center,
                spacing: CGFloat? = nil,
                values: Binding<[FormValue]>,
                validateSubject: PassthroughSubject<Void, Never> = .init(),
                isValid: Binding<Bool> = .constant(true),
                toolbarBuilder: @escaping @autoclosure () -> some View,
                @ArrayBuilder<View> content: @escaping () -> [any View]) {
        self._values = values
        self._isValid = isValid
        self.focusOrder = content().compactMap { ($0 as? any FocusableView)?.key }
        self.validateSubject = validateSubject
        self.alignment = alignment
        self.spacing = spacing
        self.toolbarBuilder = toolbarBuilder
        self.content = content()
    }
}

public extension FormStack {
    init(alignment: HorizontalAlignment = .center,
         spacing: CGFloat? = nil,
         values: Binding<[FormValue]>,
         validateSubject: PassthroughSubject<Void, Never> = .init(),
         isValid: Binding<Bool> = .constant(true),
         @ArrayBuilder<View> content: @escaping () -> [any View]) {
        self._values = values
        self._isValid = isValid
        self.focusOrder = content().compactMap { ($0 as? any FocusableView)?.key }
        self.validateSubject = validateSubject
        self.alignment = alignment
        self.spacing = spacing
        self.toolbarBuilder = { DefaultKeyboardToolbar().any }
        self.content = content()
    }

    init(alignment: HorizontalAlignment = .center,
         spacing: CGFloat? = nil,
         values: Binding<[FormValue]>,
         validateSubject: PassthroughSubject<Void, Never> = .init(),
         isValid: Binding<Bool> = .constant(true),
         toolbarBuilder: (() -> some View)?,
         @ArrayBuilder<AnyView> content: @escaping () -> [AnyView]) {
        self._values = values
        self._isValid = isValid
        self.focusOrder = content().compactMap { ($0 as? any FocusableView)?.key }
        self.validateSubject = validateSubject
        self.alignment = alignment
        self.spacing = spacing
        self.toolbarBuilder = toolbarBuilder
        self.content = content()
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
