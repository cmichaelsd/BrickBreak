//
//  SoundController.swift
//  BrickBreak
//
//  Created by Cole Michaels on 7/13/20.
//  Copyright © 2020 cmichaelsd. All rights reserved.
//

import AVFoundation

class SoundController {
    static let shared = SoundController()
    var backgroundMusicPlayer: AVAudioPlayer?
    var popEffect: AVAudioPlayer?
    
    private init() {
        popEffect = preloadSoundEffect("pop.wav")
    }
    
    func preloadSoundEffect(_ filename: String) -> AVAudioPlayer?  {
        if let url = Bundle.main.url(forResource: filename, withExtension: nil) {
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                return player
            } catch {
                print("file \(filename) not found")
            }
        }
        return nil
    }
    
    func playBackgroundMusic(_ filename: String) {
        backgroundMusicPlayer = preloadSoundEffect(filename)
        // -1 loops indicates indefinite loop
        backgroundMusicPlayer?.numberOfLoops = -1
        backgroundMusicPlayer?.play()
    }
    
    func playPopEffect() {
        popEffect?.play()
    }
    
}
