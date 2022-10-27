//
//  File.swift
//  
//
//  Created by Paweł Zgoda-Ferchmin on 10/09/2022.
//

import Combine
import Foundation
import SwiftUI

// MARK: Focus state
private struct FocusStateKey: EnvironmentKey {
    static let defaultValue: FocusState<String?> = .init()
}

public extension EnvironmentValues {
    var focusState: FocusState<String?> {
        get { self[FocusStateKey.self] }
        set { self[FocusStateKey.self] = newValue }
    }
}

// MARK: Focus order
private struct FocusOrderKey: EnvironmentKey {
    static let defaultValue: [FormKey]? = nil
}

public extension EnvironmentValues {
    var focusOrder: [FormKey]? {
        get { self[FocusOrderKey.self] }
        set { self[FocusOrderKey.self] = newValue }
    }
}
