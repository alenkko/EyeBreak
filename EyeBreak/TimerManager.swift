//
//  TimerManager.swift
//  EyeBreak
//
//  Created by Alen Jurina on 13.02.2026..
//
import Foundation
import Combine
import UserNotifications

class TimerManager: ObservableObject {
    @Published var timerInterval: Double = 20
    @Published var pauseInterval: Double = 20
    @Published var timeRemaining: TimeInterval = 0
    @Published var pauseTimeRemaining: TimeInterval = 0
    @Published var timerRepeat: Bool = false
    @Published var timerRunning = false
    private var timer: Timer?
    private var isOnPause = false
    @Published var timerPaused = false
    
    init() {
        requestNotificationPermission()
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }
    
    var timeRemainingText: String {
        let displayTime = isOnPause ? pauseTimeRemaining : timeRemaining
        let minutes = Int(displayTime) / 60
        let seconds = Int(displayTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func startTimer() {
        timeRemaining = timerInterval * 60
        timerRunning = true
        timerPaused = false
        isOnPause = false
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }
    
    func startPauseTimer() {
        pauseTimeRemaining = pauseInterval
        timerPaused = false
        isOnPause = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.pauseTick()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timeRemaining = 0
        timerRunning = false
        timerPaused = false
        isOnPause = false
    }
    
    private func tick() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            timerFinished()
        }
    }
    
    private func pauseTick() {
        if pauseTimeRemaining > 0 {
            pauseTimeRemaining -= 1
        } else {
            pauseFinished()
        }
    }
    
    private func timerFinished() {
        timer?.invalidate()
        timer = nil
        sendNotification()
        startPauseTimer()
    }
    
    private func pauseFinished() {
        timer?.invalidate()
        timer = nil
        sendPauseNotification()
        if timerRepeat {
            startTimer()
        } else {
            stopTimer()
        }
    }
    private func sendPauseNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Break over!"
        content.body = "Continue your work."
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    
    private func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Time for a break!"
        content.body = "Take a break to rest your eyes."
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func pauseCurrentTimer() {
        guard timerRunning && !timerPaused else { return }
        timer?.invalidate()
        timer = nil
        timerPaused = true
    }
        
    func resumeTimer() {
        guard timerPaused else { return }
        timerPaused = false
        
        if isOnPause {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                self?.pauseTick()
            }
        } else {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                self?.tick()
            }
        }
    }

}
