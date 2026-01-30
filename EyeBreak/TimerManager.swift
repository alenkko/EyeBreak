//
//  TimerManager.swift
//  EyeBreak
//
//  Created by Alen Jurina on 22.01.2026..
//

import Foundation
import UserNotifications
import Combine
import AppKit
import SwiftUI

class TimerManager: ObservableObject {
    @Published var isOn = false
    @Published var useFullScreenPause = false
    @Published var timerRepeat = true
    @Published var intervalMinutes: Double = 20
    @Published var timeRemaining: TimeInterval = 0
    
    @Published var isOnPause = false
    @Published var pauseInterval: Double = 20
    @Published var pauseTimeRemaining: TimeInterval = 0
    
    var pauseWindow: NSWindow?
    
    var timeRemainingText: String {
        if isOnPause {
            return String(format: "Pause %02d", Int(pauseTimeRemaining))
        } else {
            let minutes = Int(timeRemaining) / 60
            let seconds = Int(timeRemaining) % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    private var timer: Timer?
    
    init() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound]
        ) { granted, _ in
            print(granted ? "Dozvola dana" : "Dozvola odbijena")
        }
    }

    func startTimer() {
        stopTimer()
        isOnPause = false
        timeRemaining = intervalMinutes * 60

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                if self.useFullScreenPause {
                    DispatchQueue.main.async {
                        let pauseWindow = NSWindow(
                            contentRect: NSScreen.main!.frame,
                            styleMask: [.borderless],
                            backing: .buffered,
                            defer: false
                        )
                        pauseWindow.level = .floating
                        pauseWindow.isOpaque = false
                        pauseWindow.backgroundColor = .clear
                        pauseWindow.contentView = NSHostingView(rootView: PauseWindow(timerManager: self))
                        pauseWindow.orderFrontRegardless()
                        
                        self.pauseWindow = pauseWindow
                        self.startPauseTimer()
                    }
                } else {
                    self.sendNotification()
                    self.startPauseTimer()
                }
            }
        }
    }
    
    func startPauseTimer() {
        stopTimer()
        isOnPause = true
        pauseTimeRemaining = pauseInterval

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.pauseTimeRemaining > 0 {
                self.pauseTimeRemaining -= 1
            } else {
                self.isOnPause = false
                self.stopTimer()
                DispatchQueue.main.async {
                    self.pauseWindow?.close()
                    self.pauseWindow = nil
                }
                if self.timerRepeat {
                    self.sendPauseNotification()
                    self.startTimer()
                }
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Rest your eyes"
        content.body = "Look in the distance."
        content.sound = .default
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        UNUserNotificationCenter.current().add(request)
        print("Vrijeme za pauzu!")
    }
    
    private func sendPauseNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Rest is over"
        content.body = "Continue your work."
        content.sound = .default
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        UNUserNotificationCenter.current().add(request)
        print("Odmor gotov!")
    }
}
