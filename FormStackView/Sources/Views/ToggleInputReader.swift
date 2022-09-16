//
//  InputView.swift
//  FormStackViewApp
//
//  Created by Paweł Zgoda-Ferchmin on 25/07/2022.
//

import SwiftUI

public struct ToggleInputReader<Content: View>: View {
    @Environment(\.formValues) private var values
    @Environment(\.validateSubject) private var validateSubject
    @Environment(\.valuesValidities) private var isValid

    @State private var validationError: ValidationError?

    private let key: FormKey
    private let content: (ToggleInputReaderProxy) -> Content

    private var isOn: Binding<Bool> { values.isOn(for: key) }
    private var proxy: ToggleInputReaderProxy {
        ToggleInputReaderProxy(isOn: isOn,
                               validationError: validationError?.message)
    }

    public var body: some View {
        content(proxy)
            .onChange(of: isOn.wrappedValue) { validate($0) }
            .onReceive(validateSubject) { validate(isOn.wrappedValue) }
    }

    public init(key: FormKey, content: @escaping (ToggleInputReaderProxy) -> Content) {
        self.key = key
        self.content = content
    }

    private func validate(_ isOn: Bool) {
        validationError = key.validationType.checkboxValidator?.validate(isOn: isOn)
        isValid.wrappedValue[key.rawValue] = validationError == nil
    }
}

public struct ToggleInputReaderProxy: Equatable {
    public var isOn: Binding<Bool>
    public var validationError: String?

    public static func == (lhs: ToggleInputReaderProxy, rhs: ToggleInputReaderProxy) -> Bool {
        lhs.validationError == rhs.validationError && lhs.isOn.wrappedValue == rhs.isOn.wrappedValue
    }
}
