//
//  drinkUPApp.swift
//  drinkUP
//
//  Created by Will Kuster on 7/16/25.
//
import SwiftUI
import SwiftData

@main
struct drinkUPApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Drink.self)
    }
}


//func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//    // Handle the URL
//    print("Opened with URL: \(url)")
//    
//
//    return true
//}


