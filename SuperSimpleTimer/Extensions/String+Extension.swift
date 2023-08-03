import Foundation

extension String {
    func removing(_ characters: CharacterSet) -> String {
        let cleanedChars = unicodeScalars.filter { !characters.contains($0) }
        return String(UnicodeScalarView(cleanedChars))
    }
}

extension StringProtocol {
    func withoutPrefix<Str: StringProtocol>(_ prefix: Str) -> SubSequence {
        guard self != prefix else { return "" }
        
        if hasPrefix(prefix) {
            return self[index(startIndex, offsetBy: prefix.count)...]
        }
        
        return self[...]
    }
    
    func withoutPrefix<Str: StringProtocol>(_ prefix: Str) -> String {
        let noPrefix: SubSequence = withoutPrefix(prefix)
        return String(noPrefix)
    }
    
    func withPrefix<Str: StringProtocol>(_ prefix: Str) -> String {
        if hasPrefix(prefix) {
            return "\(self)"
        }
        
        return "\(prefix)\(self)"
    }
    
    func withoutSuffix<Str: StringProtocol>(_ suffix: Str) -> SubSequence {
        guard self != suffix else { return "" }
        
        if hasSuffix(suffix) {
            return self[...index(endIndex, offsetBy: -suffix.count - 1)]
        }
        
        return self[...]
    }
    
    func withoutSuffix<Str: StringProtocol>(_ suffix: Str) -> String {
        let noSuffix: SubSequence = withoutSuffix(suffix)
        
        return String(noSuffix)
    }
    
    func withSuffix<Str: StringProtocol>(_ suffix: Str) -> String {
        if hasSuffix(suffix) {
            return "\(self)"
        }
        
        return "\(self)\(suffix)"
    }
}
