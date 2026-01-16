//
//  DrinkPageContent.swift
//  brewUP
//
//  Created by Will Kuster on 1/16/26.
//
import SwiftUI
import Foundation
import PhotosUI
import SwiftData

/**
 * Displays the main content of a drink detail page.
 *
 * Responsible for rendering drink metadata, ingredients, equipment,
 * and instructions. Supports both view-only and editing modes.
 */
struct DrinkPageContent: View {

    @Bindable var drink: Drink
    var isEditing: Bool

    /**
     * Creates the content view for a drink page.
     *
     * - Parameters:
     *   - drink: The drink model being displayed.
     *   - isEditing: Whether the content should render in editing mode.
     */
    init(drink: Drink, isEditing: Bool) {
        self.drink = drink
        self.isEditing = isEditing
    }

    var body: some View {

        // MARK: - Read-Only Mode

        if !isEditing {
            HStack {
                Text(drink.name)
                    .font(.largeTitle)
                    .padding([.top, .leading])
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Image(systemName: "timer")
                    .padding([.trailing, .top])
                Text(drink.prepTime.description + " Mins")
                    .padding([.top, .trailing])
                    .padding(.leading, -20)
            }

            Text(drink.drinkDescription)
                .font(.subheadline)
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            IngredientStackView(drink: drink, isEditing: false)

            EquipmentStackView(drink: drink, isEditing: false)

            HStack {
                Text("Instructions:")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding([.top, .leading])
                    .padding(.bottom, !isEditing ? -5 : 0)
                Spacer()
            }

            VStack {
                Text(drink.instructions)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    .padding(.vertical, 10)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
            }
            .padding(.horizontal, 20)

            Spacer()

        // MARK: - Editing Mode

        } else {
            HStack {
                TextField("Drink Name", text: $drink.name)
                    .font(.largeTitle)
                    .padding([.top, .leading])
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Spacer()

                Stepper(
                    "Prep Time: \(drink.prepTime) min",
                    value: $drink.prepTime,
                    in: 0...30,
                    step: 1
                )
                .padding(.top)
                .padding(.trailing, 5)
            }

            TextField("Drink Description", text: $drink.drinkDescription)
                .font(.subheadline)
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            IngredientStackView(drink: drink, isEditing: true)

            EquipmentStackView(drink: drink, isEditing: true)

            HStack {
                Text("Instructions:")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding([.top, .leading])
                    .padding(.bottom, !isEditing ? -5 : 0)
                Spacer()
            }

            VStack {
                TextField("Instructions: ", text: $drink.instructions, axis: .vertical)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                    .lineLimit(10...20)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal, 20)

            Spacer()
        }
    }
}
