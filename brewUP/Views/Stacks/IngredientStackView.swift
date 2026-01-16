//
//  IngredientStackView.swift
//  brewUP
//
//  Created by Will Kuster on 1/16/26.
//
import SwiftData
import SwiftUI

struct IngredientStackView: View {
    var drink: Drink
    var isEditing: Bool
    
    init(drink: Drink, isEditing: Bool) {
        self.drink = drink
        self.isEditing = isEditing
    }
    
    var body: some View {
        HStack {
            Text("Ingredients:")
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding([.top, .leading])
                .padding(.bottom, !isEditing ? -5 : 0)
            Spacer()
            if isEditing {
                Button(
                    action: {
                        drink.ingredients.append(Ingredient(displayName: "New Ingredient"))
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
                    ForEach(drink.ingredients.sorted { $0.dateCreated > $1.dateCreated }, id: \.self) { ingredient in
                        ingredient.getView(
                            isEditing: isEditing,
                            remove: {drink.ingredients.removeAll(
                                where: { $0.id == ingredient.id}
                            )})
                        .padding(.leading, 10)
                    }
                }
            }
        }
        .padding([.leading, .trailing], 20)

    }
}
