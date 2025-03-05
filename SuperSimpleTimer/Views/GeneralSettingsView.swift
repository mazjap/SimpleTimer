import SwiftUI

struct GeneralSettingsView: View {
    @ScaledMetric private var imageFont = 18
    @AppStorage("remainOnTop") private var remainOnTop = false
    @State private var hoveredThemeId: String?
    @Binding private var menuBarEnabled: Bool
    @Binding private var selectedThemeId: String
    
    private let timerDurationString: String
    
    init(timerDurationString: String, menuBarEnabled: Binding<Bool>, selectedThemeId: Binding<String>) {
        self.timerDurationString = timerDurationString
        self._menuBarEnabled = menuBarEnabled
        self._selectedThemeId = selectedThemeId
    }
    
    var body: some View {
        Form {
            Section("Theme") {
                HStack {
                    ForEach(Theme.allIds, id: \.self) {
                        themeInformation($0)
                    }
                    // TODO: - Custom theme
                }
            }
            
            Section("Menu Bar") {
                Toggle("Menu Bar Item Enabled", isOn: $menuBarEnabled)
                
                HStack {
                    Text("Preview:")
                    
                    Spacer()
                    
                    Text(timerDurationString)
                }
                .opacity(menuBarEnabled ? 1 : 0.5)
            }
            
            Section("Other") {
                Toggle("Keep **SuperSimpleTimer** on top of other applications", isOn: $remainOnTop)
            }
        }
        .formStyle(GroupedFormStyle())
    }
    
    private func themeInformation(_ themeId: String) -> some View {
        VStack {
            ZStack {
                if themeId == Theme.automatic.id {
                    preview(for: .light, titleOverride: Theme.automatic.displayName)
                    
                    preview(for: .dark, titleOverride: Theme.automatic.displayName)
                        .clipShape(RightAngleTriangle(rightAngleCorner: .bottomTrailing))
                } else {
                    preview(for: Theme.allCases[themeId])
                }
            }
            .frame(height: 80)
            
            ZStack {
                let isSelected = selectedThemeId == themeId
                let foregroundColor: Color = {
                    if isSelected {
                        return .accentColor
                    } else if hoveredThemeId == themeId {
                        return .accentColor.opacity(0.4)
                    }
                    
                    return .white
                }()
                
                Image(systemName: "square.fill")
                    .font(.system(size: imageFont))
                    .foregroundStyle(foregroundColor)
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: imageFont - 8))
                        .bold()
                } else if hoveredThemeId == themeId {
                    Image(systemName: "minus")
                        .font(.system(size: imageFont - 8))
                        .bold()
                }
            }
        }
        .onTapGesture {
            withAnimation {
                selectedThemeId = themeId
            }
        }
        .onHover { isHovering in
            if isHovering {
                hoveredThemeId = themeId
            } else if hoveredThemeId == themeId {
                hoveredThemeId = nil
            }
        }
    }
    
    @ViewBuilder
    private func preview(for theme: Theme?, titleOverride: LocalizedStringKey? = nil) -> some View {
        let shape = RoundedRectangle(cornerRadius: 10)
        
        Group {
            if let theme {
                ZStack {
                    VStack(spacing: 0) {
                        theme.primaryBackground
                        
                        theme.secondaryBackground
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Text(titleOverride ?? theme.displayName)
                        .foregroundStyle(theme.label)
                }
                .clipShape(shape)
            } else {
                ZStack {
                    shape.fill(Color.gray.opacity(0.4))
                    
                    Text("Error")
                        .foregroundStyle(.red)
                }
            }
        }
        .bold()
    }
}

#Preview {
    GeneralSettingsView(timerDurationString: "20:00", menuBarEnabled: .constant(true), selectedThemeId: .constant(Theme.automatic.id))
}
