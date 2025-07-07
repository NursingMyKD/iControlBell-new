// SoundManager.swift
// Manages audio playback for confirmation sounds

import AVFoundation
import Foundation

/// Manages audio playback for app sound effects.
@MainActor
class SoundManager: ObservableObject {
    static let shared = SoundManager()
    private var audioPlayer: AVAudioPlayer?
    
    private init() {}
    
    /// Plays a confirmation sound for button taps.
    func playConfirmationSound() {
        guard let url = Bundle.main.url(forResource: "success", withExtension: "mp3") else {
            print("[SoundManager] Could not find success.mp3 file")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("[SoundManager] Error playing sound: \(error.localizedDescription)")
        }
    }
    
    /// Plays a sound file by name (without extension).
    func playSound(named soundName: String, withExtension ext: String = "mp3") {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: ext) else {
            print("[SoundManager] Could not find \(soundName).\(ext) file")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("[SoundManager] Error playing sound: \(error.localizedDescription)")
        }
    }
}
