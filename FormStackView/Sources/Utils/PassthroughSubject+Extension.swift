//
//  PassthroughSubject+Extension.swift
//  
//
//  Created by Paweł Zgoda-Ferchmin on 26/01/2023.
//

import Combine
import Foundation

public extension PassthroughSubject where Output == ValidationType, Failure == Never {
    func send() {
        self.send(.all)
    }
}
