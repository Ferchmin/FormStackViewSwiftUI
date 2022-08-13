//
//  FormStackView.swift
//  FormStackViewApp
//
//  Created by Paweł Zgoda-Ferchmin on 18/07/2022.
//

import SwiftUI
import Common

// TODO: Custom keyboard toolbar?
struct FormStackView<Content: View>: View {
    @ObservedObject private var formValues: FormValues

    private let alignment: HorizontalAlignment
    private let spacing: CGFloat?
    private let arrows: Bool
    private let content: () -> Content

    var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            content()
        }
        .toolbar { ToolbarItemGroup(placement: .keyboard) { if arrows { FormStackViewKeyboardToolabar() } } }
        .environmentObject(formValues)
    }

    init(alignment: HorizontalAlignment = .center,
         spacing: CGFloat? = nil,
         arrows: Bool = true,
         values: FormValues = .init(),
         @ViewBuilder content: @escaping () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.arrows = arrows
        self.formValues = values
        self.content = content
    }
}

// TODO: Custom inputs order switching, skipping non-keyboard inputs?
private struct FormStackViewKeyboardToolabar: View {
    @EnvironmentObject var formValues: FormValues

    var body: some View {
        HStack {
            Button { formValues.focused = formValues.focused?.advanced(by: -1) } label: {
                Image(systemName: "arrowtriangle.up.fill")
            }
            Button { formValues.focused = formValues.focused?.advanced(by: 1) } label: {
                Image(systemName: "arrowtriangle.down.fill")
            }
            Spacer()
            Button("Done") { formValues.focused = nil }
                .buttonStyle(.borderless)
        }
        .buttonStyle(.bordered)
    }
}

struct FormStackView_Previews: PreviewProvider {
    static var previews: some View {
        FormStackView {
            TextInputView(key: .email)
            ToggleInputView(key: .marketing)
        }.environmentObject(FormValues())
    }
}
