//
//  FormStackView.swift
//  FormStackViewApp
//
//  Created by Paweł Zgoda-Ferchmin on 18/07/2022.
//

import SwiftUI

// TODO: Add custom keyboard toolbar?
public struct FormStackView<Content: View, Key: FormKey>: View {
    @ObservedObject private var formValues: FormValues<Key>

    private let alignment: HorizontalAlignment
    private let spacing: CGFloat?
    private let arrows: Bool
    private let content: () -> Content

    public var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            content()
        }
        .toolbar { ToolbarItemGroup(placement: .keyboard) { if arrows { FormStackViewKeyboardToolabar<Key>() } } }
        .environmentObject(formValues)
    }

    public init(alignment: HorizontalAlignment = .center,
         spacing: CGFloat? = nil,
         arrows: Bool = true,
         values: FormValues<Key> = .init(),
         @ViewBuilder content: @escaping () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.arrows = arrows
        self.formValues = values
        self.content = content
    }
}

// TODO: Custom inputs order switching, skipping non-keyboard inputs?
private struct FormStackViewKeyboardToolabar<Key: FormKey>: View {
    @EnvironmentObject var formValues: FormValues<Key>

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

public struct FormStackView_Previews: PreviewProvider {
    public static let values = FormValues<FormViewKey>()

    public static var previews: some View {
        FormStackView(values: values) {
            TextInputView(key: FormViewKey.email)
            ToggleInputView(key: FormViewKey.marketing)
        }
    }
}
