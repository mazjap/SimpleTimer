import SwiftUI
import Combine

@MainActor
@Observable
class TimerManager {
    var selectedTimerDuration: TimerDuration {
        didSet {
            Self.userDefaults.set(selectedTimerDuration.totalSeconds, forKey: Self.selectedTimerDurationKey)
            endCelebrations()
        }
    }
    
    var startTime: Date? {
        didSet {
            endCelebrations()
            
            if startTime != nil {
                cancellable = Timer
                    .publish(every: 0.1, tolerance: 0.1, on: .main, in: .common)
                    .autoconnect()
                    .sink { [unowned self] date in
                        self.updateTime(using: date)
                    }
            }
        }
    }
    
    var timeString: String?
    var soundManager = SoundManager()
    
    private(set) var isCelebrating: Bool?
    
    @ObservationIgnored
    private var cancellable: AnyCancellable?
    @ObservationIgnored
    private var animationTask: Task<Void, Never>?
    
    var isRunning: Bool {
        get {
            startTime != nil
        } set {
            if newValue {
                if startTime == nil {
                    startTime = .now
                }
            } else {
                startTime = nil
            }
        }
    }
    
    init(startTime: Date? = nil, timeString: String? = nil) {
        let selectedTimerDuration: TimerDuration
        
        if let seconds = Self.userDefaults.value(forKey: Self.selectedTimerDurationKey) as? Double, seconds >= 0 {
            selectedTimerDuration = .init(seconds: seconds)
        } else {
            selectedTimerDuration = .minutes(15)
        }
        
        self.selectedTimerDuration = selectedTimerDuration
        self.startTime = startTime
        self.timeString = timeString
    }
    
    func updateTime(using date: Date) {
        guard let startTime else { return }
        
        let elapsedTime = date.timeIntervalSince(startTime)
        
        if elapsedTime >= selectedTimerDuration.totalSeconds {
            timeString = TimerDuration(seconds: 0).formattedTime
            cancellable?.cancel()
            cancellable = nil
            
            soundManager.start()
            
            if isCelebrating == nil {
                startJiggleAnimation()
            }
        } else {
            timeString = TimerDuration(seconds: selectedTimerDuration.totalSeconds - elapsedTime + 1).formattedTime
        }
    }
    
    func performAction(_ action: TimerAction) {
        switch action {
        case let .set(duration):
            selectedTimerDuration = duration
            startTime = .now
        case let .add(duration):
            selectedTimerDuration = TimerDuration(seconds: max(0, selectedTimerDuration.totalSeconds + duration.totalSeconds))
        }
    }
    
    private func startJiggleAnimation() {
        endCelebrations(stopSounds: false)
        
        animationTask = Task {
            let duration = 0.1
            
            while !Task.isCancelled {
                do {
                    withAnimation(.easeInOut(duration: duration)) {
                        isCelebrating = true
                    }
                    
                    try await Task.sleep(for: .seconds(duration))
                    
                    try Task.checkCancellation()
                    
                    withAnimation(.easeInOut(duration: duration)) {
                        isCelebrating = false
                    }
                    
                    try await Task.sleep(for: .seconds(duration))
                } catch {
                    break
                }
            }
        }
    }
    
    func endCelebrations(stopSounds: Bool = true) {
        if stopSounds {
            soundManager.stop()
        }
        
        animationTask?.cancel()
        animationTask = nil
        
        withAnimation(.easeOut(duration: 0.2)) {
            isCelebrating = nil
        }
    }
    
    static let userDefaults = UserDefaults.standard
    static let selectedTimerDurationKey = "selected_timer_duration"
}
