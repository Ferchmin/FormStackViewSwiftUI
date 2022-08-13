//
//  FormStackViewAppApp.swift
//  FormStackViewApp
//
//  Created by Paweł Zgoda-Ferchmin on 18/07/2022.
//

import SwiftUI

@main
struct FormStackViewApp: App {
    @State var formValues: FormValues = .init()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
