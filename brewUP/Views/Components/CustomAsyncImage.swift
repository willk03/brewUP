//
//  CustomAsyncImage.swift
//  brewUP
//
//  Created by Will Kuster on 1/16/26.
//
import Foundation
import SwiftUI

/// Asynchronously loads and displays a drink’s image.
///
/// Acts like a lightweight replacement for `AsyncImage` but works with
/// a `Drink` model that may source its image from local data, a URL,
/// or bundled assets.
///
/// Image loading is triggered automatically when the view appears.
struct CustomAsyncImage: View {
    @State private var image: UIImage?
    private var drink: Drink
    
    /// Creates an async image view for a given drink.
    ///
    /// - Parameter drink: The drink providing the image source.
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
