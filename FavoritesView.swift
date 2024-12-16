//import SwiftUI
//
//struct FavoritesView: View {
//    @Binding var favorites: [Recipe]
//
//    var body: some View {
//        VStack {
//            Text("Favorite Recipes")
//                .font(.headline)
//                .fontWeight(.bold)
//                .padding(.top, 20)
//                .padding(.horizontal)
//            
//            if favorites.isEmpty {
//                Text("No favorite recipes yet.")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//                    .padding()
//            } else {
//                ScrollView {
//                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
//                        ForEach(favorites) { recipe in
//                            VStack {
//                                Image(recipe.imageName)
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    .frame(width: 100, height: 100)
//                                    .clipped()
//                                    .cornerRadius(10)
//                                
//                                Text(recipe.name)
//                                    .font(.body)
//                                    .lineLimit(2)
//                                    .multilineTextAlignment(.center)
//                                    .frame(width: 100, height: 40)
//                            }
//                        }
//                    }
//                }
//                .padding(.horizontal)
//            }
//        }
//    }
//}
