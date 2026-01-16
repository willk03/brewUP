import Foundation
import SwiftData
import PhotosUI

/**
 * Represents a beverage recipe with ingredients, instructions, and metadata.
 *
 * The Drink model is the core data structure of the brewUP app, storing all information
 * about a beverage including its recipe, categorization, and user preferences. It supports
 * both default drinks and user-created recipes.
 *
 * - Important: This class uses SwiftData for persistence. Ensure modelContainer is configured.
 *
 * ## Usage Example:
 * ```swift
 * let drink = Drink(
 *     name: "Latte",
 *     drinkDescription: "Espresso with steamed milk",
 *     tags: ["Default", "Favorite"],
 *     ingredients: ["Espresso", "Milk"],
 *     equipment: ["Espresso Machine", "Steam Wand"]
 * )
 * ```
 *
 * ## Tags System:
 * - "Default": Pre-loaded drinks that come with the app
 * - "Favorite": User-marked favorite drinks
 * - "CreatedByUser": Drinks created by the user
 * - "NewlyCreated": Drinks imported via deep link
 *
 * - Note: Drinks can have multiple tags for categorization and filtering
 */
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
    
    /**
     * Creates a deep copy of the drink.
     *
     * - Returns: A new Drink instance with identical properties
     */
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
    
    /**
     * Converts the drink to a dictionary for deep linking.
     *
     * Creates a serializable representation of the drink that can be
     * encoded and shared via URL.
     *
     * - Returns: Dictionary containing the drink's shareable properties
     */
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
    
    /**
     * Checks if the drink contains a specific tag.
     *
     * - Parameter tag: The tag to search for
     * - Returns: True if the drink's tags array contains the specified tag
     */
    func containsTag(_ tag: String) -> Bool {
        return self.tags.contains(tag)
    }
    

    /**
     * Toggles the "Favorite" tag on this drink.
     *
     * If the drink is currently a favorite, removes the tag.
     * If not a favorite, adds the tag.
     */
    func toggleFavorite() {
        if self.tags.contains("Favorite") {
            self.tags.removeAll { $0 == "Favorite" }
        } else {
            self.tags.append("Favorite")
        }
    }
    
    /**
     * Retrieves the drink's image from any available source.
     *
     * Checks sources in this order:
     * 1. User-uploaded imageData
     * 2. Remote imageURL
     * 3. Local imageName asset
     *
     * - Returns: UIImage if available, nil otherwise
     * - Note: This is an async function as it may need to download from URL
     */
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
    
    /**
     * Sets the drink's image from a UIImage.
     *
     * Compresses the image to JPEG format and stores in imageData.
     *
     * - Parameters:
     *   - image: The UIImage to store, or nil to clear the image
     *   - compressionQuality: JPEG compression quality (0.0 - 1.0), defaults to 0.8
     */
    func setImage(_ image: UIImage?, compressionQuality: CGFloat = 0.8) {
        if let image = image {
            self.imageData = image.jpegData(compressionQuality: compressionQuality)
        } else {
            self.imageData = nil
        }
    }
    
    /**
     * Asynchronously loads an image from a URL.
     *
     * This is a private helper method used internally by `getImage()` when
     * the drink has an imageURL but no local imageData.
     *
     * - Parameter url: The URL to download the image from
     * - Returns: UIImage if successfully downloaded, nil if download fails
     *
     * - Warning: This method performs a network request and should only be called
     *           from an async context. Use `getImage()` instead of calling directly.
     *
     * - Note: Errors are caught and printed to console but not thrown, returning nil instead.
     *
     * ## Implementation Details:
     * Uses URLSession.shared for the network request. Does not cache the downloaded
     * image - it's expected that the caller will store it in imageData if needed.
     *
     * ## Example (Internal use only):
     * ```swift
     * if let url = imageURL {
     *     let image = await loadImage(from: url)
     *     return image
     * }
     * ```
     */
    private func loadImage(from url: URL) async -> UIImage? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            print("Failed to load image: \(error)")
            return nil
        }
    }

    /**
     * Checks if the drink has any form of image available.
     *
     * - Returns: True if the drink has imageData, imageURL, or a non-default imageName
     */
    func hasImage () -> Bool {
        return imageData != nil || imageURL != nil || imageName != "DefaultCoffeePicture"
    }
}
