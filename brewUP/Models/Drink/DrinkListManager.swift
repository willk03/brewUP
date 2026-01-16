//
//  DrinkListManager.swift
//  brewUP
//
//  Created by Will Kuster on 1/16/26.
//

class DrinkListManager {
    
    static func listOfTaggedDrinks(drinks: [Drink], includeTags: [String] = [], excludeTags: [String] = []) -> [Drink] {
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
    
    static func sortedByDateCreated( drinks: [Drink]) -> [Drink] {
        return drinks.sorted { $0.dateCreated > $1.dateCreated }
    }
    
    static func sortedByDateChecked( drinks: [Drink]) -> [Drink] {
        return drinks.sorted { $0.dateLastChecked > $1.dateLastChecked }
    }
}
