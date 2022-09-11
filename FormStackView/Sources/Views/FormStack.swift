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
    @State private var focusedKey: FormKey?
    @State private var valuesValidities: [String: Bool] = [:]

    private let validateSubject: PassthroughSubject<Void, Never>
    private let alignment: HorizontalAlignment
    private let spacing: CGFloat?
    private let content: () -> AnyView
    private let toolbarBuilder: (() -> AnyView)?

    public var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            content().any
        }
        .toolbar { ToolbarItemGroup(placement: .keyboard) { toolbarBuilder?() } }
        .environment(\.formValues, $values)
        .environment(\.focusedKey, $focusedKey)
        .environment(\.validateSubject, validateSubject)
        .environment(\.valuesValidities, $valuesValidities)
        .onChange(of: valuesValidities) { isValid = $0.allSatisfy { $0.value } }
    }

    public init<Content, Toolbar>(alignment: HorizontalAlignment = .center,
                                  spacing: CGFloat? = nil,
                                  values: Binding<[FormValue]>,
                                  validateSubject: PassthroughSubject<Void, Never> = .init(),
                                  isValid: Binding<Bool> = .constant(true),
                                  toolbarBuilder: @escaping @autoclosure () -> Toolbar,
                                  @ViewBuilder content: @escaping () -> Content) where Content: View, Toolbar: View {
        self._values = values
        self._isValid = isValid
        self.validateSubject = validateSubject
        self.alignment = alignment
        self.spacing = spacing
        self.toolbarBuilder = { toolbarBuilder().any }
        self.content = { content().any }
    }
}

public extension FormStack {
    init<Content: View>(alignment: HorizontalAlignment = .center,
                        spacing: CGFloat? = nil,
                        values: Binding<[FormValue]>,
                        validateSubject: PassthroughSubject<Void, Never> = .init(),
                        isValid: Binding<Bool> = .constant(true),
                        @ViewBuilder content: @escaping () -> Content) {
        self._values = values
        self._isValid = isValid
        self.validateSubject = validateSubject
        self.alignment = alignment
        self.spacing = spacing
        self.toolbarBuilder = { DefaultKeyboardToolbar().any }
        self.content = { content().any }
    }

    init<Content: View>(alignment: HorizontalAlignment = .center,
                        spacing: CGFloat? = nil,
                        values: Binding<[FormValue]>,
                        validateSubject: PassthroughSubject<Void, Never> = .init(),
                        isValid: Binding<Bool> = .constant(true),
                        toolbarBuilder: (() -> AnyView)?,
                        @ViewBuilder content: @escaping () -> Content) {
        self._values = values
        self._isValid = isValid
        self.validateSubject = validateSubject
        self.alignment = alignment
        self.spacing = spacing
        self.toolbarBuilder = toolbarBuilder
        self.content = { content().any }
    }
}

private struct FormStackView_Previews: PreviewProvider {
    private static let emailKey = ExampleFormKey.email
    private static let termsKey = ExampleFormKey.terms

    public static var previews: some View {
        FormStack(values: .constant([])) {
            TextInputReader(key: emailKey) { TextField(emailKey.rawValue, text: $0.text) }
            ToggleInputReader(key: termsKey) { Toggle(termsKey.rawValue, isOn: $0.isOn) }
        }
    }
}
