import SwiftUI

struct TimerView: View {
    @ScaledMetric private var smallButtonSize = 14
    @ScaledMetric private var largeButtonSize = 20
    @ScaledMetric private var largeTextField = 24
    @ScaledMetric private var smallTimeSize = 56
    @ScaledMetric private var largeTimeSize = 104
    @AppStorage("expandedWindow") private var expandedStyle: Bool = false
    @FocusState private var textFieldFocused: Bool
    @State private var timerQuery = ""
    @State private var hasError = false
    @Binding private var selectedTimer: TimerDuration
    @Binding private var isRunning: Bool
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(selectedTimer: Binding<TimerDuration>, isRunning: Binding<Bool>) {
        self._selectedTimer = selectedTimer
        self._isRunning = isRunning
    }
    
    var body: some View {
        VStack(spacing: 0) {
            textField
                .padding(.bottom, 4)
                .background()
            
            Color(nsColor: hasError ? .red : .clear)
                .frame(height: 20)
            
            Text(selectedTimer.formattedTime)
                .font(.system(size: expandedStyle ? largeTimeSize : smallTimeSize))
                .fontWeight(.black)
                .lineLimit(1)
                .layoutPriority(1)
                .padding(.bottom, 8)
                .padding(.horizontal, 20)
        }
        .toolbar(content: {
            ToolbarItemGroup(placement: .primaryAction) {
                actions
            }
        })
        .font(.system(size: buttonSize))
        .monospaced()
        .fixedSize()
        .onReceive(timer) { _ in
            guard isRunning else {
                return
            }
            
            if selectedTimer.totalSeconds == 0 {
                // TODO: - Ring timer, jiggle ui, confetti, etc.
                isRunning = false
            } else {
                selectedTimer = selectedTimer.decremented
            }
        }
    }
    
    private var actions: some View {
        Group {
            Spacer(minLength: 0)
            
            Button {
                isRunning.toggle()
            } label: {
                Image(systemName: isRunning ? "stop.circle.fill" : "play.fill")
            }
            
            Button {
                
            } label: {
                Image(systemName: "stopwatch")
            }
            .disabled(true)
            
            SettingsLink {
                Image(systemName: "gear")
            }
            
            Button {
                expandedStyle.toggle()
            } label: {
                Image(systemName: expandedStyle ? "arrow.down.forward.and.arrow.up.backward" : "arrow.up.backward.and.arrow.down.forward")
            }
        }
        .buttonStyle(.plain)
    }
    
    private var textField: some View {
        TextField(expandedStyle ? "\"20 min\", \"add 1 hour\", etc." : "", text: $timerQuery)
            .focused($textFieldFocused)
            .font(.system(size: buttonSize))
            .textFieldStyle(.plain)
            .padding(.horizontal, 4)
            .onSubmit {
                textFieldFocused = false
                
                if !timerQuery.isEmpty {
                    parseQuery()
                }
            }
            .onChange(of: timerQuery) { old, new in
                if !timerQuery.isEmpty {
                    hasError = false
                }
            }
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
        
        if ["s", "start", "begin"].contains(query) && !isRunning {
            isRunning = true
        } else if ["q", "e", "s", "quit", "end", "stop"].contains(query) && isRunning {
            isRunning = false
        } else {
            do {
                switch try TimerAction(rawValue: query) {
                case let .set(duration):
                    self.selectedTimer = duration
                case let .add(duration):
                    self.selectedTimer = TimerDuration(seconds: selectedTimer.totalSeconds + duration.totalSeconds)
                }
            } catch {
                hasError = true
            }
        }
    }
}

#Preview {
    TimerView(selectedTimer: .constant(.minutes(15)), isRunning: .constant(false))
}
