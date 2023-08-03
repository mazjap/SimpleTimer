import SwiftUI

struct RightAngleTriangle: Shape {
    enum Corner {
        case topLeading
        case topTrailing
        case bottomTrailing
        case bottomLeading
        
        var verticalFactor: Double {
            switch self {
            case .bottomLeading, .bottomTrailing: 1
            default: 0
            }
        }
        
        var horizontalFactor: Double {
            switch self {
            case .topTrailing, .bottomTrailing: 1
            default: 0
            }
        }
        
        var advancedClockwise: Corner {
            switch self {
            case .topLeading: .topTrailing
            case .topTrailing: .bottomTrailing
            case .bottomTrailing: .bottomLeading
            case .bottomLeading: .topLeading
            }
        }
        
        var advancedCounterclockwise: Corner {
            switch self {
            case .topLeading: .bottomLeading
            case .bottomLeading: .bottomTrailing
            case .bottomTrailing: .topTrailing
            case .topTrailing: .topLeading
            }
        }
    }
    
    var rightAngleCorner: Corner
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        func point(for corner: Corner) -> CGPoint {
            CGPoint(
                x: corner.horizontalFactor == 1 ? rect.maxX : rect.minX,
                y: corner.verticalFactor == 1 ? rect.maxY : rect.minY
            )
        }
        
        path.move(to: point(for: rightAngleCorner))
        
        let firstCorner = rightAngleCorner.advancedClockwise
        
        path.addLine(to: point(for: firstCorner))
        
        let secondCorner = firstCorner.advancedClockwise.advancedClockwise
        
        path.addLine(to: point(for: secondCorner))
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    ZStack {
        RightAngleTriangle(rightAngleCorner: .bottomLeading)
            .fill(Color.blue)
            .stroke(Color.red, lineWidth: 1)
        
        RightAngleTriangle(rightAngleCorner: .topTrailing)
            .fill(Color.green)
        
        RightAngleTriangle(rightAngleCorner: .bottomTrailing)
    }
    .padding(30)
}
