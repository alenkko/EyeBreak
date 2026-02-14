//
//  EyeBreakApp.swift
//  EyeBreak
//
//  Created by Alen Jurina on 22.01.2026..
//

import SwiftUI
import UserNotifications

@main
struct EyeBreakApp: App {
    @StateObject private var timerManager = TimerManager()
    var body: some Scene {
        MenuBarExtra {
            MenuView()
                .environmentObject(timerManager)
        } label: {
            Text(timerManager.timeRemainingText)
                .monospacedDigit()
        }
        .menuBarExtraStyle(.window)
    }
}
