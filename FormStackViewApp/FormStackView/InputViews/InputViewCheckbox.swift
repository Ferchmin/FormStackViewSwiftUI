//
//  InputViewCheckbox.swift
//  FormStackViewApp
//
//  Created by Paweł Zgoda-Ferchmin on 25/07/2022.
//

import SwiftUI

struct ToggleInputView: View {
    var key: FormViewKey

    var body: some View {
        InputViewReader(key: key) { proxy in
            VStack(alignment: .leading) {
                HStack {
                    Toggle(key.rawValue, isOn: proxy.isOn)
                }
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
        ToggleInputView(key: .terms)
            .environmentObject(FormValues())
    }
}
