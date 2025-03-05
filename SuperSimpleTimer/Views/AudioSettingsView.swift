import SwiftUI

struct AudioSettingsView: View {
    private let manager: SoundManager
    private let isTimerCelebrating: Bool
    
    init(manager: SoundManager, isTimerCelebrating: Bool) {
        self.manager = manager
        self.isTimerCelebrating = isTimerCelebrating
    }
    
    var body: some View {
        Form {
            let bindable = Bindable(manager)
            
            
            
            Section("Options") {
                Toggle("Play alarm when timer ends", isOn: bindable.isSoundEnabled)
                Toggle("Repeat alarm until stopped", isOn: bindable.repeatSound)
                
                HStack {
                    TextField("Alarm repeat offset", value: bindable.soundOffset, format: .number)
                        .textFieldStyle(.roundedBorder)
                    
                    Button(manager.isPlaying ? "Stop" : "Preview") {
                        if manager.isPlaying {
                            manager.stop()
                        } else {
                            manager.start()
                        }
                    }
                    .disabled(isTimerCelebrating)
                }
            }
            
            Section("Sound") {
                List(Sound.allCases, selection: bindable.selectedSound) { sound in
                    Button {
                        manager.selectedSound = sound
                        
                        if manager.isPlaying {
                            manager.stop()
                            
                            manager.start()
                        }
                    } label: {
                        VStack {
                            HStack {
                                Image(systemName: "waveform")
                                
                                Text(sound.rawValue)
                                
                                if sound == manager.selectedSound {
                                    Spacer()
                                    
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.blue)
                                }
                            }
                        }
                    }
                }
                .buttonStyle(.plain)
                .listStyle(.inset)
            }
        }
        .formStyle(GroupedFormStyle())
    }
}

#Preview {
    AudioSettingsView(manager: .init(), isTimerCelebrating: false)
}
