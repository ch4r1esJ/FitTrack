//
//  BackgroundAudioManager.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/17/26.
//

import AVFoundation

class BackgroundAudioManager {
    static let shared = BackgroundAudioManager()
    
    private var audioPlayer: AVAudioPlayer?
    
    private init() {}
    
    func startBackgroundAudio() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try audioSession.setActive(true)
            
            guard let url = Bundle.main.url(forResource: "silence", withExtension: "mp3") else {
                return
            }
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.volume = 0.01
            audioPlayer?.play()
            
        } catch {
        }
    }
    
    func stopBackgroundAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
        
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
        }
    }
}
