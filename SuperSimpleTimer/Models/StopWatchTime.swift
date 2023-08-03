import Foundation

enum StopWatchType {
    case startedAt(Date)
    case interval(startedAt: Date, intervals: [Date])
}
