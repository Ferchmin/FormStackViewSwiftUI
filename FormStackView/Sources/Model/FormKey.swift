//
//  CaseIterable+Advanced.swift
//  FormStackViewApp
//
//  Created by Paweł Zgoda-Ferchmin on 25/07/2022.
//

import Foundation
import SwiftUI

public protocol FormKey {
    var validator: ValidatorProtocol { get }
    var keyboardType: UIKeyboardType { get }
    var rawValue: String { get }

    init?(rawValue: String)
}
