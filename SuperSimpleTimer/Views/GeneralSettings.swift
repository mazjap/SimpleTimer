import SwiftUI

enum Theme: String, Hashable, Identifiable, CaseIterable {
    case automatic = "System"
    case light = "Light"
    case dark = "Dark"
    case charcoal = "Charcoal"
    
    var id: String { rawValue }
}

struct GeneralSettings: View {
    @ScaledMetric private var imageFont = 18
    @AppStorage("theme") private var selectedTheme: Theme = .automatic
    @AppStorage("remainOnTop") private var remainOnTop = false
    @Binding private var selectedTimer: TimerDuration
    @Binding private var menuBarEnabled: Bool
    
    init(selectedTimer: Binding<TimerDuration>, menuBarEnabled: Binding<Bool>) {
        self._selectedTimer = selectedTimer
        self._menuBarEnabled = menuBarEnabled
    }
    
    var body: some View {
        Form {
            Section("Theme") {
                HStack {
                    ForEach(Theme.allCases) { theme in
                        VStack {
                            ZStack {
                                switch theme {
                                case .automatic:
                                    lightPreview
                                    
                                    Text(theme.rawValue)
                                        .foregroundStyle(.black)
                                    
                                    ZStack {
                                        darkPreview
                                        
                                        Text(theme.rawValue)
                                    }
                                    .clipShape(RightAngleTriangle(rightAngleCorner: .bottomTrailing))
                                    
                                case .light:
                                    lightPreview
                                    
                                    Text(theme.rawValue)
                                        .foregroundStyle(.black)
                                case .dark:
                                    darkPreview
                                    
                                    Text(theme.rawValue)
                                case .charcoal:
                                    charcoalPreview
                                    
                                    Text(theme.rawValue)
                                }
                            }
                            .frame(height: 100)
                            
                            ZStack {
                                let isSelected = selectedTheme == theme
                                
                                Image(systemName: "square.fill")
                                    .font(.system(size: imageFont))
                                    .foregroundStyle(isSelected ? Color.accentColor : .white)
                                
                                if isSelected {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: imageFont - 8))
                                        .bold()
                                }
                            }
                        }
                        .onTapGesture {
                            selectedTheme = theme
                        }
                    }
                }
            }
            
            Section("Menu Bar") {
                Toggle("Menu Bar Item Enabled", isOn: $menuBarEnabled)
                
                HStack {
                    Text("Preview:")
                    
                    Spacer()
                    
                    Text(selectedTimer.formattedTime)
                }
                .opacity(menuBarEnabled ? 1 : 0.5)
            }
            
            Section("Other") {
                Toggle("Keep **SuperSimpleTimer** on top of other applications", isOn: $remainOnTop)
            }
        }
        .formStyle(GroupedFormStyle())
    }
    
    private var lightPreview: some View {
        VStack(spacing: 0) {
            Color(nsColor: .lightGray)
            
            Color.white
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    private var darkPreview: some View {
        VStack(spacing: 0) {
            Color(nsColor: .darkGray)
            
            Color.black
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    private var charcoalPreview: some View {
        VStack(spacing: 0) {
            Color(nsColor: .lightGray)
            
            Color(nsColor: .darkGray)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    GeneralSettings(selectedTimer: .constant(.minutes(15)), menuBarEnabled: .constant(true))
}
