//
//  MultiplicationGameApp.swift
//  MultiplicationGame
//
//  Created by Alison Gorman on 1/27/21.
//

import SwiftUI

@main
struct MultiplicationGameApp: App {
    @StateObject var userSettings = UserSettings()
    
    var body: some Scene {
        WindowGroup {
            MotherView().environmentObject(userSettings)
        }
    }
}

