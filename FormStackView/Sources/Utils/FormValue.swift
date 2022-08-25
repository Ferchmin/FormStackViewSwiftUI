//
//  FormStackViewViewModel.swift
//  UACommon
//
//  Created by kuba on 31/10/2019.
//  Copyright © 2019 Mobile5. All rights reserved.
//

import Foundation

public enum FormValue: Equatable {
    case text(text: String, key: String), checkbox(value: Bool, key: String)
}

public extension Sequence where Iterator.Element == FormValue {

    func findText(for key: String) -> String? {
        let item = first { value -> Bool in
            if case .text(_, let valueKey) = value, valueKey == key { return true }
            return false
        }

        if case .text(let text, _) = item { return text }
        return nil
    }

    func findBoolean(for key: String) -> Bool? {
        let item = first { value -> Bool in
            if case .checkbox(_, let valueKey) = value, valueKey == key { return true }
            return false
        }

        if case .checkbox(let value, _) = item { return value }
        return nil
    }

}
