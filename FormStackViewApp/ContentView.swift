//
//  ContentView.swift
//  FormStackViewApp
//
//  Created by Paweł Zgoda-Ferchmin on 25/07/2022.
//

import FormStackView
import Foundation
import SwiftUI

private let values: [FormValue] = [.text(text: "Pawel", key: FormViewKey.username.rawValue),
                                   .text(text: "Qwe123!", key: FormViewKey.passowrd.rawValue),
                                   .checkbox(value: true, key: FormViewKey.terms.rawValue)]

struct ContentView: View {
    @ObservedObject private var formValues: FormValues<FormViewKey> = .init() // .init(values: values)

    var body: some View {
        NavigationView {
            ScrollView {
                FormStackView.FormStackView(spacing: 15, arrows: true, values: formValues) {
                    TextInputView(key: FormViewKey.username)
                    TextInputView(key: FormViewKey.email)
                    SecureTextInputView(key: FormViewKey.passowrd)
                    TextInputView(key: FormViewKey.firstName)
                    TextInputView(key: FormViewKey.lastName)
                    TextInputView(key: FormViewKey.number)
                    PickerInputView(key: FormViewKey.country, values: ["Poland", "United Kingdom", "Germany"])
                    ToggleInputView(key: FormViewKey.terms)
                    ToggleInputView(key: FormViewKey.marketing)
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
