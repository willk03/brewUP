//
//  DrinkCard.swift
//  brewUP
//
//  Created by Will Kuster on 1/16/26.
//
import Foundation
import SwiftUI


/**
 * A tappable card view that displays a preview of a drink.
 *
 * The card shows the drink image with a title overlay and navigates
 * to the drink detail page when tapped. The card maintains a 4:3
 * aspect ratio, automatically deriving width or height when only
 * one dimension is provided.
 */
struct DrinkCard: View {
    var cardHeight: Float?
    var cardWidth: Float?
    let drink: Drink
    
    /**
     * Creates a drink card with either a fixed height or width.
     *
     * If `cardWidth` is provided, the height is calculated as 3:4.
     * Otherwise, the width is calculated as 4:3 using `cardHeight`.
     *
     * - Parameters:
     *   - cardHeight: Desired card height. Used to derive width if `cardWidth` is nil.
     *   - cardWidth: Desired card width. Used to derive height if provided.
     *   - drink: The drink model displayed by this card.
     */
    init(cardHeight: Float? = 100, cardWidth: Float? = nil, drink: Drink) {
        self.cardHeight = cardHeight
        self.cardWidth = cardWidth
        self.drink = drink
        
        
        if cardWidth != nil {
            self.cardHeight = 3*cardWidth!/4
        } else {
            self.cardWidth = 4*cardHeight!/3
        }
    }
    
    var body: some View {
    
        NavigationLink {
            
            // Link to page with drink info
            DrinkPage(drink: drink)
            
        } label: {
            
            // DrinkCard Appearance
            VStack (spacing: -20){
                            
                //Image
                CustomAsyncImage(drink: drink)
                    .frame(width: CGFloat(cardWidth!), height: CGFloat(cardHeight!))
                    .cornerRadius(Theme.CornerRadius.medium)


                //Rectangle Title Card
                ZStack {
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.medium)
                        .fill(Theme.Colors.secondary)
                        .frame(width: CGFloat(cardWidth!), height: CGFloat(cardHeight!/4))
                        .shadow(
                            color: Theme.Shadows.cardShadow.color,
                            radius: Theme.Shadows.cardShadow.radius
                        )
                    Text(drink.name)
                        .foregroundStyle(Theme.Colors.textPrimary)
                        .frame(width: CGFloat(cardWidth! * 0.9), height: CGFloat(0.9 * cardHeight!/4))
                        .minimumScaleFactor(0.25)
                }
            }

        }
    }
}
