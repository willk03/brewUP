//
//  CoffeeMenuPage.swift
//  brewUP
//
//  Created by Will Kuster on 1/16/26.
//
import SwiftUI
import Foundation
import PhotosUI
import SwiftData

/**
 * A grid-based menu page for browsing drinks.
 *
 * Displays drink cards in a vertically scrolling adaptive grid.
 * Intended to support different menu contexts (e.g. Favorites,
 * Explore, Search results) based on `pageType`.
 */
struct CoffeeMenuPage: View {
    var pageType: String
    let columns = [
        GridItem(.adaptive(minimum: 150)),
    ]
    let screenWidth = Float(UIScreen.main.bounds.width)
    let screenHeight = Float(UIScreen.main.bounds.height)
    
    /**
     * Creates a coffee menu page for a given page type.
     *
     * - Parameter pageType: Identifier describing what this page displays.
     */
    init(pageType: String) {
        self.pageType = pageType
    }
    
    var body: some View {
        NavigationStack {
            
            //Vertical Scrolling grid
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(0..<5){ index in
                        DrinkCard(
                            cardWidth: screenWidth * 0.45,
                            drink: defaultDrinks[Int.random(in: 0..<defaultDrinks.count)]
                        )
                    }
                }
                .padding()
            }
            
        }
        .navigationTitle("Favorites")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {print("Add Item")}) {
                    Image(systemName: "plus")
                        .foregroundColor(Theme.Colors.primary)
                }
            }
        }
        // End of Toolbar Code
    }
}
