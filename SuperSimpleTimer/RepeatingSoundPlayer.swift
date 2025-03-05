import SwiftUI

@Observable
@MainActor
class SoundManager: NSObject, NSSoundDelegate {
    var selectedSound: Sound {
        didSet {
            Self.userDefaults.set(selectedSound.rawValue, forKey: Self.selectedSoundNameKey)
        }
    }
    
    var soundOffset: Double {
        didSet {
            Self.userDefaults.set(soundOffset, forKey: Self.soundOffsetKey)
        }
    }
    
    var isSoundEnabled: Bool {
        didSet {
            Self.userDefaults.set(isSoundEnabled, forKey: Self.soundEnabledKey)
        }
    }
    var repeatSound: Bool {
        didSet {
            Self.userDefaults.set(repeatSound, forKey: Self.repeatSoundKey)
        }
    }
    
    private var sound: NSSound?
    private(set) var isPlaying = false
    
    override init() {
        self.selectedSound = Self.userDefaults.string(forKey: Self.selectedSoundNameKey).flatMap { Sound(rawValue: $0) } ?? .blow
        self.soundOffset = Self.userDefaults.value(forKey: Self.soundOffsetKey) as? Double ?? 0.2
        self.isSoundEnabled = Self.userDefaults.value(forKey: Self.soundEnabledKey) as? Bool ?? true
        self.repeatSound = Self.userDefaults.value(forKey: Self.repeatSoundKey) as? Bool ?? true
    }
    
    func start() {
        if isPlaying || !isSoundEnabled {
            return
        }
        
        playSound()
    }
    
    func stop() {
        isPlaying = false
        sound?.stop()
    }
    
    private func playSound() {
        if sound == nil || sound!.name != selectedSound.rawValue {
            sound = NSSound(selectedSound)
        }
        
        if let sound = sound {
            sound.delegate = self
            isPlaying = true
            sound.play()
        } else {
            // TODO: - Find a better solution to default case (doesn't repeat)
            // - Report error that sound couldn't be initialized
            NSSound.beep()
        }
    }
    
    func sound(_ sound: NSSound, didFinishPlaying successfully: Bool) {
        guard isPlaying && repeatSound else { return }
        
        Task {
            try? await Task.sleep(for: .seconds(soundOffset))
            
            sound.play()
        }
    }
    
    static let userDefaults = UserDefaults.standard
    static let selectedSoundNameKey = "selectedSoundName"
    static let soundOffsetKey = "soundRepeatOffset"
    static let soundEnabledKey = "soundEnabled"
    static let repeatSoundKey = "soundEnabled"
}
