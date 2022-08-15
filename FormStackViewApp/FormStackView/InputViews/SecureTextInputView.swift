//
//  InputViewSecureText.swift
//  FormStackViewApp
//
//  Created by Paweł Zgoda-Ferchmin on 25/07/2022.
//

import SwiftUI

struct SecureTextInputView<Key: FormKey>: View {
    private enum FocusedState: Hashable {
        case secure
        case regular
    }

    @State var isSecure: Bool = true
    @FocusState private var focusedState: FocusedState?

    var key: Key

    var body: some View {
        InputViewReader(key: key) { proxy in
            VStack(alignment: .leading) {
                Group {
                    if isSecure {
                        SecureField(key.rawValue, text: proxy.text)
                            .focused($focusedState, equals: .secure)
                    } else {
                        TextField(key.rawValue, text: proxy.text)
                            .focused($focusedState, equals: .regular)
                    }
                }
                .overlay(alignment: .trailing) { Button(isSecure ? "show" : "hide", action: { isSecure.toggle() }) }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(borderColor(for: proxy), lineWidth: 1))
                .onChange(of: proxy.isFocused) { focusedState = $0 ? isSecure ? .secure : .regular : nil }
                .onChange(of: isSecure) { if proxy.isFocused { focusedState = $0 ? .secure : .regular } }

                if let validationError = proxy.validationError {
                    Text(validationError)
                        .font(.system(size: 14))
                        .foregroundColor(.red)
                }
            }
        }
    }

    private func borderColor(for proxy: InputViewProxy) -> Color {
        proxy.isFocused ? .blue : proxy.validationError == nil ? .gray : .red
    }
}

struct SecureTextInputView_Previews: PreviewProvider {
    static var previews: some View {
        SecureTextInputView(key: FormViewKey.passowrd)
            .environmentObject(FormValues<FormViewKey>())
    }
}
