import AppKit

enum Sound: String, Identifiable, CaseIterable {
    case basso = "Basso"
    case blow = "Blow"
    case bottle = "Bottle"
    case frog = "Frog"
    case funk = "Funk"
    case glass = "Glass"
    case hero = "Hero"
    case morse = "Morse"
    case ping = "Ping"
    case pop = "Pop"
    case purr = "Purr"
    case sosumi = "Sosumi"
    case submarine = "Submarine"
    case tink = "Tink"
    
    var id: String { rawValue }
    
    fileprivate var name: NSSound.Name { rawValue }
}

extension NSSound {
    convenience init?(_ sound: Sound) {
        self.init(named: sound.name)
    }
}
