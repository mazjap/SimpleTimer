import SwiftUI

extension NSColor {
    private enum Appearance {
        case light
        case dark
    }
    
    private convenience init(name: Name? = nil, dynamicProvider: @escaping (Appearance) -> NSColor) {
        self.init(name: nil) { appearance in
            switch appearance.name {
            case .aqua, .vibrantLight, .accessibilityHighContrastAqua, .accessibilityHighContrastVibrantLight:
                return dynamicProvider(.light)
            case .darkAqua, .vibrantDark, .accessibilityHighContrastDarkAqua, .accessibilityHighContrastVibrantDark:
                fallthrough
            default:
                return dynamicProvider(.dark)
            }
        }
    }
    
    static let lightPrimaryBackground = NSColor.lightGray
    static let lightSecondaryBackground = NSColor.white
    static let lightPrimaryLabel = NSColor.black
    static let darkPrimaryBackground = NSColor.black
    static let darkSecondaryBackground = NSColor.darkGray
    static let darkPrimaryLabel = NSColor.white
    
    static let automaticPrimaryBackground = NSColor {
        switch $0 {
        case .light:
            return lightPrimaryBackground
        case .dark:
            return darkPrimaryBackground
        }
    }
    
    static let automaticSecondaryBackground = NSColor {
        switch $0 {
        case .light:
            return lightSecondaryBackground
        case .dark:
            return darkSecondaryBackground
        }
    }
    
    static let automaticPrimaryLabel = NSColor {
        switch $0 {
        case .light:
            return lightPrimaryLabel
        case .dark:
            return darkPrimaryLabel
        }
    }
}

extension Color {
    static let lightPrimaryBackground = Color(nsColor: .lightPrimaryBackground)
    static let lightSecondaryBackground = Color(nsColor: .lightSecondaryBackground)
    static let lightPrimaryLabel = Color(nsColor: .lightPrimaryLabel)
    static let darkPrimaryBackground = Color(nsColor: .darkPrimaryBackground)
    static let darkSecondaryBackground = Color(nsColor: .darkSecondaryBackground)
    static let darkPrimaryLabel = Color(nsColor: .darkPrimaryLabel)
    static let automaticPrimaryBackground = Color(nsColor: .automaticPrimaryBackground)
    static let automaticSecondaryBackground = Color(nsColor: .automaticSecondaryBackground)
    static let automaticPrimaryLabel = Color(nsColor: .automaticPrimaryLabel)
}
