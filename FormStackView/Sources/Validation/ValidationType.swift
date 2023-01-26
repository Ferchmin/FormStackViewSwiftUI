//
//  ValidationType.swift
//  
//
//  Created by Paweł Zgoda-Ferchmin on 26/01/2023.
//

import Foundation

public enum ValidationType {
    case all
    case keys([FormKey])

    func shouldValidate(key: FormKey) -> Bool {
        switch self {
        case .all: return true
        case .keys(let keys): return keys.contains { $0.rawValue == key.rawValue }
        }
    }
}
