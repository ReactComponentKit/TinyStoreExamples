//
//  CountSwiftUIApp.swift
//  CountSwiftUI
//
//  Created by burt on 2022/04/14.
//

import SwiftUI

@main
struct CountSwiftUIApp: App {
    
    init() {
        defineAppStates()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
