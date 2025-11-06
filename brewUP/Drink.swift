import Foundation
import SwiftData
import PhotosUI


@Model
class Drink {
    
    // Basic Information
    var name: String
    var drinkDescription: String
    var tags: [String] = []
    var id = UUID()
    var dateCreated: Date
    var dateLastChecked: Date
    var rating: Double

    // Image Data
    var imageName: String
    @Attribute(.externalStorage) var imageData: Data?
    var imageURL: URL?
    
    // Preperation
    var prepTime: Int
    var ingredients: [Ingredient]
    var equipment: [Equipment]
    var instructions: String
    
    // Categories
    var difficulty: Difficulty // enum: easy, medium, hard
    var category: DrinkCategory // enum: coffee, tea, smoothie, juice...
    var temperature: Temperature // enum: hot, cold, both
    var caffeineLevel: CaffeineLevel // enum: caff, decaf, optional
    var timeOfDay: TimeOfDay // enum: morning, afternoon, night, anytime
    var season: Season // enum: spring, summer, fall, winter, any season
    
    // Personal
    var notes: String
        
    init (
        name: String = "Drink",
        drinkDescription: String = "A tasty drink!",
        tags: [String] = [],
        rating: Double = 0,
        
        imageName: String = "DefaultCoffeePicture",
        imageData: Data? = nil,
        imageURL: URL? = nil,
        
        prepTime: Int = 5,
        ingredients: [String] = [],
        equipment: [String] = [],
        instructions: String = "",
        
        difficulty: Difficulty = .easy,
        category: DrinkCategory = .coffee,
        temperature: Temperature = .hot,
        caffeineLevel: CaffeineLevel = .caf,
        timeOfDay: TimeOfDay = .anytime,
        season: Season = .anySeason,
        
        notes: String = ""
    ){
        self.name = name
        self.drinkDescription = drinkDescription
        self.tags = tags
        self.id = UUID()
        self.dateCreated = Date()
        self.dateLastChecked = Date()
        self.rating = rating
        
        self.imageName = imageName
        self.imageData = imageData
        self.imageURL = imageURL
        
        self.prepTime = prepTime
        self.ingredients = []
        self.equipment = []
        self.instructions = instructions
        
        self.difficulty = difficulty
        self.category = category
        self.temperature = temperature
        self.caffeineLevel = caffeineLevel
        self.timeOfDay = timeOfDay
        self.season = season
        
        self.notes = notes
        
        // Set the ingredients/equipment based off list of strings
        for ingredient in ingredients {
            self.ingredients.append(Ingredient(displayName: ingredient))
        }
        for equip in equipment {
            self.equipment.append(Equipment(displayName: equip))
        }

    }
    
    func copy() -> Drink {
        return Drink(
            name: self.name,
            drinkDescription: self.drinkDescription,
            tags: self.tags,
            
            imageName: self.imageName,
            imageData: self.imageData,
            imageURL: self.imageURL,
            
            prepTime: self.prepTime,
            ingredients: ingredientsToStrings(self.ingredients),
            equipment: equipmentToStrings(self.equipment),
            instructions: self.instructions,
            
            difficulty: self.difficulty,
            category: self.category,
            temperature: self.temperature,
            caffeineLevel: self.caffeineLevel,
            timeOfDay: self.timeOfDay
            )
    }
    
    func containsTag(_ tag: String) -> Bool {
        return self.tags.contains(tag)
    }
    
    func toggleFavorite() {
        if self.tags.contains("Favorite") {
            self.tags.removeAll { $0 == "Favorite" }
        } else {
            self.tags.append("Favorite")
        }
    }
    
    // Function to return UIImage no matter the way its stored in file
    func getImage () async -> UIImage? {
        if imageData != nil  {
            // Computed property to get UIImage
            var image: UIImage? {
                guard let imageData = imageData else { return nil }
                return UIImage(data: imageData)
            }
            return image

        } else if imageURL != nil {
            let image = await loadImage(from: imageURL!)
            return image
        } else {
            return UIImage(named: imageName)
        }
    }
    
    // Set image based off a UIImage input (From photos picker)
    func setImage(_ image: UIImage?, compressionQuality: CGFloat = 0.8) {
        if let image = image {
            self.imageData = image.jpegData(compressionQuality: compressionQuality)
        } else {
            self.imageData = nil
        }
    }
    
    //Used to load drink image from URL, dont call just use getImage function
    func loadImage(from url: URL) async -> UIImage? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            print("Failed to load image: \(error)")
            return nil
        }
    }

    func hasImage () -> Bool {
        return imageData != nil || imageURL != nil || imageName != "DefaultCoffeePicture"
    }
    
    
    // Enums for choices
    enum Difficulty: String, Codable, CaseIterable {
        case easy = "Beginner"
        case medium = "Medium"
        case hard = "Hard"
        case expert = "Expert Barista"
    }

    enum DrinkCategory: String, Codable, CaseIterable {
        case coffee = "Coffee"
        case tea = "Tea"
        case smoothie = "Smoothie"
        case juice = "Juice"
        case soda = "Soda"
        case water = "Infused Water"
        case other = "Other"
    }

    enum Temperature: String, Codable, CaseIterable {
        case hot = "Hot"
        case cold = "Cold"
        case both = "Hot or Cold"
    }

    enum CaffeineLevel: String, Codable, CaseIterable {
        case decaf = "Decaf"
        case caf = "Caffeinated"
        case optional = "Optional Caffeine"
    }

    enum TimeOfDay: String, Codable, CaseIterable {
        case morning = "Morning"
        case afternoon = "Afternoon"
        case night = "Night"
        case anytime = "Anytime"
    }
    
    enum Season: String, Codable, CaseIterable {
        case spring = "Spring"
        case summer = "Summer"
        case fall = "Fall"
        case winter = "Winter"
        case anySeason = "Any Season"
    }
    
    
    func getDictonary () -> [String: Any] {
        let output: [String: Any] = [
            "name" : self.name,
            "drinkDescription" : self.drinkDescription,
            "tags" : self.tags,
                                    
            "prepTime" : self.prepTime,
            "ingredients" : ingredientsToString(self.ingredients),
            "equipment" : equipmentToString(self.equipment),
            "instructions" : self.instructions,
            
            "difficulty" : self.difficulty.rawValue,
            "category" : self.category.rawValue,
            "temperature" : self.temperature.rawValue,
            "caffeineLevel" : self.caffeineLevel.rawValue,
            "timeOfDay" : self.timeOfDay.rawValue
        ]
        
        return output
    }
    
    init?(_ dictionary: [String: Any]){
        self.name = dictionary["name"] as? String ?? ""
        self.drinkDescription = dictionary["drinkDescription"] as? String ?? ""
        self.tags = dictionary["tags"] as? [String] ?? []
        self.id = UUID()
        self.dateCreated = Date()
        self.dateLastChecked = Date()
        self.rating = 0
        
        self.imageName = "DefaultCoffeePicture"
        self.imageData = nil
        self.imageURL = nil
        
        self.prepTime = dictionary["prepTime"] as? Int ?? 0
        let tempIngredients = dictionary["ingredients"] as? String ?? ""
        self.ingredients = stringToIngredients(tempIngredients)
        let tempEquipment = dictionary["equipment"] as? String ?? ""
        self.equipment = stringToEquipment(tempEquipment)
        self.instructions = dictionary["instructions"] as? String ?? ""
        
        let difficultyString = dictionary["difficulty"] as? String ?? ""
        let category = dictionary["category"] as? String ?? ""
        let temperature = dictionary["temperature"] as? String ?? ""
        let caffeineLevel = dictionary["caffeineLevel"] as? String ?? ""
        let timeOfDay = dictionary["timeOfDay"] as? String ?? ""
        let season = dictionary["season"] as? String ?? ""

        
        self.difficulty = Difficulty(rawValue: difficultyString) ?? .easy
        self.category = DrinkCategory(rawValue: category) ?? .other
        self.temperature = Temperature(rawValue: temperature) ?? .hot
        self.caffeineLevel = CaffeineLevel(rawValue: caffeineLevel) ?? .caf
        self.timeOfDay = TimeOfDay(rawValue: timeOfDay) ?? .anytime
        self.season = Season(rawValue: season) ?? .anySeason
        
        self.notes = ""
        
        self.tags.append("NewlyCreated")
    }
    
}

func listOfTaggedDrinks(drinks: [Drink], includeTags: [String] = [], excludeTags: [String] = []) -> [Drink] {
    var result: [Drink] = []
    for tag in includeTags {
        for drink in drinks {
            if drink.tags.contains(tag) && result.firstIndex(of: drink) == nil {
                result.append(drink)
            }
        }
    }
    for tag in excludeTags {
        for drink in result {
            if drink.tags.contains(tag) {
                result.removeAll { $0 === drink}
            }
        }
    }
    return result
}

func sortedByDateCreated( drinks: [Drink]) -> [Drink] {
    return drinks.sorted { $0.dateCreated > $1.dateCreated }
}

func sortedByDateChecked( drinks: [Drink]) -> [Drink] {
    return drinks.sorted { $0.dateLastChecked > $1.dateLastChecked }
}
