//
//  CaseIterable+Advanced.swift
//  FormStackViewApp
//
//  Created by Paweł Zgoda-Ferchmin on 25/07/2022.
//

import Foundation

protocol FormKeys: Hashable, CaseIterable {
    var validationType: ValidationType { get }
}

extension FormKeys {
    func advanced(by n: Int) -> Self {
        let all = Array(Self.allCases)
        let idx = (all.firstIndex(of: self)! + n) % all.count
        if idx >= 0 {
            return all[idx]
        } else {
            return all[all.count + idx]
        }
    }
}
