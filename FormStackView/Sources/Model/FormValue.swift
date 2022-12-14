//
//  FormStackViewViewModel.swift
//  UACommon
//
//  Created by kuba on 31/10/2019.
//  Copyright © 2019 Mobile5. All rights reserved.
//

import Foundation
import SwiftUI

public enum FormValue: Equatable {
    case text(text: String, key: FormKey)
    case checkbox(value: Bool, key: FormKey)

    public static func == (lhs: FormValue, rhs: FormValue) -> Bool {
        lhs.key.rawValue == rhs.key.rawValue && lhs.text == rhs.text && lhs.isOn == rhs.isOn
    }
}

public extension FormValue {
    var key: FormKey {
        switch self {
        case .text(_, let key): return key
        case .checkbox(_, let key): return key
        }
    }

    var text: String? {
        switch self {
        case .text(let value, _): return value
        case .checkbox: return nil
        }
    }

    var isOn: Bool? {
        switch self {
        case .text: return nil
        case .checkbox(let value, _): return value
        }
    }
}

extension FormValue: Hashable , Identifiable {
    public var id: Self { self }
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .text(_, let key): hasher.combine(key.rawValue)
        case .checkbox(_, let key): hasher.combine(key.rawValue)
        }
    }
}

public extension Binding where Value == [FormValue] {
    func text(for key: FormKey) -> Binding<String> {
        self
            .map(get: { $0.first(where: { $0.key.rawValue == key.rawValue }) ?? .text(text: "", key: key) },
                 set: { wrappedValue.replaced(value: $0) })
            .map(get: { $0.text ?? "" },
                 set: { .text(text: $0, key: key) })
    }

    func isOn(for key: FormKey) -> Binding<Bool> {
        self
            .map(get: { $0.first(where: { $0.key.rawValue == key.rawValue }) ?? .checkbox(value: false, key: key) },
                 set: { wrappedValue.replaced(value: $0) })
            .map(get: { $0.isOn ?? false },
                 set: { .checkbox(value: $0, key: key) })
    }
}

public extension Array where Element == FormValue {
    func replaced(value: FormValue) -> [FormValue] {
        var newSelf = self
        for (index, element) in enumerated() {
            guard element.key.rawValue == value.key.rawValue else { continue }
            newSelf.remove(at: index)
            newSelf.insert(value, at: index)
            return newSelf
        }
        newSelf.append(value)
        return newSelf
    }
}
