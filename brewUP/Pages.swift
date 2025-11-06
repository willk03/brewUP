import SwiftUI
import Foundation
import PhotosUI
import SwiftData

struct CoffeeMenuPage: View {
    var pageType: String
    let columns = [
        GridItem(.adaptive(minimum: 150)),
    ]
    let screenWidth = Float(UIScreen.main.bounds.width)
    let screenHeight = Float(UIScreen.main.bounds.height)
    
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
                        .foregroundColor(Color.espresso)
                }
            }
        }
        // End of Toolbar Code

    }
}


// Page view for any given drink object
struct DrinkPage: View {
    let drink: Drink
    @State private var selectedImage: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var showPicker = false
    @State private var isEditing: Bool = false
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteAlert = false
    
    init(drink: Drink, isEditing: Bool = false) {
        self.drink = drink
        self.isEditing = isEditing
    }
    
    var body: some View {
        ZStack {
            VStack {
                if drink.hasImage() {
                    CustomAsyncImage(drink: drink)
                        .frame(width: UIScreen.main.bounds.width, height: 300)
                        .clipped()
                        .mask(
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: .clear, location: 0.0),
                                    .init(color: .black, location: 0.8),
                                    .init(color: .black, location: 1.0)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .padding(.top, 60)
                        .id(selectedImage)
                        .overlay(
                                isEditing ?
                                VStack {
                                    Image(systemName: "photo")
                                        .font(.title)
                                        .foregroundColor(.gray)
                                    Text("Tap to select")
                                        .foregroundColor(.gray)
                                }.padding(.top, 50)
                                : nil
                        )
                } else {
                    Rectangle()
                        .fill(.gray)
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 300)
                        .clipped()
                        .mask(
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: .clear, location: 0.0),
                                    .init(color: .black, location: 0.8),
                                    .init(color: .black, location: 1.0)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .padding(.top, 60)
                        .overlay(
                                isEditing ?
                                VStack {
                                    Image(systemName: "photo")
                                        .font(.title)
                                        .foregroundColor(.gray)
                                    Text("Tap to select")
                                        .foregroundColor(.gray)
                                }.padding(.top, 50)
                                : nil
                        )
                }

                Spacer()
            }
            
            ScrollView {
                ZStack {
                    VStack {
                        // Invisible button for image picker
                        if isEditing {
                            PhotosPicker(selection: $photosPickerItem, matching: .images) {
                                Rectangle()
                                    .opacity(0)
                                    .frame(height: 330)
                            }
                            .onChange(of: photosPickerItem) { _, newValue in
                                Task {
                                    if let data = try? await newValue?.loadTransferable(type: Data.self) {
                                        selectedImage = UIImage(data: data)
                                        drink.setImage(selectedImage)
                                    }
                                }
                            }
                        } else {
                            Rectangle()
                                .opacity(0)
                                .frame(height: 330)
                        }

                        // Background panel
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.button)
                            .frame(width: UIScreen.main.bounds.width, height: 800)
                            //.padding(.top, 330)
                            .aspectRatio(contentMode: .fill)
                        Spacer()
                    }
                    
                    // Drink Page Content
                    VStack {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.secondary)
                            .frame(width: UIScreen.main.bounds.width/3, height: 6)
                            .padding(.top, 15)
                            .padding(.bottom, -21)
                        // All main body content
                        DrinkPageContent(drink: drink, isEditing: isEditing)
                        Spacer()
                    }
                    .padding(.top, 330)
                }
            }
        }
        // Full App Background Modifiers
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)

        
        .ignoresSafeArea()
        .navigationTitle(drink.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {print(DeepLinkBuilder.createDeepLink(action: "drink", data: drink.getDictonary())?.absoluteString)}) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(Color.espresso)
                }
            }

            if(isEditing){
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showDeleteAlert = true
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {isEditing.toggle()}) {
                    Image(systemName: "pencil")
                        .foregroundColor(Color.espresso)
                        .padding(.trailing, -10)
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {drink.toggleFavorite()}) {
                    Image(systemName: drink.containsTag("Favorite") ? "heart.fill" : "heart")
                        .foregroundColor(Color.espresso)
                }
            }

        }
        .alert("Delete Drink", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                modelContext.delete(drink)
                try? modelContext.save()
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete \(drink.name)? This cannot be undone.")
        }
        .onAppear(perform: {
            print("Loaded Drink Page")
            drink.dateLastChecked = Date()
        })
        // End of Toolbar Code
        
    }
    
    func deleteDrink() {
        modelContext.delete(drink)
        try? modelContext.save()
        dismiss()  // Go back after deletion
    }
}


//Content on the card of the drink page
struct DrinkPageContent: View {
    @Bindable var drink: Drink
    var isEditing: Bool
    
    init(drink: Drink, isEditing: Bool) {
        self.drink = drink
        self.isEditing = isEditing
    }
    
    var body: some View {
        if !isEditing {
            // Name + Prep Time
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
            
            // Description
            Text(drink.drinkDescription)
                .font(.subheadline)
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Ingredients
            IngredientStackView(drink: drink, isEditing: false)
            
            // Equipment
            EquipmentStackView(drink: drink, isEditing: false)
            
            // Instructions
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

            } .padding(.horizontal, 20)
            
            Spacer()
        } else {
            HStack{
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
                    step: 1)
                .padding(.top)
                .padding(.trailing, 5)

            }
            TextField("Drink Description", text: $drink.drinkDescription)
                .font(.subheadline)
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            // Ingredients
            IngredientStackView(drink: drink, isEditing: true)
            
            // Equipment
            EquipmentStackView(drink: drink, isEditing: true)
            
            // Instructions
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
                    

            } .padding(.horizontal, 20)

            Spacer()
        }
    }
}

