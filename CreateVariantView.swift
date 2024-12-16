//import SwiftUI
//
//struct CreateVariantView: View {
//    @Binding var newVariantName: String
//    var onSave: () -> Void
//    @Environment(\.dismiss) var dismiss
//    @State private var errorMessage = ""
//
//    var body: some View {
//        VStack {
//            Text("Create New Variant")
//                .font(.headline)
//                .padding(.top)
//            
//            TextField("Variant Name", text: $newVariantName)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//                .onChange(of: newVariantName) { _ in
//                    validateVariantName()
//                }
//            
//            if !errorMessage.isEmpty {
//                Text(errorMessage)
//                    .foregroundColor(.red)
//                    .font(.caption)
//                    .padding(.bottom, 5)
//            }
//            
//            Button("Save Variant") {
//                if validateVariantName() {
//                    onSave()
//                    dismiss()
//                }
//            }
//            .disabled(newVariantName.isEmpty)
//            .padding()
//        }
//        .padding()
//    }
//
//    private func validateVariantName() -> Bool {
//        let trimmedName = newVariantName.trimmingCharacters(in: .whitespacesAndNewlines)
//        if trimmedName.isEmpty {
//            errorMessage = "Variant name cannot be empty."
//            return false
//        }
//        errorMessage = ""
//        return true
//    }
//}
