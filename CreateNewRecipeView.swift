//import SwiftUI
//
//struct CreateNewRecipeView: View {
//    @Environment(\.dismiss) var dismiss
//    @Binding var recipes: [Recipe] // Binding to the base recipes
//    @State private var recipeName = ""
//    @State private var cookingTime = ""
//    @State private var rating = 0
//    @State private var selectedTab = 0 // For Ingredients, Instructions, Timer
//    @State private var image: UIImage? = nil
//    @State private var imagePickerPresented = false
//    @State private var ingredients = ""
//    @State private var instructions = ""
//    @State private var errorMessage = "" // For name validation
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                HStack {
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                    Spacer()
//                    Button("Save") {
//                        if validateRecipeName() {
//                            saveRecipe()
//                            dismiss()
//                        }
//                    }
//                    .disabled(recipeName.isEmpty || ingredients.isEmpty || instructions.isEmpty || cookingTime.isEmpty || image == nil) // Disable if required fields are missing
//                }
//                .padding()
//                
//                HStack {
//                    // Image picker
//                    Button(action: {
//                        imagePickerPresented.toggle()
//                    }) {
//                        if let image = image {
//                            Image(uiImage: image)
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 120, height: 120)
//                                .cornerRadius(10)
//                        } else {
//                            ZStack {
//                                Rectangle()
//                                    .fill(Color.gray.opacity(0.4))
//                                    .frame(width: 120, height: 120)
//                                    .cornerRadius(10)
//                                Image(systemName: "camera")
//                                    .foregroundColor(.white)
//                                    .font(.system(size: 40))
//                            }
//                        }
//                    }
//                    .sheet(isPresented: $imagePickerPresented) {
//                        ImagePicker(image: $image)
//                    }
//                    
//                    Spacer()
//                    
//                    VStack(alignment: .leading, spacing: 8) {
//                        // Recipe name input with validation
//                        TextField("Enter Cake Name", text: $recipeName)
//                            .font(.title3)
//                            .padding(10)
//                            .background(Color.gray.opacity(0.1))
//                            .cornerRadius(10)
//                            .onChange(of: recipeName) { _ in
//                                validateRecipeName()
//                            }
//                        
//                        if !errorMessage.isEmpty {
//                            Text(errorMessage)
//                                .foregroundColor(.red)
//                                .font(.caption)
//                        }
//                        
//                        // Cooking time and rating
//                        HStack {
//                            Image(systemName: "clock")
//                            TextField("Cooking Time", text: $cookingTime) // Dynamic input for cooking time
//                                .padding(10)
//                                .background(Color.gray.opacity(0.1))
//                                .cornerRadius(10)
//                            
//                            Spacer()
//                            
//                            // Rating stars
//                            HStack(spacing: 4) {
//                                ForEach(1..<6) { star in
//                                    Image(systemName: star <= rating ? "star.fill" : "star")
//                                        .foregroundColor(.yellow)
//                                        .onTapGesture {
//                                            rating = star
//                                        }
//                                }
//                            }
//                        }
//                    }
//                }
//                .padding()
//                
//                // Segmented control for Ingredients and Instructions
//                Picker("", selection: $selectedTab) {
//                    Text("Ingredients").tag(0)
//                    Text("Instructions").tag(1)
//                }
//                .pickerStyle(SegmentedPickerStyle())
//                .padding(.horizontal)
//
//                // Text input for Ingredients or Instructions depending on the selected tab
//                if selectedTab == 0 {
//                    TextEditor(text: $ingredients)
//                        .padding()
//                        .frame(height: 200)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 10)
//                                .stroke(Color.gray, lineWidth: 1)
//                        )
//                        .padding(.horizontal)
//                } else if selectedTab == 1 {
//                    TextEditor(text: $instructions)
//                        .padding()
//                        .frame(height: 200)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 10)
//                                .stroke(Color.gray, lineWidth: 1)
//                        )
//                        .padding(.horizontal)
//                }
//
//                Spacer()
//            }
//            .background(Color.black.ignoresSafeArea()) // Apply background color
//        }
//    }
//    
//    // Recipe name validation (trimming whitespaces, limit to 16 characters)
//    private func validateRecipeName() -> Bool {
//        let trimmedName = recipeName.trimmingCharacters(in: .whitespacesAndNewlines)
//        if trimmedName.isEmpty {
//            errorMessage = "Recipe name cannot be empty."
//            return false
//        } else if trimmedName.count > 16 {
//            errorMessage = "Recipe name can't exceed 16 characters."
//            return false
//        } else {
//            errorMessage = ""
//            return true
//        }
//    }
//    
//    // Save the new recipe to base recipes
//    private func saveRecipe() {
//        let newRecipe = Recipe(
//            name: recipeName.trimmingCharacters(in: .whitespacesAndNewlines),
//            imageName: "custom_image", // Placeholder for image handling
//            variants: [],
//            ingredients: ingredients.trimmingCharacters(in: .whitespacesAndNewlines),
//            instructions: instructions.trimmingCharacters(in: .whitespacesAndNewlines),
//            cookingTime: cookingTime.trimmingCharacters(in: .whitespacesAndNewlines)
//        )
//        recipes.append(newRecipe)
//    }
//}
