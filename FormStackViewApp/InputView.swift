//
//  InputView.swift
//  FormStackViewApp
//
//  Created by Paweł Zgoda-Ferchmin on 18/07/2022.
//

import SwiftUI
import UICommonRx
import Common

class FormValues: ObservableObject {
    @Published var values: [FormValue] = []
}

struct InputViewText: View {
    private var key: FormViewKey

    @EnvironmentObject var formValues: FormValues

    fileprivate var validator: TextValidator.Type {
        key.validationType.validator
    }

    @State var validationError: ValidationError?

    var text: Binding<String> {
        $formValues.values
            .map(get: { $0.first(where: { $0.key == key.rawValue }) ?? .text(text: "", key: key.rawValue) },
                 set: { formValues.values.replaced(value: $0) })
            .map(get: { $0.text ?? "" },
                 set: { .text(text: $0, key: key.rawValue) })
    }

    var body: some View {
        VStack(alignment: .leading) {
            TextField("d", text: text)
                .onChange(of: text.wrappedValue) { validationError = validator.validate(text: $0) }
            if let validationError = validationError {
                Text(validationError.message)
                    .font(.system(size: 14))
                    .foregroundColor(.red)
            }
        }
    }

    init(key: FormViewKey) {
        self.key = key
    }
}

struct InputView_Previews: PreviewProvider {
    static let formValues = FormValues()

    static var previews: some View {
        InputViewText(key: .username)
            .environmentObject(formValues)
    }
}
