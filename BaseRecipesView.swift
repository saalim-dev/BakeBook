//import SwiftUI
//
//struct BaseRecipesView: View {
//    var recipes: [Recipe]
//    @Binding var showActionSheet: Bool
//    @Binding var selectedRecipe: Recipe?
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text("Base Recipes")
//                .font(.headline)
//                .fontWeight(.bold)
//                .padding(.leading)
//
//            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
//                ForEach(recipes) { recipe in
//                    VStack {
//                        Image(recipe.imageName)
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 100, height: 100)
//                            .clipped()
//                            .cornerRadius(10)
//                            .onTapGesture {
//                                selectedRecipe = recipe
//                                showActionSheet = true
//                            }
//                        
//                        Text(recipe.name)
//                            .font(.body)
//                            .lineLimit(2)
//                            .multilineTextAlignment(.center)
//                            .frame(width: 100, height: 40)
//                        
//                        HStack(spacing: 4) {
//                            ForEach(0..<4) { _ in
//                                Image(systemName: "star.fill")
//                                    .foregroundColor(.yellow)
//                                    .imageScale(.small)
//                            }
//                            Image(systemName: "star")
//                                .foregroundColor(.yellow)
//                                .imageScale(.small)
//                        }
//                        .padding(.bottom, 5)
//                        HStack(spacing: 5) {
//                            Image(systemName: "clock")
//                            Text("1.0 hrs")
//                                .font(.caption)
//                        }
//                    }
//                }
//            }
//            .padding(.horizontal)
//        }
//    }
//}
