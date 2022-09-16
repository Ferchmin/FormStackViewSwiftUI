//
//  InputViewCheckbox.swift
//  FormStackViewApp
//
//  Created by Paweł Zgoda-Ferchmin on 25/07/2022.
//

import FormStackView
import SwiftUI

struct ToggleInput: View {
    var key: ExampleFormKey

    var body: some View {
        ToggleInputReader(key: key) { proxy in
            VStack(alignment: .leading) {
                Toggle(key.rawValue, isOn: proxy.isOn)
                    .padding(.horizontal)
                if let validationError = proxy.validationError {
                    Text(validationError)
                        .font(.system(size: 14))
                        .foregroundColor(.red)
                }
            }
        }
    }
}

struct InputViewCheckbox_Previews: PreviewProvider {
    static var previews: some View {
        ToggleInput(key: .terms)
            .environment(\.formValues, .constant([]))
    }
}
