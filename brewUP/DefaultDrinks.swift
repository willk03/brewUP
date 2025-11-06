import SwiftUI
import SwiftData

// Default Drinks displayed in the app
var defaultDrinks: [Drink] = [
    Drink(
        name: "Coffee",
        drinkDescription: "Regualar Cup of Coffee",
        tags: ["Default"],
        equipment: ["Espresso Machine", "Hot Water Tank", "Milk Frother"]),
    Drink(
        name: "Latte",
        drinkDescription: "Espresso With Steamed Milk",
        tags: ["Default"]),
    Drink(
        name: "Cold Brew",
        drinkDescription: "Alternative Brew Method for Iced Coffee",
        tags: ["Default"]),
    Drink(
        name: "Americano",
        drinkDescription: "Espresso With Hot Water",
        tags: ["Default"],
        ingredients: ["Espresso", "Hot Water"],
        equipment: ["Espresso Machine"],
        instructions: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum dictum nunc in enim tempor lacinia. Nunc condimentum pharetra maximus. Sed ut cursus ligula. Pellentesque vel lorem lobortis, euismod quam a, viverra sapien. Nulla sed pulvinar felis. Aenean gravida quam a arcu tempor gravida. Cras hendrerit rhoncus nisl, a fringilla nibh efficitur sit amet. Suspendisse vel mattis diam. Nullam mattis porttitor massa quis dignissim. Aliquam dignissim tortor at ipsum fermentum vulputate. Praesent ornare porta luctus. Vivamus mollis varius sapien, vel faucibus sapien semper ac. Quisque volutpat, lorem non cursus molestie, erat nulla tincidunt nulla, sollicitudin ultricies ipsum tellus nec libero. Phasellus eget dapibus mi, at mattis sapien. Aliquam nec arcu nec magna blandit blandit sit amet at tortor. Praesent posuere risus eget mauris vehicula, sit amet suscipit ligula fermentum."),
]



