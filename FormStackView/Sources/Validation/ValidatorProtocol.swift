//
//  ValidatorProtocol.swift
//  
//
//  Created by Paweł Zgoda-Ferchmin on 19/01/2023.
//

import Foundation

public protocol ValidatorProtocol {
    var textValidator: TextValidator? { get }
    var checkboxValidator: CheckBoxValidator? { get }

    func validate(_ formValue: FormValue?) -> ValidationError?
}

public protocol TextValidator {
    func validate(text: String) -> ValidationError?
}

public protocol CheckBoxValidator {
    func validate(isOn: Bool) -> ValidationError?
}

public extension ValidatorProtocol {
    func validate(_ formValue: FormValue?) -> ValidationError? {
        switch formValue {
        case .text(let text, _): return textValidator?.validate(text: text)
        case .checkbox(let isOn, _): return checkboxValidator?.validate(isOn: isOn)
        case .none: return textValidator?.validate(text: "") ?? checkboxValidator?.validate(isOn: false)
        }
    }
}
