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

    private let validateSubject = PassthroughSubject<Void, Never>()

    var body: some View {
        NavigationView {
            ScrollView {
                FormStack(values: $values, validateSubject: validateSubject, isValid: $isValid) {
                    TextInput(key: ExampleFormKey.email)
                    SecureTextInput(key: ExampleFormKey.password)
                    TextInput(key: ExampleFormKey.firstName)
                    TextInput(key: ExampleFormKey.number)
                    PickerInput(key: ExampleFormKey.country, values: ["Poland", "United Kingdom", "Germany"])
                    ToggleInput(key: ExampleFormKey.terms)
                    ToggleInput(key: ExampleFormKey.marketing)
                    VStack(spacing: 5) {
                        Divider().padding()
                        ForEach(values) { value in
                            HStack {
                                Text("\(value.key.rawValue):")
                                Spacer()
                                Text("\(value.text ?? value.isOn?.description ?? "")")
                            }
                        }
                        Button("Validate", action: validateSubject.send)
                        if !isValid { Text("Form view has errors").foregroundColor(.red) }
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
