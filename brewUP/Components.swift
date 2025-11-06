import Foundation
import SwiftUI


// Image card with title
struct DrinkCard: View {
    var cardHeight: Float?
    var cardWidth: Float?
    let drink: Drink
    
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
            
            //Link to page with drink info
            DrinkPage(drink: drink)
            
        } label: {
            
            // DrinkCard Appearance
            VStack (spacing: -20){
                            
                //Image
                CustomAsyncImage(drink: drink)
                    .frame(width: CGFloat(cardWidth!), height: CGFloat(cardHeight!))
                    .cornerRadius(10)


                //Rectangle Title Card
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.button)
                        .frame(width: CGFloat(cardWidth!), height: CGFloat(cardHeight!/4))
                        .shadow(
                            color: .black.opacity(0.15),
                            radius: 4
                        )
                    Text(drink.name)
                        .foregroundStyle(Color.primary)
                        .frame(width: CGFloat(cardWidth! * 0.9), height: CGFloat(0.9 * cardHeight!/4))
                        .minimumScaleFactor(0.25)
                }
            }

        }
    }
}


// Sliders for the main page
struct Slider: View {
    let sliderTitle: String
    let arrowLink: AnyView
    let height: Float
    let drinks: [Drink]
    let addButtonAction: (() -> Void)?
    
    
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
                    .foregroundColor(Color.secondary)
                Spacer()
                
                // Link to Coffee Menu Page
                NavigationLink {
                    arrowLink
                } label: {
                    Image(systemName: "arrow.right")
                        .foregroundColor(Color.espresso)
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
                                    .fill(.button)
                                    .frame(width: CGFloat(4*height/3), height: CGFloat(height + 10))
                                    .shadow(
                                        color: .black.opacity(0.15),
                                        radius: 4
                                    )
                                    .padding(.bottom)
                                Image(systemName: "plus.app")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: CGFloat(4*height/9), height: CGFloat(height/3))
                                    .foregroundColor(.secondary)
                                    .padding(.bottom)
                                    
                            }
                        }
                    }
                }
            }
        } .padding(.horizontal) .padding(.top, 5)

    }
}


// Button
struct FullButton: View {
    let buttonText: String
    let buttonColor: Color?
    let textColor: Color?
    let icon: String?
    let action: () -> Void
    
    init(
        buttonText: String,
        buttonColor: Color? = Color.button,
        textColor: Color? = Color.primary,
        icon: String? = nil,
        action: @escaping () -> Void
    ) {
        self.buttonText = buttonText
        self.buttonColor = buttonColor
        self.textColor = textColor
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        HStack {
            Button(action: {
                action()
            }) {
                HStack {
                    if let icon = icon {
                        Image(systemName: icon)
                    }
                    Text(buttonText)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(buttonColor)
                .foregroundColor(textColor)
                .cornerRadius(20)
                .shadow(
                    color: .black.opacity(0.15),
                    radius: 4
                )

            }
        }
    }
}

// use this to input a UIImage and load it async and be able to place the image like I would a normal one, idk why this isnt already a thing
struct CustomAsyncImage: View {
    @State private var image: UIImage?
    private var drink: Drink
    
    init (drink: Drink) {
        self.drink = drink
    }
    
    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                ProgressView("Loading...")
            }
        }
        .task {
            // Async function called here
            image = await drink.getImage()
        }

    }
}


