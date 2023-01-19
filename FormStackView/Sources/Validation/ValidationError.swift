//
//  ValidationError.swift
//  
//
//  Created by Paweł Zgoda-Ferchmin on 19/01/2023.
//

import Foundation

public protocol ValidationError: Error {
    var message: String { get }
}
