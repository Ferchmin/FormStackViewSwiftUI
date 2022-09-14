//
//  File.swift
//  
//
//  Created by Paweł Zgoda-Ferchmin on 10/09/2022.
//

import Combine
import Foundation
import SwiftUI

// MARK: Form values
private struct FormValuesKey: EnvironmentKey {
    static let defaultValue: Binding<[FormValue]> = .constant([])
}

public extension EnvironmentValues {
    var formValues: Binding<[FormValue]> {
        get { self[FormValuesKey.self] }
        set { self[FormValuesKey.self] = newValue }
    }
}

// MARK: Validate
private struct ValidateSubjectKey: EnvironmentKey {
    static let defaultValue: PassthroughSubject<Void, Never> = .init()
}

public extension EnvironmentValues {
    var validateSubject: PassthroughSubject<Void, Never> {
        get { self[ValidateSubjectKey.self] }
        set { self[ValidateSubjectKey.self] = newValue }
    }
}

// MARK: Is valid
private struct ValuesValiditiesKey: EnvironmentKey {
    static let defaultValue: Binding<[String: Bool]> = .constant([:])
}

public extension EnvironmentValues {
    var valuesValidities: Binding<[String: Bool]> {
        get { self[ValuesValiditiesKey.self] }
        set { self[ValuesValiditiesKey.self] = newValue }
    }
}

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
