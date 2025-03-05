import SwiftUI

@main
struct SuperSimpleTimerApp: App {
    @Environment(\.openWindow) private var openWindow
    
    @AppStorage("menuBarEnabled") private var menuBarEnabled = true
    @AppStorage("remainOnTop") private var remainOnTop = false
    @AppStorage("theme") private var selectedThemeId: String = Theme.automatic.id
    
    @State private var timerManager = TimerManager()
    
    private var theme: Theme {
        Theme.allCases[selectedThemeId] ?? .automatic
    }
    
    var body: some Scene {
        WindowGroup {
            TimerView(manager: timerManager, theme: theme, jiggleWindow: { jiggleReason in
                print(jiggleReason)
                jiggleWindow()
            })
            .onAppear {
                updateFloatingStatus()
            }
            .onChange(of: remainOnTop) {
                updateFloatingStatus()
            }
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentMinSize)
        .commands {
            CommandGroup(replacing: .help) {
                Button(action: {
                  openWindow(id: "help")
                }, label: {
                    Text("Help")
                })
                .keyboardShortcut("/")
            }
        }
        // TODO: - Use window level once macOS 14 support is dropped
//        .windowLevel(remainOnTop ? .floating : .normal)
        
        MenuBarExtra(isInserted: $menuBarEnabled) {
            VStack {
                Button(timerManager.isRunning ? "Stop" : "Start") {
                    timerManager.isRunning.toggle()
                }
                
                Button("Quit", role: .destructive) {
                    NSApplication.shared.terminate(nil)
                }
            }
        } label: {
            Text(timerManager.timeString ?? timerManager.selectedTimerDuration.formattedTime)
        }
        .menuBarExtraStyle(.menu)
        
        Settings {
            TabView {
                GeneralSettingsView(
                    timerDurationString: timerManager.timeString ?? timerManager.selectedTimerDuration.formattedTime,
                    menuBarEnabled: $menuBarEnabled,
                    selectedThemeId: $selectedThemeId
                )
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                
                AudioSettingsView(manager: timerManager.soundManager, isTimerCelebrating: timerManager.isCelebrating == nil ? false : true)
                    .tabItem {
                        Label("Audio", systemImage: "speaker.wave.2")
                    }
                
                HelpView(includeTitle: false)
                    .tabItem {
                        Label("Help", systemImage: "questionmark.circle")
                    }
            }
            .frame(width: 450, height: 500)
            .onAppear {
                updateFloatingStatus()
            }
        }
        
        Window("Help", id: "help") {
            HelpView(includeTitle: true)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentMinSize)
    }
    
    private func updateFloatingStatus() {
        for window in NSApplication.shared.windows {
            window.level = remainOnTop ? .floating : .normal
            window.collectionBehavior = remainOnTop ? [.canJoinAllSpaces, .fullScreenPrimary] : []
        }
    }
    
    private func jiggleWindow(count: Int = 5) {
        guard let window = NSApplication.shared.windows.first else { return }
        
        let originalFrame = window.frame
        let jiggleDistance: CGFloat = 2
        
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.01
            window.animator().setFrame(
                NSRect(
                    x: originalFrame.origin.x - jiggleDistance,
                    y: originalFrame.origin.y,
                    width: originalFrame.width,
                    height: originalFrame.height
                ),
                display: true
            )
        }, completionHandler: {
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.01
                window.animator().setFrame(
                    NSRect(
                        x: originalFrame.origin.x + jiggleDistance,
                        y: originalFrame.origin.y,
                        width: originalFrame.width,
                        height: originalFrame.height
                    ),
                    display: true
                )
            }, completionHandler: {
                // Reset to original position
                NSAnimationContext.runAnimationGroup({ context in
                    context.duration = 0.01
                    window.animator().setFrame(originalFrame, display: true)
                }, completionHandler: {
                    if count > 0 {
                        jiggleWindow(count: count - 1)
                    }
                })
            })
        })
    }
}
