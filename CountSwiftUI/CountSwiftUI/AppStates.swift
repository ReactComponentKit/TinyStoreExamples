//
//  AppStates.swift
//  CountSwiftUI
//
//  Created by burt on 2022/04/14.
//

import Foundation
import TinyStore

enum AppStates {
    case count
}

func defineAppStates() {
    state(name: AppStates.count, initialValue: 0)
}
