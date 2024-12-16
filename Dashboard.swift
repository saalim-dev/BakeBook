import SwiftUI
import PhotosUI

struct Dashboard: View {
    @State private var selectedTab = 1
    @State private var recipes: [Recipe] = [
        // Initial Base Recipes with image names
        Recipe(name: "Vanilla Cake", imageName: "vanilla_cake", variants: ["Vanilla with Sprinkles", "Vanilla with Chocolate"]),
        Recipe(name: "Chocolate Cake", imageName: "chocolate_cake", variants: ["Chocolate with Mint", "Chocolate with Raspberry"]),
        Recipe(name: "Red Velvet Cake", imageName: "red_velvet_cake", variants: ["Red Velvet with Cream Cheese", "Red Velvet with White Chocolate"]),
        Recipe(name: "Carrot Cake", imageName: "carrot_cake", variants: ["Carrot with Walnuts", "Carrot with Pineapple"]),
        Recipe(name: "Cheesecake", imageName: "cheesecake", variants: ["New York Style", "Strawberry Topping"]),
        
        // New additional cakes
        Recipe(name: "Lemon Cake", imageName: "lemon_cake", variants: ["Lemon with Blueberries", "Lemon with Poppy Seeds"]),
        Recipe(name: "Coffee Cake", imageName: "coffee_cake", variants: ["Classic Cinnamon", "Coffee with Streusel"]),
        Recipe(name: "Black Forest Cake", imageName: "black_forest_cake", variants: ["With Cherry Filling", "With Chocolate Shavings"]),
        Recipe(name: "Pineapple Upside-Down Cake", imageName: "pineapple_cake", variants: ["Classic", "With Maraschino Cherries"]),
        Recipe(name: "Sponge Cake", imageName: "sponge_cake", variants: ["Victoria Sponge", "Sponge with Jam"]),
        Recipe(name: "Coconut Cake", imageName: "coconut_cake", variants: ["Coconut with Lime", "Coconut with Pineapple"]),
        Recipe(name: "Marble Cake", imageName: "marble_cake", variants: ["Chocolate-Vanilla Marble", "Coffee-Marble"]),
        Recipe(name: "Fruitcake", imageName: "fruitcake", variants: ["Traditional", "With Dried Fruits"]),
        Recipe(name: "Tiramisu Cake", imageName: "tiramisu_cake", variants: ["Classic Tiramisu", "Chocolate Tiramisu"]),
        Recipe(name: "Funfetti Cake", imageName: "funfetti_cake", variants: ["Classic Funfetti", "Funfetti with Chocolate Chips"])
    ]

    @State private var searchQuery = "" // Search query state
    @State private var showActionSheet = false
    @State private var selectedRecipe: Recipe?
    @State private var selectedVariant: String? // Track selected variant
    @State private var isAddingRecipe = false
    @State private var isCreatingVariant = false // New state for variant creation
    @State private var newVariantName = "" // Store new variant name
    @State private var favorites: [Recipe] = [] // Array to track favorites
    @State private var showRecipeView = false // Controls navigation to RecipeView

    var body: some View {
        NavigationView {
            VStack {
                // Top bar with logo and create recipe button
                HStack {
                    Image("Logo")  // replace with your actual logo image
                        .resizable()
                        .frame(width: 75, height: 75)
                        .padding(.leading)
                    
                    Spacer()
                    
                    Button(action: {
                        isAddingRecipe.toggle() // trigger add recipe
                    }) {
                        Image(systemName: "square.and.pencil")
                            .foregroundStyle(.accent)
                            .imageScale(.large)
                            .fontWeight(.bold)
                            .padding(.trailing)
                    }
                }
                .padding(.top)

                // Segmented Picker for tabs
                Picker(selection: $selectedTab, label: Text("")) {
                    Text("Base Recipes").tag(1)
                    Text("Favorites").tag(2)
                    Text("Custom").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                // Search Bar
                if selectedTab == 1 { // Only show search bar on the Base Recipes tab
                    HStack {
                        HStack {
                            Image(systemName: "magnifyingglass") // Magnifying glass inside the search bar
                                .foregroundColor(.gray)
                            TextField("Search recipes", text: $searchQuery)
                                .foregroundColor(.white)
                        }
                        .padding(10)
                        .background(Color("Primary")) // Custom "Primary" background
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1) // Light gray border
                        )
                    }
                    .padding(.horizontal)
                    .padding(.top, 10) // Add padding to the top
                }

                // Content based on selected tab
                ScrollView {
                    VStack(alignment: .leading) {
                        if selectedTab == 1 {
                            BaseRecipesView(recipes: filteredRecipes, showActionSheet: $showActionSheet, selectedRecipe: $selectedRecipe)
                        } else if selectedTab == 2 {
                            FavoritesView(favorites: $favorites)
                        } else {
                            CustomRecipesView()
                        }
                    }
                    .padding(.top)
                }

                // NavigationLink to RecipeView with selected variant and imageName
                NavigationLink(
                    destination: RecipeView(
                        recipeName: selectedRecipe?.name ?? "",
                        variant: selectedVariant ?? "Original",
                        imageName: selectedRecipe?.imageName ?? "",  // Add imageName here
                        favorites: $favorites
                    ),
                    isActive: $showRecipeView // Controls navigation
                ) {
                    EmptyView() // Trigger navigation programmatically
                }
            }
            .background(Color("Primary").ignoresSafeArea()) // Background color set to Primary
            .sheet(isPresented: $isAddingRecipe) {
                CreateNewRecipeView(recipes: $recipes) // Add new recipe screen styled per your request
                
                
            }
            .actionSheet(isPresented: $showActionSheet, content: {
                actionSheet()
            })
            .sheet(isPresented: $isCreatingVariant) {
                CreateVariantView(newVariantName: $newVariantName, onSave: saveNewVariant)
            }
        }
    }

    // Filtered recipes based on search query
    var filteredRecipes: [Recipe] {
        if searchQuery.isEmpty {
            return recipes
        } else {
            return recipes.filter { $0.name.localizedCaseInsensitiveContains(searchQuery) }
        }
    }

    // Action Sheet for recipe variants
    func actionSheet() -> ActionSheet {
        guard let recipe = selectedRecipe else {
            return ActionSheet(title: Text("Error"), message: Text("No recipe selected"), buttons: [.cancel()])
        }

        var buttons: [ActionSheet.Button] = recipe.variants.map { variant in
            .default(Text(variant)) {
                selectedVariant = variant
                showRecipeView = true // Trigger navigation after selecting a variant
            }
        }
        
        buttons.append(.default(Text("Create New Variant")) {
            isCreatingVariant.toggle() // Trigger new variant creation
        })
        buttons.append(.cancel())
        
        return ActionSheet(title: Text(recipe.name), message: Text("Select a variant"), buttons: buttons)
    }

    // Save new variant to the selected recipe
    private func saveNewVariant() {
        if let index = recipes.firstIndex(where: { $0.id == selectedRecipe?.id }) {
            recipes[index].variants.append(newVariantName)
            isCreatingVariant = false // Dismiss the sheet
        }
    }
}

// Base Recipes View
struct BaseRecipesView: View {
    var recipes: [Recipe] // No binding needed for filteredRecipes
    @Binding var showActionSheet: Bool
    @Binding var selectedRecipe: Recipe?

    var body: some View {
        VStack(alignment: .leading) {
            Text("Base Recipes")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.leading)

            // Recipe grid with uniform frame size for cake names and images
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(recipes) { recipe in
                    VStack {
                        // Display the recipe image with a fixed uniform size
                        Image(recipe.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100) // Set a fixed size for the image
                            .clipped() // Clip any overflowing content
                            .cornerRadius(10)
                            .onTapGesture {
                                selectedRecipe = recipe
                                showActionSheet = true
                            }
                        
                        // Uniform frame for cake names to make grid flush
                        Text(recipe.name)
                            .font(.body)
                            .lineLimit(2) // Allows the name to wrap onto 2 lines
                            .multilineTextAlignment(.center)
                            .frame(width: 100, height: 40) // Set a fixed width and height for uniform layout
                        
                        // Stars with smaller size
                        HStack(spacing: 4) {
                            ForEach(0..<4) { _ in
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                    .imageScale(.small) // Make stars smaller
                            }
                            Image(systemName: "star")
                                .foregroundColor(.yellow)
                                .imageScale(.small) // Make stars smaller
                        }
                        .padding(.bottom, 5)
                        HStack(spacing: 5) {
                            Image(systemName: "clock")
                            Text("1.0 hrs")
                                .font(.caption)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

// Create New Recipe View - Updated to match your design
struct CreateNewRecipeView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var recipes: [Recipe] // Binding to the base recipes
    @State private var recipeName = ""
    @State private var cookingTime = "0:00 Hrs"
    @State private var rating = 0
    @State private var selectedTab = 0 // For Ingredients, Instructions, Timer
    @State private var image: UIImage? = nil
    @State private var imagePickerPresented = false
    @State private var ingredients = ""
    @State private var instructions = ""
    @State private var errorMessage = "" // For name validation
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    Spacer()
                    Button("Save") {
                        if validateRecipeName() {
                            saveRecipe()
                            dismiss()
                        }
                    }
                    .disabled(recipeName.isEmpty || image == nil) // Disable if name or image is missing
                }
                .padding()
                
                HStack {
                    // Image picker
                    Button(action: {
                        imagePickerPresented.toggle()
                    }) {
                        if let image = image {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 120, height: 120)
                                .cornerRadius(10)
                        } else {
                            ZStack {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.4))
                                    .frame(width: 120, height: 120)
                                    .cornerRadius(10)
                                Image(systemName: "camera")
                                    .foregroundColor(.white)
                                    .font(.system(size: 40))
                            }
                        }
                    }
                    .sheet(isPresented: $imagePickerPresented) {
                        ImagePicker(image: $image)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        // Recipe name input with validation
                        TextField("Enter Cake Name", text: $recipeName)
                            .font(.title3)
                            .padding(10)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .onChange(of: recipeName) { _ in
                                validateRecipeName()
                            }
                        
                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                        
                        // Cooking time and rating
                        HStack {
                            Image(systemName: "clock")
                            Text(cookingTime)
                            
                            Spacer()
                            
                            // Rating stars
                            HStack(spacing: 4) {
                                ForEach(1..<6) { star in
                                    Image(systemName: star <= rating ? "star.fill" : "star")
                                        .foregroundColor(.yellow)
                                        .onTapGesture {
                                            rating = star
                                        }
                                }
                            }
                        }
                    }
                }
                .padding()
                
                // Segmented control
                Picker("", selection: $selectedTab) {
                    Text("Ingredients").tag(0)
                    Text("Instructions").tag(1)
                    Text("Timer").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Text input area based on selected tab
                if selectedTab == 0 {
                    TextEditor(text: $ingredients)
                        .padding()
                        .frame(height: 200)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(.horizontal)
                } else if selectedTab == 1 {
                    TextEditor(text: $instructions)
                        .padding()
                        .frame(height: 200)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(.horizontal)
                } else {
                    // Timer section (you can customize this part to include a time picker or similar UI)
                    Text("Timer will go here")
                        .frame(height: 200)
                        .padding()
                }
                
                Spacer()
            }
            .background(Color.black.ignoresSafeArea()) // Apply background color
        }
    }
    
    // Recipe name validation (trimming whitespaces, limit to 16 characters)
    private func validateRecipeName() -> Bool {
        let trimmedName = recipeName.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedName.isEmpty {
            errorMessage = "Recipe name cannot be empty."
            return false
        } else if trimmedName.count > 16 {
            errorMessage = "Recipe name can't exceed 16 characters."
            return false
        } else {
            errorMessage = ""
            return true
        }
    }
    
    // Save the new recipe to base recipes
    private func saveRecipe() {
        let newRecipe = Recipe(
            name: recipeName.trimmingCharacters(in: .whitespacesAndNewlines),
            imageName: "custom_image", // You may replace with proper image handling
            variants: [] // Add variants as needed
        )
        recipes.append(newRecipe)
    }
}

// Helper struct for Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

// View to create new variant
struct CreateVariantView: View {
    @Binding var newVariantName: String
    var onSave: () -> Void
    @Environment(\.dismiss) var dismiss
    @State private var errorMessage = ""
    
    var body: some View {
        VStack {
            Text("Create New Variant")
                .font(.headline)
                .padding(.top)
            
            TextField("Variant Name", text: $newVariantName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: newVariantName) { _ in
                    validateVariantName()
                }
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.bottom, 5)
            }
            
            Button("Save Variant") {
                if validateVariantName() {
                    onSave()
                    dismiss()
                }
            }
            .disabled(newVariantName.isEmpty)
            .padding()
        }
        .padding()
    }
    
    private func validateVariantName() -> Bool {
        let trimmedName = newVariantName.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedName.isEmpty {
            errorMessage = "Variant name cannot be empty."
            return false
        }
        errorMessage = ""
        return true
    }
}

// Recipe Model
struct Recipe: Identifiable {
    let id = UUID()
    var name: String
    var imageName: String // Add imageName property to store asset names
    var variants: [String]
}

// Favorites View
struct FavoritesView: View {
    @Binding var favorites: [Recipe]

    var body: some View {
        VStack {
            Text("Favorite Recipes")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.top, 20)
                .padding(.horizontal)
            
            if favorites.isEmpty {
                Text("No favorite recipes yet.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(favorites) { recipe in
                            VStack {
                                // Display the recipe image with a fixed uniform size
                                Image(recipe.imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100) // Set a fixed size for the image
                                    .clipped() // Clip any overflowing content
                                    .cornerRadius(10)
                                
                                Text(recipe.name)
                                    .font(.body)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 100, height: 40)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// Custom Recipes View
struct CustomRecipesView: View {
    var body: some View {
        VStack {
            Text("Custom Recipes")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.top, 20)
                .padding(.horizontal)
            
            Text("You haven’t created any custom recipes yet. You can create recipes by tapping the edit icon in the upper right corner.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding()
        }
    }
}

// Preview
#Preview {
    ZStack {
        Color("Primary").ignoresSafeArea()
        Dashboard()
    }
}
