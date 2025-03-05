import SwiftUI
import EventKit

struct TimerAnimationValues {
    var rotation: Angle = .zero
    var opacity: Double = 1
}

struct TimerView: View {
    @AppStorage("expandedWindow") private var expandedStyle: Bool = false
    @FocusState private var textFieldFocused: Bool
    
    @State private var timerQuery = ""
    @State private var errorReason: String?
    
    @ScaledMetric private var smallButtonSize = 12
    @ScaledMetric private var largeButtonSize = 16
    @ScaledMetric private var largeTextField = 24
    @ScaledMetric private var smallTextField = 12
    @ScaledMetric private var smallTimeSize = 36
    @ScaledMetric private var largeTimeSize = 104
    
    private let manager: TimerManager
    private let theme: Theme
    private let jiggleWindow: (String) -> Void
    
    private var textAngle: Angle {
        if let isCelebrating = manager.isCelebrating {
            return .degrees(isCelebrating ? 4 : -4)
        }
        
        return .zero
    }
    
    init(manager: TimerManager, theme: Theme, jiggleWindow: @escaping (String) -> Void) {
        self.manager = manager
        self.theme = theme
        self.jiggleWindow = jiggleWindow
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                textField
                    .padding(.horizontal, 4)
                    .padding(.top, -10)
                    .padding(.bottom, 2)
                    .background(theme.primaryBackground)
                
                ZStack {
                    theme.secondaryBackground
                    
                    timer
                        .padding(.horizontal, 4)
                        .rotationEffect(textAngle)
                }
            }
            .toolbar(content: {
                ToolbarItemGroup(placement: .primaryAction) {
                    actions
                        .foregroundStyle(theme.label)
                }
            })
        }
        .frame(minWidth: 158, minHeight: 60)
        .animation(.easeInOut, value: theme)
        .onChange(of: errorReason) { oldValue, newValue in
            guard let errorReason else { return }
            jiggleWindow(errorReason)
        }
    }
    
    private var actions: some View {
        Group {
            Spacer(minLength: 0)
                .layoutPriority(0)
            
            HStack(spacing: 4) {
                Button {
                    manager.isRunning.toggle()
                } label: {
                    Image(systemName: manager.isRunning ? "pause.fill" : "play.fill")
                }
                
                SettingsLink {
                    Image(systemName: "gear")
                }
                
                Button {
                    withAnimation(.easeOut(duration: 2)) {
                        expandedStyle.toggle()
                    }
                } label: {
                    Image(systemName: expandedStyle ? "arrow.down.forward.and.arrow.up.backward" : "arrow.up.backward.and.arrow.down.forward")
                }
            }
        }
        .buttonStyle(.plain)
        .layoutPriority(1)
    }
    
    private var textField: some View {
        TextField(expandedStyle ? "\"20 min\", \"add 1 hour\", etc." : "", text: $timerQuery)
            .focused($textFieldFocused)
            .font(.system(size: expandedStyle ? largeTextField : smallTextField))
            .textFieldStyle(.plain)
            .foregroundStyle(theme.label)
            .padding(.horizontal, 4)
            .onSubmit {
                textFieldFocused = false
                
                if !timerQuery.isEmpty {
                    parseQuery()
                }
            }
            .onChange(of: timerQuery) { old, new in
                if !timerQuery.isEmpty {
                    errorReason = nil
                }
            }
    }
    
    private var timer: some View {
        Text(manager.timeString ?? manager.selectedTimerDuration.formattedTime)
            .font(.system(size: 100))
            .fontWeight(.semibold)
            .monospaced()
            .lineLimit(1)
            .layoutPriority(1)
            .foregroundStyle(theme.label)
            .minimumScaleFactor(0.01)

    }
    
    private var textFieldSize: Double {
        expandedStyle ? largeTextField : smallButtonSize
    }
    
    private var buttonSize: Double {
        expandedStyle ? largeButtonSize : smallButtonSize
    }
    
    private func parseQuery() {
        let query = timerQuery.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        timerQuery = ""
        
        if ["s", "start", "begin", "go", "continue"].contains(query) && !manager.isRunning {
            manager.startTime = .now
        } else if ["q", "e", "quit", "end", "stop"].contains(query) && manager.isRunning {
            manager.startTime = nil
        } else {
            do {
                manager.performAction(try TimerAction(rawValue: query))
            } catch {
                errorReason = "Could not parse query \(query)"
            }
        }
    }
}

#Preview {
    TimerView(manager: .init(), theme: .automatic) {_ in}
}
