//
//  FormValue+Extensions.swift
//  FormStackViewApp
//
//  Created by Paweł Zgoda-Ferchmin on 25/07/2022.
//

import Common
import Foundation

public extension FormValue {
    var key: String {
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

extension FormValue: Hashable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .text(_, let key): hasher.combine(key)
        case .checkbox(_, let key): hasher.combine(key)
        }
    }
}

extension FormValue: Identifiable {
    public var id: Self { self }
}

public extension Array where Element == FormValue {
    func replaced(value: FormValue) -> [FormValue] {
        var updated = self
        for (index, element) in self.enumerated() {
            guard element.key == value.key else { continue }
            updated.remove(at: index)
            updated.insert(value, at: index)
            return updated
        }
        updated.append(value)
        return updated
    }
}
