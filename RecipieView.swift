import SwiftUI

struct RecipeView: View {
    var recipeName: String
    var variant: String
    var totalTime: String = "1.0 hrs"
    var imageName: String // The image name for the recipe

    @State private var selectedTab = 0 // To switch between ingredients, instructions, and timer
    @State private var rating = 0 // Start with no rating
    @Binding var favorites: [Recipe] // To manage favorites

    var body: some View {
        VStack {
            // Recipe Image and Information
            HStack(alignment: .top) {
                // Display recipe image using the imageName string with a consistent frame
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100) // Set a fixed size for the image
                    .clipped() // Clip any overflowing content
                    .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 10) {
                    // Recipe Name and Variant
                    Text(recipeName)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(variant.isEmpty ? "Original" : variant)
                        .foregroundStyle(.accent)// Show variant or original
                    
                    // Display the total time which will dynamically update based on the timers
                    HStack {
                        Image(systemName: "stopwatch.fill" )
                            .foregroundStyle(.secondary)
                        Text("\(totalTime)")
                    }
                    
                    // Dynamic Star Ratings
                    HStack(spacing: 4) {
                        ForEach(1..<6) { star in
                            Image(systemName: star <= rating ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .onTapGesture {
                                    rating = star
                                    if rating == 5 {
                                        appendToFavorites() // Append to favorites if rated 5 stars
                                    }
                                }
                        }
                    }
                }
                
                Spacer()
                
                // Edit Button
                Image(systemName: "square.and.pencil")
                    .foregroundStyle(.accent)
                    .imageScale(.large)
                    .padding(.top)
            }
            .padding()
            
            // Segmented Control for Ingredients, Instructions, and Timer
            Picker("", selection: $selectedTab) {
                Text("Ingredients").tag(0)
                Text("Instructions").tag(1)
                Text("Timer").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            // Tab View Content
            if selectedTab == 0 {
                IngredientsTabView()
            } else if selectedTab == 1 {
                InstructionsTabView()
            } else {
                MultipleTimersTabView() // New Timer tab supporting multiple timers
            }
            
            Spacer()
        }
        .background(Color("Primary").ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // Append the recipe to favorites if rated 5 stars
    func appendToFavorites() {
        let newFavorite = Recipe(name: recipeName, imageName: imageName, variants: [variant])
        if !favorites.contains(where: { $0.name == newFavorite.name }) {
            favorites.append(newFavorite)
        }
    }
}

// Ingredients Tab
struct IngredientsTabView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("1 12-ounce package fresh (or frozen, thawed) cranberries, plus 4 ounces (about 1½ cups) for serving")
                Text("2½ cups granulated sugar, divided")
                Text("3 large eggs")
                Text("2 large egg yolks")
                Text("1 teaspoon finely grated lemon zest")
                Text("2 teaspoons finely grated lime zest, divided")
                Text("½ cup fresh lime juice")
                Text("Pinch of kosher salt")
                Text("¾ cup (1½ sticks) unsalted butter, room temperature, cut into pieces")
                Text("Whipped cream (for serving)")
            }
            .padding()
        }
    }
}

// Instructions Tab
struct InstructionsTabView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("1. Preheat oven to 350°F. Grease and flour two 9-inch round baking pans.")
                Text("2. In a medium bowl, whisk together the flour, baking powder, and salt.")
                Text("3. In a large bowl, cream the butter and sugar together until light and fluffy.")
                Text("4. Add the eggs one at a time, beating well after each addition.")
                Text("5. Add the vanilla extract and mix until combined.")
                Text("6. Gradually add the dry ingredients to the wet ingredients, alternating with the milk.")
                Text("7. Pour the batter into the prepared pans and smooth the tops.")
                Text("8. Bake for 25-30 minutes or until a toothpick inserted into the center comes out clean.")
                Text("9. Let the cakes cool in the pans for 10 minutes before transferring to wire racks to cool completely.")
            }
            .padding()
        }
    }
}

// Multiple Timers Tab
struct MultipleTimersTabView: View {
    @State private var timers: [TimerModel] = [
        TimerModel(name: "Prep Timer", totalTime: 0),
        TimerModel(name: "Bake Timer", totalTime: 0),
        TimerModel(name: "Cool Timer", totalTime: 0),
        TimerModel(name: "Decorate Timer", totalTime: 0)
    ]
    
    var totalTime: TimeInterval {
        return timers.reduce(0) { $0 + $1.totalTime }
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    ForEach($timers) { $timer in
                        TimerView(timer: $timer)
                    }
                }
            }
            .padding(.horizontal)
            
            // Display total time from all timers
            Text("Total Time: \(formatTime(totalTime))")
                .font(.system(size: 25, weight: .bold, design: .monospaced))
                .padding(.vertical, 20)
            
            Button(action: {
                // Action when update is pressed
            }) {
                Text("Update")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
        .padding(.top, 20)
    }
    
    // Format the time remaining
    func formatTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

// Single Timer View for each timer in the list
struct TimerView: View {
    @Binding var timer: TimerModel
    @State private var timerObj: Timer? = nil
    @State private var isRunning = false
    
    var body: some View {
        HStack {
            Text(formatTime(timer.totalTime))
                .font(.system(size: 20, weight: .bold, design: .monospaced))
                .frame(width: 100, alignment: .leading)
            
            Text(timer.name)
                .font(.system(size: 18, weight: .medium))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Toggle("", isOn: $isRunning)
                .labelsHidden()
                .onChange(of: isRunning) { running in
                    if running {
                        startTimer()
                    } else {
                        stopTimer()
                    }
                }
            
            Button(action: {
                resetTimer()
            }) {
                Text("Reset")
                    .foregroundColor(.red)
                    .frame(width: 70, height: 40)
                    .cornerRadius(10)
            }
        }
        .padding(.vertical, 5)
    }
    
    // Format the time elapsed
    func formatTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    // Start the timer (count up)
    func startTimer() {
        timerObj = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            timer.totalTime += 1 // Increment the total time every second
        }
    }
    
    // Stop the timer
    func stopTimer() {
        timerObj?.invalidate()
        timerObj = nil
    }
    
    // Reset the timer to 0
    func resetTimer() {
        stopTimer()
        timer.totalTime = 0
        isRunning = false
    }
}

// Model for each individual timer
struct TimerModel: Identifiable {
    let id = UUID()
    var name: String
    var totalTime: TimeInterval
    var timeRemaining: TimeInterval
    
    init(name: String, totalTime: TimeInterval) {
        self.name = name
        self.totalTime = totalTime
        self.timeRemaining = totalTime
    }
}

// Preview for the multiple timers tab
#Preview {
    RecipeView(recipeName: "Cake Name", variant: "Vanilla with Sprinkles", imageName: "vanilla_cake", favorites: .constant([]))
}
