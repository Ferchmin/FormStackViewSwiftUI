//
//  InputView.swift
//  FormStackViewApp
//
//  Created by Paweł Zgoda-Ferchmin on 18/07/2022.
//

import FormStackView
import Combine
import SwiftUI

struct TextInput: View {
    var key: FormKey

    var body: some View {
        TextInputReader(key: key) { proxy in
            VStack(alignment: .leading) {
                TextField(key.rawValue, text: proxy.text)
                    .padding()
                    .overlay { RoundedRectangle(cornerRadius: 16).stroke(borderColor(for: proxy), lineWidth: 1) }
                if let validationError = proxy.validationError {
                    Text(validationError)
                        .font(.system(size: 14))
                        .foregroundColor(.red)
                }
            }
        }
    }

    private func borderColor(for proxy: TextInputReaderProxy) -> Color {
        proxy.isFocused ? .blue : proxy.validationError == nil ? .gray : .red
    }
}

struct TextInputView_Previews: PreviewProvider {
    static var previews: some View {
        TextInput(key: ExampleFormKey.email)
            .environment(\.formValues, .constant([]))
    }
}
