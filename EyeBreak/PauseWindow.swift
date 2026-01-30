//
//  PauseWindow.swift
//  EyeBreak
//
//  Created by Alen Jurina on 23.01.2026..
//

import SwiftUI

struct PauseWindow: View {
    @ObservedObject var timerManager: TimerManager
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            Text("\(Int(timerManager.pauseTimeRemaining))")
                .font(.system(size: 120, weight: .bold))
                .foregroundColor(.white)
        }
    }
}

#Preview {
    PauseWindow(timerManager: TimerManager())
}
