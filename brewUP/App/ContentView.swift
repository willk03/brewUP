//
//  ContentView.swift
//  drinkUP
//
//  Created by Will Kuster on 7/16/25.
//
import SwiftUI
import SwiftData
import PhotosUI

/**
 * Root view of the app.
 *
 * Serves as the main entry point for navigation, displays
 * the home screen sliders, and handles initial data loading
 * and deep link routing.
 */
struct ContentView: View {

    /** SwiftData model context for reading and writing drinks. */
    @Environment(\.modelContext) private var modelContext

    /** All persisted drinks queried from SwiftData. */
    @Query private var savedDrinks: [Drink]

    /** Navigation path used for programmatic navigation. */
    @State private var navigationPath = NavigationPath()

    /** Draft drink used when creating a new drink. */
    @State private var draftDrink = Drink(name: "New Drink")

    /**
     * Main home screen layout.
     *
     * Displays quick actions, drink sliders, and handles
     * deep link insertion and navigation.
     */
    var body: some View {

        // MARK: - Navigation Container

        NavigationStack(path: $navigationPath) {

            VStack {

                // MARK: - Quick Action Buttons

                HStack {
                    FullButton(
                        buttonText: "Quick Drink",
                        buttonColor: Theme.Colors.primary,
                        textColor: Color.white,
                        icon: "house",
                        action: { doSomething() }
                    )

                    FullButton(
                        buttonText: "Random Drink",
                        icon: "pencil",
                        action: { doSomething() }
                    )
                }
                .padding()

                // MARK: - Drink Sliders

                let sliderHeight = Float(UIScreen.main.bounds.height) / 8.25

                Slider(
                    sliderTitle: "Explore",
                    arrowLink: AnyView(CoffeeMenuPage(pageType: "Explore")),
                    height: sliderHeight,
                    drinks: DrinkListManager.sortedByDateChecked(
                        drinks: DrinkListManager.listOfTaggedDrinks(
                            drinks: savedDrinks,
                            includeTags: ["Default"],
                            excludeTags: ["CreatedByUser"]
                        )
                    )
                )

                Slider(
                    sliderTitle: "Favorites",
                    arrowLink: AnyView(CoffeeMenuPage(pageType: "Favorites")),
                    height: sliderHeight,
                    drinks: DrinkListManager.sortedByDateChecked(
                        drinks: DrinkListManager.listOfTaggedDrinks(
                            drinks: savedDrinks,
                            includeTags: ["Favorite"]
                        )
                    ),
                    addButtonAction: {
                        createNewDrink(tags: ["CreatedByUser", "Favorite"])
                    }
                )

                Slider(
                    sliderTitle: "My Recipes",
                    arrowLink: AnyView(CoffeeMenuPage(pageType: "Search By Equipment")),
                    height: sliderHeight,
                    drinks: DrinkListManager.sortedByDateChecked(
                        drinks: DrinkListManager.listOfTaggedDrinks(
                            drinks: savedDrinks,
                            includeTags: ["CreatedByUser"]
                        )
                    ),
                    addButtonAction: {
                        createNewDrink(tags: ["CreatedByUser"])
                    }
                )

                // MARK: - Footer Actions

                Spacer()

                FullButton(
                    buttonText: "Edit Home Supplies",
                    action: { doSomething() }
                )
                .padding()
            }

            // MARK: - Navigation Destinations

            .navigationDestination(for: Drink.self) { drink in
                DrinkPage(drink: drink)
            }

            // MARK: - Lifecycle & Routing

            .background(Theme.Colors.background)
            .onAppear {
                loadDefaultDrinksIfNeeded()
            }
            .onOpenURL { url in
                if url.host == "drink",
                   let incomingDrink = Drink(
                       DeepLinkBuilder.parseDeepLink(url).data!
                   ) {
                    modelContext.insert(incomingDrink)
                    navigationPath.append(incomingDrink)
                }
            }

            // MARK: - Navigation Bar

            .navigationTitle("brewUP")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: clearSavedDrinks) {
                        Image(systemName: "ellipsis")
                            .foregroundColor(Theme.Colors.primary)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        createNewDrink(tags: ["CreatedByUser"])
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(Theme.Colors.primary)
                    }
                }
            }
        }
    }
    
    // MARK: Functionality

    /**
     * Placeholder action for unimplemented buttons.
     */
    private func doSomething() {
        print("did something")
    }

    /**
     * Deletes all saved drinks from persistent storage.
     */
    func clearSavedDrinks() {
        for drink in savedDrinks {
            modelContext.delete(drink)
        }
        try? modelContext.save()
    }

    /**
     * Inserts default drinks into storage if they do not already exist.
     *
     * Prevents duplicate default entries by checking drink names.
     */
    func loadDefaultDrinksIfNeeded() {
        for drink in defaultDrinks {
            if drink.modelContext == nil &&
                !savedDrinks.contains(where: { $0.name == drink.name }) {
                modelContext.insert(drink.copy())
            }
        }
    }

    /**
     * Creates and navigates to a new drink.
     *
     * - Parameter tags: Tags applied to the newly created drink.
     */
    public func createNewDrink(tags: [String] = []) {
        let newDrink = Drink(name: "newDrink", tags: tags)
        modelContext.insert(newDrink)
        try? modelContext.save()
        navigationPath.append(newDrink)
    }
}


#Preview {
    ContentView()
        .modelContainer(for: Drink.self, inMemory: true)
}
