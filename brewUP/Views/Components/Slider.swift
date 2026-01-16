//
//  Slider.swift
//  brewUP
//
//  Created by Will Kuster on 1/16/26.
//
import Foundation
import SwiftUI

/**
 * A horizontal scrolling slider of drink cards.
 *
 * Displays a titled section containing a horizontally scrollable
 * list of `DrinkCard` views. Optionally includes an add button
 * for creating new drinks.
 */
struct Slider: View {
    let sliderTitle: String
    let arrowLink: AnyView
    let height: Float
    let drinks: [Drink]
    let addButtonAction: (() -> Void)?
    
    /**
     * Creates a slider section for displaying drink cards.
     *
     * - Parameters:
     *   - sliderTitle: Title shown above the slider.
     *   - arrowLink: Destination view for the arrow navigation link.
     *   - height: Height used to size each drink card.
     *   - drinks: List of drinks to display.
     *   - addButtonAction: Optional action triggered by the add button.
     */
    init(sliderTitle: String, arrowLink: AnyView, height: Float, drinks: [Drink], addButtonAction: (() -> Void)? = nil){
        self.sliderTitle = sliderTitle
        self.arrowLink = arrowLink
        self.height = height
        self.drinks = drinks
        self.addButtonAction = addButtonAction
    }
    
    var body: some View {
        
        VStack {
            HStack {
                Text(sliderTitle)
                    .font(.title3)
                    .foregroundColor(Theme.Colors.textSecondary)
                Spacer()
                
                // Link to Coffee Menu Page
                NavigationLink {
                    arrowLink
                } label: {
                    Image(systemName: "arrow.right")
                        .foregroundColor(Theme.Colors.primary)
                }
            }
            
            //Coffee Card Slider
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    Spacer()
                    ForEach(drinks, id: \.self){ drink in
                        DrinkCard(
                            cardHeight: height,
                            drink: drink
                        )
                            .padding(.bottom)
                    }
                    if addButtonAction != nil {
                        Button(action: addButtonAction!) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Theme.Colors.secondary)
                                    .frame(width: CGFloat(4*height/3), height: CGFloat(height + 10))
                                    .shadow(
                                        color: Theme.Shadows.cardShadow.color,
                                        radius: Theme.Shadows.cardShadow.radius
                                    )
                                    .padding(.bottom)
                                Image(systemName: "plus.app")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: CGFloat(4*height/9), height: CGFloat(height/3))
                                    .foregroundColor(Theme.Colors.textSecondary)
                                    .padding(.bottom)
                                    
                            }
                        }
                    }
                }
            }
        } .padding(.horizontal) .padding(.top, Theme.Spacing.small)

    }
}
