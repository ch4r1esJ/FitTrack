//
//  RestTimerPicker.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/15/26.
//

import SwiftUI

struct RestTimerPicker: View {
    @Binding var selection: Int
    @State private var showTimerSheet = false
    
    var body: some View {
        Button(action: {
            showTimerSheet = true
        }) {
            HStack(spacing: 4) {
                Image(systemName: "timer")
                Text("Rest Timer:")
                
                Text(formatTime(selection))
                    .contentTransition(.identity)
                    .monospacedDigit()
            }
            .font(.caption)
            .foregroundStyle(.blue)
        }
        .sheet(isPresented: $showTimerSheet) {
            TimerWheelSheet(selection: $selection)
                .presentationDetents([.fraction(0.4)])
                .presentationDragIndicator(.visible)
        }
    }
    
    func formatTime(_ totalSeconds: Int) -> String {
        if totalSeconds == 0 { return "OFF" }
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return minutes > 0 
            ? (seconds == 0 ? "\(minutes)m" : "\(minutes)m \(seconds)s") 
            : "\(seconds)s"
    }
}

struct TimerWheelSheet: View {
    @Binding var selection: Int
    @Environment(\.dismiss) var dismiss
    
    let times = [0] + Array(stride(from: 5, through: 300, by: 5))
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Rest Timer")
                .font(.headline)
                .padding(.top, 20)
            
            Picker("Rest Timer", selection: $selection) {
                ForEach(times, id: \.self) { time in
                    Text(formatWheelTime(time))
                        .tag(time)
                }
            }
            .pickerStyle(.wheel)
            .frame(maxHeight: 150)
            
            Button(action: { dismiss() }) {
                Text("Done")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
    }
    
    func formatWheelTime(_ totalSeconds: Int) -> String {
        if totalSeconds == 0 { return "OFF" }
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        
        if minutes > 0 {
            return seconds == 0 ? "\(minutes) min" : "\(minutes) min \(seconds) s"
        } else {
            return "\(seconds) s"
        }
    }
}
