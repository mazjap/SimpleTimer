import Foundation

enum TimerActionDecodingError: LocalizedError {
    case incorrectFormat(String)
    case unknownKeyword(String)
}

enum TimerAction {
    case set(TimerDuration)
    // Supports adding negative numbers
    case add(TimerDuration)
    
    init(rawValue: String) throws {
        let string = rawValue.removing(.whitespacesAndNewlines).lowercased()
        
        let addPrefixes = ["adding", "adds", "add", "plus", "a", "+"]
        let subtractPrefixes = ["subtracting", "subtracts", "subtract", "minus", "-"]
        let setPrefixes = ["set", "s"]
        let prefixes = addPrefixes + setPrefixes
        
        let hourSuffixes = ["hours", "hour", "h"]
        let minuteSuffixes = ["minutes", "minute", "min", "m"]
        let secondSuffixes = ["seconds", "second", "sec", "s"]
        let suffixes = hourSuffixes + minuteSuffixes + secondSuffixes
        
        let withoutPrefix = prefixes.reduce(string) { $0.withoutPrefix($1) }
        let withoutSuffix = suffixes.reduce(string) { $0.withoutSuffix($1) }
        let numberString = prefixes.reduce(withoutSuffix) { $0.withoutPrefix($1) }
        
        guard let number = Double(numberString) else {
            throw TimerActionDecodingError.incorrectFormat("'\(numberString)' expected integer")
        }
        
        let timerDuration: TimerDuration
        
        if hourSuffixes.reduce(false, { $0 || string.hasSuffix($1) }) {
            timerDuration = .hours(number)
        } else if minuteSuffixes.reduce(false, { $0 || string.hasSuffix($1) }) {
            timerDuration = .minutes(number)
        } else if secondSuffixes.reduce(false, { $0 || string.hasSuffix($1) }) {
            timerDuration = .seconds(number)
        } else if withoutPrefix.withoutPrefix(numberString).isEmpty {
            timerDuration = .minutes(number)
        } else {
            throw TimerActionDecodingError.incorrectFormat(withoutPrefix.withoutPrefix(numberString))
        }
        
        if addPrefixes.reduce(false, { $0 || string.hasPrefix($1) }) || subtractPrefixes.reduce(false, { $0 || string.hasPrefix($1) }) {
            self = .add(timerDuration)
        } else if withoutSuffix.withoutSuffix(numberString).isEmpty || setPrefixes.reduce(false, { $0 || string.hasPrefix($1) }) {
            self = .set(timerDuration)
        } else {
            throw TimerActionDecodingError.incorrectFormat(withoutSuffix.withoutSuffix(numberString))
        }
    }
}
