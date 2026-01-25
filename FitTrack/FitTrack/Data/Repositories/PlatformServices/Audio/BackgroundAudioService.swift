//
//  BackgroundAudioService.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/17/26.
//

import AVFoundation

class BackgroundAudioService {
    
    private var audioPlayer: AVAudioPlayer?
    
    func startBackgroundAudio() {
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
        try? audioSession.setActive(true)
        
        guard let url = Bundle.main.url(forResource: "silence", withExtension: "mp3") else {
            return
        }
        
        audioPlayer = try? AVAudioPlayer(contentsOf: url)
        audioPlayer?.numberOfLoops = -1
        audioPlayer?.volume = 0.01
        audioPlayer?.play()
    }
    
    func stopBackgroundAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
        
        try? AVAudioSession.sharedInstance().setActive(false)
    }
}
