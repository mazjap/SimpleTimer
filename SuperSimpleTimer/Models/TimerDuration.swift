import Foundation

struct TimerDuration {
    var totalSeconds: Double
    
    var totalMinutes: Double {
        totalSeconds / 60
    }
    
    var seconds: UInt {
        UInt(totalSeconds) % 60
    }
    
    var minutes: UInt {
        UInt(totalMinutes) % 60
    }
    
    var hours: UInt {
        UInt(totalMinutes) / 60
    }
    
    init(seconds: Double) {
        self.totalSeconds = seconds
    }
}

extension TimerDuration {
    init(hours: Double = 0, minutes: Double = 0, seconds: Double = 0) {
        self.init(seconds: (hours * 60 + minutes) * 60 + seconds)
    }
    
    static func hours(_ hours: Double) -> TimerDuration {
        .init(hours: hours)
    }
    static func minutes(_ minutes: Double) -> TimerDuration {
        .init(minutes: minutes)
    }
    static func seconds(_ seconds: Double) -> TimerDuration {
        .init(seconds: seconds)
    }
}

extension TimerDuration {
    var decremented: TimerDuration {
        TimerDuration(seconds: totalSeconds - 1)
    }
    
    var incremented: TimerDuration {
        TimerDuration(seconds: totalSeconds + 1)
    }
    
    var formattedTime: String {
        if hours == 0 {
            String(format: "%02d:%02d", minutes, seconds)
        } else {
            String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }
}
