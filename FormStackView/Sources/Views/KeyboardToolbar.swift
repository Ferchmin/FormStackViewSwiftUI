//
//  File.swift
//  
//
//  Created by Paweł Zgoda-Ferchmin on 11/09/2022.
//

import SwiftUI

public struct DefaultKeyboardToolbar: View {
    @Environment(\.focusedKey) var focusedKey

    public var body: some View {
        HStack {
            Button { focusedKey.wrappedValue = focusedKey.wrappedValue?.previous } label: {
                Image(systemName: "arrowtriangle.up.fill")
            }
            Button { focusedKey.wrappedValue = focusedKey.wrappedValue?.next } label: {
                Image(systemName: "arrowtriangle.down.fill")
            }
            Spacer()
            Button("Done") { focusedKey.wrappedValue = nil }
                .buttonStyle(.borderless)
        }
        .buttonStyle(.bordered)
    }
}
