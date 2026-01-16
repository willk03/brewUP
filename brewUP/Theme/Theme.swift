//
//  Theme.swift
//  brewUP
//
//  Created by Will Kuster on 1/16/26.
//
import SwiftUI

struct Theme {
    // MARK: - Colors
    struct Colors {
        // Primary colors
        static let primary = Color("Espresso")
        static let secondary = Color("Button")
        static let background = Color("Background")
        
        // Semantic colors (describe purpose, not color)
        static let textPrimary = Color.primary
        static let textSecondary = Color.secondary
        static let destructive = Color.red
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let small: CGFloat = 5
        static let medium: CGFloat = 10
        static let large: CGFloat = 20
        static let extraLarge: CGFloat = 30
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let small: CGFloat = 4
        static let medium: CGFloat = 10
        static let large: CGFloat = 20
    }
    
    // MARK: - Shadows
    struct Shadows {
        static let cardShadow = (color: Color.black.opacity(0.15), radius: CGFloat(4))
    }
}
