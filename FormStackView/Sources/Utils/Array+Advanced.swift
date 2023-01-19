//
//  Array+Advanced.swift
//  
//
//  Created by Paweł Zgoda-Ferchmin on 19/01/2023.
//

import Foundation

public extension Array where Element: Equatable {
    func advanced(by n: Int, from element: Element) -> Element? {
        guard let index = firstIndex(of: element),
              indices.contains(index + n) else { return nil }
        return self[index+n]
    }
}
