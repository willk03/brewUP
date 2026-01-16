//
//  EquipmentStackView.swift
//  brewUP
//
//  Created by Will Kuster on 1/16/26.
//
import SwiftData
import SwiftUI

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
