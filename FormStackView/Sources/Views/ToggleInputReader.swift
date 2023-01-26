//
//  InputView.swift
//  FormStackViewApp
//
//  Created by Paweł Zgoda-Ferchmin on 25/07/2022.
//

import SwiftUI

public struct ToggleInputReader<Content: View>: View {
    @EnvironmentObject private var formViewModel: FormStackViewModel

    @State private var validationError: ValidationError?

    private let key: FormKey
    private let content: (ToggleInputReaderProxy) -> Content

    private var isOn: Binding<Bool> { $formViewModel.values.isOn(for: key) }
    private var proxy: ToggleInputReaderProxy {
        ToggleInputReaderProxy(isOn: isOn,
                               validationError: formViewModel.validationErrors[key.rawValue]??.message)
    }

    public var body: some View {
        content(proxy)
            .onChange(of: isOn.wrappedValue) { validate($0) }
            .onReceive(formViewModel.validateSubject.filter { $0.shouldValidate(key: key) }) { _ in validate(isOn.wrappedValue) }
            .id(key.rawValue)
    }

    public init(key: FormKey, content: @escaping (ToggleInputReaderProxy) -> Content) {
        self.key = key
        self.content = content
    }

    private func validate(_ isOn: Bool) {
        validationError = key.validator.checkboxValidator?.validate(isOn: isOn)
        formViewModel.validationErrors[key.rawValue] = validationError
    }
}

public struct ToggleInputReaderProxy: Equatable {
    public var isOn: Binding<Bool>
    public var validationError: String?

    public static func == (lhs: ToggleInputReaderProxy, rhs: ToggleInputReaderProxy) -> Bool {
        lhs.validationError == rhs.validationError && lhs.isOn.wrappedValue == rhs.isOn.wrappedValue
    }
}
