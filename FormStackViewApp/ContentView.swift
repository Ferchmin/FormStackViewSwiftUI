//
//  ContentView.swift
//  FormStackViewApp
//
//  Created by Paweł Zgoda-Ferchmin on 25/07/2022.
//

import Combine
import FormStackView
import Foundation
import SwiftUI

private let inputValues: [FormValue] = [.text(text: "mail@mail.com", key: ExampleFormKey.email),
                                        .text(text: "Qwe123!", key: ExampleFormKey.password),
                                        .checkbox(value: true, key: ExampleFormKey.terms)]

struct ContentView: View {
    @State private var values: [FormValue] = [] // inputValues
    @State private var isValid: Bool = true
    @FocusState private var focusState: String?

    private let validateSubject = PassthroughSubject<ValidationType, Never>()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 5) {
                    FormStack(values: $values, validateSubject: validateSubject, isValid: $isValid, focusState: _focusState) {
                        TextInput(key: .email)
                        TextInput(key: .firstName)
                        SecureTextInput(key: .password)
                        PickerInput(key: .country, values: ["PL", "UK", "DE"])
                        TextInput(key: .number)
                        ToggleInput(key: .terms)
                        ToggleInput(key: .marketing)
                    }
                    Divider().padding()
                    ForEach(values) { value in
                        HStack {
                            Text("\(value.key.rawValue):")
                            Text("\(value.text ?? value.isOn?.description ?? "")")
                        }
                    }
                    Spacer()
                    Button("Validate") {
                        validateSubject.send(.all)
                    }
                    Button("Validate password") {
                        validateSubject.send(.keys([ExampleFormKey.password]))
                    }
                    if !isValid {
                        Text("Form view has errors").foregroundColor(.red)
                    }
                    Button("REPLACE") {
                        values = [.text(text: "test@test.pl", key: ExampleFormKey.email)]
                    }
                }
                .padding()
            }
            .navigationTitle("Example form")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
