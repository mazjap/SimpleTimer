import Foundation

struct TimerDuration {
    var totalSeconds: UInt
    
    var totalMinutes: UInt {
        totalSeconds / 60
    }
    
    var seconds: UInt {
        totalSeconds % 60
    }
    
    var minutes: UInt {
        totalMinutes % 60
    }
    
    var hours: UInt {
        totalMinutes / 60
    }
    
    init(seconds: UInt) {
        self.totalSeconds = seconds
    }
    
    init(seconds: Int) {
        self.init(seconds: UInt(seconds))
    }
}

extension TimerDuration {
    init(hours: UInt = 0, minutes: UInt = 0, seconds: UInt = 0) {
        self.init(seconds: (hours * 60 + minutes) * 60 + seconds)
    }
    
    init(hours: Int = 0, minutes: Int = 0, seconds: Int = 0) {
        self.init(hours: UInt(hours), minutes: UInt(minutes), seconds: UInt(seconds))
    }
    
    static func hours(_ hours: UInt) -> TimerDuration {
        .init(hours: hours)
    }
    static func minutes(_ minutes: UInt) -> TimerDuration {
        .init(minutes: minutes)
    }
    static func seconds(_ seconds: UInt) -> TimerDuration {
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
