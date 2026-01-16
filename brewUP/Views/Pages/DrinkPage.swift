//
//  DrinkPage.swift
//  brewUP
//
//  Created by Will Kuster on 1/16/26.
//
import SwiftUI
import Foundation
import PhotosUI
import SwiftData

/**
 * Detail page for viewing and editing a single drink.
 *
 * Displays the drink image, metadata, ingredients, equipment,
 * and instructions. Supports edit mode, image selection,
 * deep linking, favoriting, and deletion.
 */
struct DrinkPage: View {
    let drink: Drink
    @State private var selectedImage: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var showPicker = false
    @State private var isEditing: Bool = false
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteAlert = false
    
    // MARK: - Initializer

    /**
     * Creates a drink detail page.
     *
     * - Parameters:
     *   - drink: The drink to display.
     *   - isEditing: Initial editing state.
     */
    init(drink: Drink, isEditing: Bool = false) {
        self.drink = drink
        self.isEditing = isEditing
    }


    // MARK: - View Body

    var body: some View {
        ZStack {

            // MARK: Image Header

            VStack {
                if drink.hasImage() {
                    CustomAsyncImage(drink: drink)
                        .frame(
                            width: UIScreen.main.bounds.width,
                            height: 300
                        )
                        .clipped()
                        .mask(
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: .clear, location: 0.0),
                                    .init(color: .black, location: 0.8),
                                    .init(color: .black, location: 1.0)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .padding(.top, 60)
                        .id(selectedImage)
                        .overlay(
                            isEditing
                            ? VStack {
                                Image(systemName: "photo")
                                    .font(.title)
                                    .foregroundColor(.gray)
                                Text("Tap to select")
                                    .foregroundColor(.gray)
                              }
                            .padding(.top, 50)
                            : nil
                        )
                } else {
                    Rectangle()
                        .fill(.gray)
                        .frame(height: 300)
                        .mask(
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: .clear, location: 0.0),
                                    .init(color: .black, location: 0.8),
                                    .init(color: .black, location: 1.0)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .padding(.top, 60)
                        .overlay(
                            isEditing
                            ? VStack {
                                Image(systemName: "photo")
                                    .font(.title)
                                    .foregroundColor(.gray)
                                Text("Tap to select")
                                    .foregroundColor(.gray)
                              }
                            .padding(.top, 50)
                            : nil
                        )
                }

                Spacer()
            }


            // MARK: Scrollable Content Layer

            ScrollView {
                ZStack {

                    // MARK: Image Picker Overlay (Editing Only)

                    VStack {
                        if isEditing {
                            PhotosPicker(
                                selection: $photosPickerItem,
                                matching: .images
                            ) {
                                Rectangle()
                                    .opacity(0)
                                    .frame(height: 330)
                            }
                            .onChange(of: photosPickerItem) { _, newValue in
                                Task {
                                    if let data = try? await newValue?.loadTransferable(type: Data.self) {
                                        selectedImage = UIImage(data: data)
                                        drink.setImage(selectedImage)
                                    }
                                }
                            }
                        } else {
                            Rectangle()
                                .opacity(0)
                                .frame(height: 330)
                        }

                        // MARK: Background Panel

                        RoundedRectangle(cornerRadius: Theme.CornerRadius.large)
                            .fill(Theme.Colors.secondary)
                            .frame(
                                width: UIScreen.main.bounds.width,
                                height: 800
                            )
                        Spacer()
                    }

                    // MARK: Drink Content

                    VStack {
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.small)
                            .fill(Color.secondary)
                            .frame(
                                width: UIScreen.main.bounds.width / 3,
                                height: 6
                            )
                            .padding(.top, 15)
                            .padding(.bottom, -21)

                        DrinkPageContent(
                            drink: drink,
                            isEditing: isEditing
                        )

                        Spacer()
                    }
                    .padding(.top, 330)
                }
            }
        }

        // MARK: Page Styling

        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.Colors.background)
        .ignoresSafeArea()
        .navigationTitle(drink.name)


        // MARK: Toolbar Actions

        .toolbar {

            // Share / Deep Link
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    print(
                        DeepLinkBuilder
                            .createDeepLink(
                                action: "drink",
                                data: drink.getDictonary()
                            )?
                            .absoluteString
                        ?? "Failed to create link"
                    )
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(Theme.Colors.primary)
                }
            }

            // Delete (Editing Only)
            if isEditing {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showDeleteAlert = true
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(Theme.Colors.destructive)
                    }
                }
            }

            // Toggle Edit Mode
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { isEditing.toggle() }) {
                    Image(systemName: "pencil")
                        .foregroundColor(Theme.Colors.primary)
                        .padding(.trailing, -10)
                }
            }

            // Favorite Toggle
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { drink.toggleFavorite() }) {
                    Image(systemName: drink.containsTag("Favorite")
                        ? "heart.fill"
                        : "heart")
                        .foregroundColor(Theme.Colors.primary)
                }
            }
        }


        // MARK: Delete Confirmation

        .alert("Delete Drink", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                modelContext.delete(drink)
                try? modelContext.save()
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete \(drink.name)? This cannot be undone.")
        }


        // MARK: Lifecycle

        .onAppear {
            drink.dateLastChecked = Date()
        }
    }
}
