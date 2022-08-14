//
//  ContentView.swift
//  FormStackViewApp
//
//  Created by Paweł Zgoda-Ferchmin on 25/07/2022.
//

import Foundation
import SwiftUI
import Common

private let values: [FormValue] = [.text(text: "Pawel", key: FormViewKey.username.rawValue),
                                   .text(text: "Qwe123!", key: FormViewKey.passowrd.rawValue),
                                   .checkbox(value: true, key: FormViewKey.terms.rawValue)]

struct ContentView: View {
    @ObservedObject private var formValues: FormValues = .init() // .init(values: values)

    var body: some View {
        NavigationView {
            ScrollView {
                FormStackView(spacing: 15, arrows: true, values: formValues) {
                    TextInputView(key: .username)
                    TextInputView(key: .email)
                    SecureTextInputView(key: .passowrd)
                    TextInputView(key: .firstName)
                    TextInputView(key: .lastName)
                    TextInputView(key: .number)
                    PickerInputView(key: .country, values: ["Poland", "United Kingdom", "Germany"])
                    ToggleInputView(key: .terms)
                    ToggleInputView(key: .marketing)
                    VStack(spacing: 5) {
                        Divider().padding()
                        ForEach(formValues.values) { value in
                            HStack {
                                Text("\(value.key):")
                                Spacer()
                                Text("\(value.text ?? value.isOn?.description ?? "")")
                            }
                        }
                        Button("Validate", action: formValues.validateSubject.send)
                    }
                }
                .padding()
            }
            .navigationTitle("Example form")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
