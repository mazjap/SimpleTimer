import SwiftUI

@main
struct SuperSimpleTimerApp: App {
    @AppStorage("menuBarEnabled") private var menuBarEnabled = true
    @AppStorage("remainOnTop") private var remainOnTop = false
    @State private var selectedTimer = TimerDuration.minutes(15)
    @State private var isRunning: Bool = false
    
    var body: some Scene {
        WindowGroup {
            TimerView(selectedTimer: $selectedTimer, isRunning: $isRunning)
                .onAppear {
                    updateFloatingStatus()
                }
                .onChange(of: remainOnTop) {
                    updateFloatingStatus()
                }
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        
        MenuBarExtra(isInserted: $menuBarEnabled) {
            Button(isRunning ? "Stop" : "Start") {
                isRunning.toggle()
            }
            
            Button("Quit", role: .destructive) {
                NSApplication.shared.terminate(nil)
            }
        } label: {
            HStack {
                Text(selectedTimer.formattedTime)
                
                Image(systemName: isRunning ? "pause.circle" : "play.circle")
            }
        }
        .menuBarExtraStyle(.menu)
        
        Settings {
            TabView {
                GeneralSettings(selectedTimer: $selectedTimer, menuBarEnabled: $menuBarEnabled)
                    .tabItem {
                        Label("General", systemImage: "gear")
                    }
                
                Text("Audio Settings")
                    .tabItem {
                        Label("Sounds", systemImage: "speaker.wave.2.fill")
                    }
                
                Text("Advanced Settings")
                    .tabItem {
                        Label("Advanced", systemImage: "gearshape.2.fill")
                    }
            }
            .frame(width: 450, height: 300)
            .onAppear {
                updateFloatingStatus()
            }
        }
    }
    
    private func updateFloatingStatus() {
        for window in NSApplication.shared.windows {
            window.level = remainOnTop ? .floating : .normal
            window.collectionBehavior = remainOnTop ? [.canJoinAllSpaces, .fullScreenPrimary] : []
        }
    }
}
