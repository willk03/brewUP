//
//  DrinkDataEnums.swift
//  brewUP
//
//  Created by Will Kuster on 1/16/26.
//
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
