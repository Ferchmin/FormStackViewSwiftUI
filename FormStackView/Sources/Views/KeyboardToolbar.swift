//
//  File.swift
//  
//
//  Created by Paweł Zgoda-Ferchmin on 11/09/2022.
//

import SwiftUI

public struct DefaultKeyboardToolbar: View {
    @Environment(\.focusState) private var focusState
    @Environment(\.focusOrder) private var focusOrder

    private var next: String? {
        guard let key = focusState.wrappedValue else { return nil }
        return focusOrder?.map { $0.rawValue }.advanced(by: 1, from: key)
    }

    private var previous: String? {
        guard let key = focusState.wrappedValue else { return nil }
        return focusOrder?.map { $0.rawValue }.advanced(by: -1, from: key)
    }

    public var body: some View {
        HStack {
            Button { focusState.wrappedValue = previous } label: {
                Image(systemName: "arrowtriangle.up.fill")
            }
            .disabled(previous == nil)
            Button { focusState.wrappedValue = next } label: {
                Image(systemName: "arrowtriangle.down.fill")
            }
            .disabled(next == nil)
            Spacer()
            Button("Done") { focusState.wrappedValue = nil }
                .buttonStyle(.borderless)
        }
        .buttonStyle(.bordered)
    }
}
