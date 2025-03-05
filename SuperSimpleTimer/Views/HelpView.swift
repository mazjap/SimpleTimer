import SwiftUI

struct HelpView: View {
    private let includeTitle: Bool
    
    init(includeTitle: Bool) {
        self.includeTitle = includeTitle
    }
    
    var body: some View {
        VStack(spacing: 40) {
            if includeTitle {
                HStack {
                    Spacer()
                    
                    Text("Help")
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                }
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Set a countdown timer")
                        .bold()
                    
                    Text("\"20 minutes\"")
                    
                    Text("\"20 min\"")
                    
                    Text("\"20m\"")
                    
                    Text("\"20\" = \"20 minutes\"")
                }
                
                VStack(alignment: .leading) {
                    Text("Add time to a countdown")
                        .bold()
                    
                    Text("\"add 1 hour\"")
                    
                    Text("\"+ 1 hour\"")
                    
                    Text("\"+1h\"")
                    
                    Text("")
                }
            }
            
            HStack {
                Spacer()
                
                Text("Shortcuts")
                    .font(.title2)
                    .bold()
                
                Spacer()
            }
            
            VStack {
                HStack {
                    Grid {
                        GridRow {
                            Text("Settings")
                            
                            Text("⌘,")
                        }
                        
                        GridRow {
                            Text("Hide")
                            
                            Text("⌘h")
                        }
                    }
                    
                    Grid {
                        GridRow {
                            Text("Help")
                            
                            Text("⌘/")
                        }
                        
                        GridRow {
                            Text("Quit")
                            
                            Text("⌘q")
                        }
                    }
                }
                
                // TODO: - Add shortcuts
                Text("More coming soon...")
            }
            
            if !includeTitle {
                Spacer()
            }
        }
        .padding(.bottom, 20)
    }
}

#Preview {
    HelpView(includeTitle: true)
}
