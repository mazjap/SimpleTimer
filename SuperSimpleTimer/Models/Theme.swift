import SwiftUI

struct Theme: Equatable, Identifiable {
    let id: String
    let primaryBackground: Color
    let secondaryBackground: Color
    let label: Color
    let displayName: LocalizedStringKey
    
    init(id: String, primaryBackground: Color, secondaryBackground: Color, label: Color, displayName: LocalizedStringKey) {
        self.id = id
        self.primaryBackground = primaryBackground
        self.secondaryBackground = secondaryBackground
        self.label = label
        self.displayName = displayName
    }
}

extension Theme {
    static let automatic = Theme(
        id: "automatic",
        primaryBackground: .automaticPrimaryBackground,
        secondaryBackground: .automaticSecondaryBackground,
        label: .automaticPrimaryLabel,
        displayName: "Automatic"
    )
    
    static let light = Theme(
        id: "light",
        primaryBackground: .lightPrimaryBackground,
        secondaryBackground: .lightSecondaryBackground,
        label: .lightPrimaryLabel,
        displayName: "Light"
    )
    
    static let dark = Theme(
        id: "dark",
        primaryBackground: .darkPrimaryBackground,
        secondaryBackground: .darkSecondaryBackground,
        label: .darkPrimaryLabel,
        displayName: "Dark"
    )
    
    static let charcoal = Theme(
        id: "charcoal",
        primaryBackground: .charcoalPrimaryBackground,
        secondaryBackground: .charcoalSecondaryBackground,
        label: .charcoalPrimaryLabel,
        displayName: "Charcoal"
    )
    
    static let navy = Theme(
        id: "navy",
        primaryBackground: .navyPrimaryBackground,
        secondaryBackground: .navySecondaryBackground,
        label: .navyPrimaryLabel,
        displayName: "Navy"
    )
    
    static let allIds: [String] = [automatic.id, light.id, dark.id, charcoal.id, navy.id]
    
    static let allCases = [automatic, light, dark, charcoal, navy]
        .reduce(into: [String : Theme]()) { partial, theme in
            partial[theme.id] = theme
        }
}
