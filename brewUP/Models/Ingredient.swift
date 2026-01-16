import SwiftData
import SwiftUI

@Model
class Ingredient {
    // Display Name
    var displayName: String
    
    // Backend Name
    var backendName: String
    var id = UUID()
    var dateCreated: Date = Date()
        
    // Init
    init(displayName: String) {
        self.displayName = displayName
        self.backendName = displayName.lowercased().replacingOccurrences(of: " ", with: "")
    }
    
    // Compare
    func compare(to other: Ingredient) -> Bool {
        return backendName == other.backendName
    }
    
    // View to display Ingredient card in list
    struct IngredientView: View {
        @Bindable var ingredient: Ingredient
        var remove: () -> Void = { }
        var isEditing: Bool
        
        var body: some View {
            if(isEditing){
                ZStack {
                    TextField("Ingredient Name", text: $ingredient.displayName)
                        .foregroundColor(.primary)
                        .font(.body)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 3)
                        .background(.button)
                        .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay(alignment: .topTrailing) {
                            Button(action: remove, label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.espresso)
                            })
                            .padding(.leading)
                        }
                }
            } else {
                Text(ingredient.displayName)
                    .foregroundColor(.primary)
                    .font(.body)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 3)
                    .background(.button)
                    .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
            }
        }
    }
    
    func getView(isEditing: Bool, remove: @escaping () -> Void = {}) -> some View {
        return IngredientView(ingredient: self, remove: remove, isEditing: isEditing)
    }
}

func ingredientsToStrings(_ ingredient: [Ingredient]) -> [String] {
    return ingredient.map(\.self.displayName)
}

func ingredientsToString(_ ingredient: [Ingredient]) -> String {
    var out: String = ""
    for equip in ingredient {
        out.append(contentsOf: "\(equip.displayName)|")
    }
    return out
}

func stringToIngredients(_ input: String) -> [Ingredient] {
    var out: [Ingredient] = []
    let split = input.split(separator: "|")
    for piece in split {
        if piece != "" {
            out.append(Ingredient(displayName: String(piece)))
        }
    }
    return out
}
