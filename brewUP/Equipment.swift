import SwiftData
import SwiftUI

@Model
class Equipment {
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
    func compare(to other: Equipment) -> Bool {
        return backendName == other.backendName
    }
    
    // View to display Equipment card in list
    struct EquipmentView: View {
        @Bindable var equipment: Equipment
        var remove: () -> Void = { }
        var isEditing: Bool
        
        var body: some View {
            if(isEditing){
                ZStack {
                    TextField("Equipment Name", text: $equipment.displayName)
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
                Text(equipment.displayName)
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
        return EquipmentView(equipment: self, remove: remove, isEditing: isEditing)
    }
}

func equipmentToStrings(_ equipment: [Equipment]) -> [String] {
    return equipment.map(\.self.displayName)
}

func equipmentToString(_ equipment: [Equipment]) -> String {
    var out: String = ""
    for equip in equipment {
        out.append(contentsOf: "\(equip.displayName)|")
    }
    return out
}

func stringToEquipment(_ input: String) -> [Equipment] {
    var out: [Equipment] = []
    let split = input.split(separator: "|")
    for piece in split {
        if piece != "" {
            out.append(Equipment(displayName: String(piece)))
        }
    }
    return out
}


struct EquipmentStackView: View {
    var drink: Drink
    let isEditing: Bool
    
    init(drink: Drink, isEditing: Bool) {
        self.drink = drink
        self.isEditing = isEditing
    }
    
    var body: some View {
        VStack{
            HStack {
                Text("Equipment:")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding([.top, .leading])
                    .padding(.bottom, !isEditing ? -5 : 0)
                Spacer()
                if isEditing {
                    Button(
                        action: {
                            drink.equipment.append(Equipment(displayName: "New Equipment"))
                        }, label: {
                        Image(systemName: "plus")
                            .foregroundColor(.espresso)
                    })
                    .padding(.trailing)
                }
            }
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(.secondary.opacity(0.2))
                    .frame(maxWidth: .infinity, maxHeight: 50)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(drink.equipment.sorted { $0.dateCreated > $1.dateCreated }, id: \.self) { equipment in
                            equipment.getView(isEditing: isEditing, remove: {drink.equipment.removeAll(where: {$0.id == equipment.id})})
                                .padding(.leading, 10)
                        }
                    }
                }
            }
            .padding([.leading, .trailing], 20)
        }

    }
}
