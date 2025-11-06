//
//  ContentView.swift
//  drinkUP
//
//  Created by Will Kuster on 7/16/25.
//

import SwiftUI
import SwiftData
import PhotosUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var savedDrinks: [Drink]
    @State private var navigationPath = NavigationPath()
    @State private var draftDrink = Drink(name: "New Drink")    
    
    var body: some View {
        //let screenWidth = Float(UIScreen.main.bounds.width)
        let screenHeight = Float(UIScreen.main.bounds.height)


        //Nav Bar
        NavigationStack(path: $navigationPath) {
            
            //Main page content
            VStack{
                // Randon Drink Button Stack
                HStack {
                    FullButton(
                        buttonText: "Quick Drink",
                        buttonColor: Color.espresso,
                        textColor: Color.white,
                        icon: "house",
                        action: {doSomething()}
                    )
                    FullButton(
                        buttonText: "Random Drink",
                        icon: "pencil",
                        action: {doSomething()}
                    )
                } .padding()
                
                let sliderHeight = screenHeight/8.25
                
                // Coffee Card Slider
                Slider(
                    sliderTitle: "Explore",
                    arrowLink: AnyView(CoffeeMenuPage(pageType: "Explore")),
                    height: sliderHeight,
                    drinks: sortedByDateChecked(drinks: listOfTaggedDrinks(drinks: savedDrinks, includeTags: ["Default"], excludeTags: ["CreatedByUser"]))
                )

                // Favorites Coffee Card Slider
                Slider(
                    sliderTitle: "Favorites",
                    arrowLink: AnyView(CoffeeMenuPage(pageType: "Favorites")),
                    height: sliderHeight,
                    drinks: sortedByDateChecked(drinks: listOfTaggedDrinks(drinks: savedDrinks, includeTags: ["Favorite"])),
                    addButtonAction: {createNewDrink(tags: ["CreatedByUser", "Favorite"])}

                )
                
                // My Recipies Coffee Card Slider
                Slider(
                    sliderTitle: "My Recipies",
                    arrowLink: AnyView(CoffeeMenuPage(pageType: "Search By Equipment")),
                    height: sliderHeight,
                    drinks: sortedByDateChecked(drinks: listOfTaggedDrinks(drinks: savedDrinks, includeTags: ["CreatedByUser"])),
                    addButtonAction: {createNewDrink(tags: ["CreatedByUser"])}

                )
                

                
                //Edit home supplies button
                Spacer()
                FullButton(
                    buttonText: "Edit Home Supplies",
                    action: {doSomething()}
                )
                    .padding()

            }
            .navigationDestination(for: Drink.self) { object in
                DrinkPage(drink: object)
            }

            // Full App Background Modifiers
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
            .onAppear() {
                loadDefaultDrinksIfNeeded()
            }
            .onOpenURL { url in
                // Parse the URL
                if url.host == "drink" {
                    if let incomingDrink = Drink(DeepLinkBuilder.parseDeepLink(url).data!) {
                        modelContext.insert(incomingDrink)
                        navigationPath.append(incomingDrink)

                    }
                }

            }

            
            // End of Main Page content
            
            //Toolbar title and buttons
            .navigationTitle("brewUP")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: clearSavedDrinks) {
                        Image(systemName: "ellipsis")
                            .foregroundColor(Color.espresso)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {createNewDrink(tags: ["CreatedByUser"])}){
                        Image(systemName: "plus")
                            .foregroundColor(Color.espresso)
                    }
                }

            }

        }

    }


    private func doSomething() {
        print("did something")
//        do {
//            try modelContext.save()
//            print("Saved!")
//        } catch {
//            print("Bad Things have happened :(")
//        }
    }
    
    func clearSavedDrinks() {
        for drink in savedDrinks {
            modelContext.delete(drink)
        }
        try? modelContext.save()
    }
    
    func loadDefaultDrinksIfNeeded() {
        for drink in defaultDrinks {
            if drink.modelContext == nil && !savedDrinks.contains(where: { $0.name == drink.name }) {
                modelContext.insert(drink.copy())
            }
        }
    }
    
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
