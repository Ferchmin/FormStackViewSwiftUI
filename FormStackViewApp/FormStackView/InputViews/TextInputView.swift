//
//  InputView.swift
//  FormStackViewApp
//
//  Created by Paweł Zgoda-Ferchmin on 18/07/2022.
//

import SwiftUI
import Common
import Combine

struct TextInputView<Key: FormKey>: View {
    @Environment(\.namespace) private var namespace

    var key: Key

    var body: some View {
        InputViewReader(key: key) { proxy in
            VStack(alignment: .leading) {
                TextField(key.rawValue, text: proxy.text)
                    .padding()
                    .matchedGeometryEffect(id: key,
                                           in: namespace,
                                           properties: .frame)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(borderColor(for: proxy), lineWidth: 1)
                    }
                if let validationError = proxy.validationError {
                    Text(validationError)
                        .font(.system(size: 14))
                        .foregroundColor(.red)
                }
            }
        }
    }

    private func borderColor(for proxy: InputViewProxy) -> Color {
        proxy.validationError == nil ? .gray : .red
    }
}

struct TextInputView_Previews: PreviewProvider {
    static var previews: some View {
        TextInputView(key: FormViewKey.username)
            .environmentObject(FormValues<FormViewKey>())
    }
}
