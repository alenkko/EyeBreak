//
//  MenuView.swift
//  EyeBreak
//
//  Created by Alen Jurina on 22.01.2026..
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var timerManager: TimerManager
    
    var body: some View {
        VStack {
            if !timerManager.timerRunning {
                Button(action: {timerManager.startTimer()}) {
                    Text("Start timer")
                }
            } else {
                HStack {
                    if !timerManager.timerPaused {
                        Button(action: {timerManager.pauseCurrentTimer()}) {
                            Text("Pause timer")
                        }
                    } else {
                        Button(action: {timerManager.resumeTimer()}) {
                            Text("Resume timer")
                        }
                    }
                    Button(action: {timerManager.stopTimer()}) {
                        Text("Reset timer")
                    }
                }
            }
            Toggle("Repeat timer", isOn: $timerManager.timerRepeat)
            Divider()
            Slider(value: $timerManager.timerInterval, in: 0.2...60)
                .frame(width: 300)
            Text("Timer duration: \(Int(timerManager.timerInterval.rounded())) minutes")
            
            Slider(value: $timerManager.pauseInterval, in: 0.2...60)
                .frame(width: 300)
            Text("Pause duration: \(Int(timerManager.pauseInterval.rounded())) seconds")
        }
        .padding()
    }
}

#Preview {
    MenuView()
}
