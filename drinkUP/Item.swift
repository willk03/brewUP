//
//  Item.swift
//  drinkUP
//
//  Created by Will Kuster on 7/16/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
