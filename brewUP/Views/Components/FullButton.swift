//
//  FullButton.swift
//  brewUP
//
//  Created by Will Kuster on 1/16/26.
//
import Foundation
import SwiftUI

/**
 * A full-width customizable button component.
 *
 * Displays optional text and an SF Symbol icon, styled using the app
 * theme. Intended for primary actions throughout the app.
 */
struct FullButton: View {
    let buttonText: String
    let buttonColor: Color?
    let textColor: Color?
    let icon: String?
    let action: () -> Void
    
    /**
     * Creates a full-width button with optional styling.
     *
     * - Parameters:
     *   - buttonText: Text displayed on the button.
     *   - buttonColor: Background color of the button.
     *   - textColor: Color of the text and icon.
     *   - icon: Optional SF Symbol name.
     *   - action: Closure executed when the button is tapped.
     */
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
                .cornerRadius(Theme.CornerRadius.large)
                .shadow(
                    color: Theme.Shadows.cardShadow.color,
                    radius: Theme.Shadows.cardShadow.radius
                )

            }
        }
    }
}
