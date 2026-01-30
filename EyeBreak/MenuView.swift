//
//  MenuView.swift
//  EyeBreak
//
//  Created by Alen Jurina on 22.01.2026..
//

import SwiftUI

struct MenuView: View {
    @ObservedObject var timerManager: TimerManager
    @State private var isHovering = false

    var body: some View {
        Toggle("Turn on timer", isOn: $timerManager.isOn)
            .onChange(of: timerManager.isOn) { oldValue, newValue in
                if newValue {
                    timerManager.startTimer()
                } else {
                    timerManager.stopTimer()
                }
            }
        Toggle("Repeat timer", isOn: $timerManager.timerRepeat)
        Toggle("Use full screen pause", isOn: $timerManager.useFullScreenPause)
        HStack {
            Text("Duration: \(Int(timerManager.intervalMinutes)) min")
            Slider(value: $timerManager.intervalMinutes, in: 1...120, step: 1)
                .frame(width: 150)
        }
        HStack {
            Text("Pause duration: \(Int(timerManager.pauseInterval)) sec")
            Slider(value: $timerManager.pauseInterval, in: 1...120, step: 1)
                .frame(width: 150)
        }
        
        Divider()
        
        Button("Quit") {
            NSApplication.shared.terminate(nil)
        }
        .scaleEffect(isHovering ? 1.05 : 1.0)
        .foregroundColor(isHovering ? .white : .primary)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovering = hovering
            }
            if hovering {
                NSCursor.pointingHand.push()
            } else {
                NSCursor.pop()
            }
        }
    }
}

#Preview {
    MenuView(timerManager: TimerManager())
}
