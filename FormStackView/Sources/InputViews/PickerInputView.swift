//
//  PickerInputView.swift
//  FormStackViewApp
//
//  Created by Paweł Zgoda-Ferchmin on 12/08/2022.
//

import Foundation
import SwiftUI

struct PickerInputView<Key: FormKey>: View {
    var key: Key
    var values: [String]

    var body: some View {
        InputViewReader(key: key) { proxy in
            VStack {
                HStack {
                    Text(key.rawValue + ":")
                    Spacer()
                    Picker(selection: proxy.text, label: Text("Test")) {
                        ForEach(values, id: \.self) { Text($0) }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(borderColor(for: proxy), lineWidth: 1))
            }
        }
    }

    private func borderColor(for proxy: InputViewProxy) -> Color {
        proxy.isFocused ? .blue : proxy.validationError == nil ? .gray : .red
    }
}

struct PickerInputView_Previews: PreviewProvider {
    static var previews: some View {
        PickerInputView(key: FormViewKey.username,
                        values: ["Poland", "UK", "Germany"])
            .environmentObject(FormValues<FormViewKey>())
    }
}
