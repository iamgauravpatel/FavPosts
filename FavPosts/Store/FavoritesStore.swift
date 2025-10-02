//
//  FavoritesStore.swift
//  FavPosts
//
//  Created by Gaurav Patel on 02/10/25.
//

import Foundation
import SwiftData
import SwiftUI
import Combine

final class FavoritesStore {
    @Published private(set) var favorites: Set<Int> = []
    
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
        Task { @MainActor in
            loadFavorites()
        }
    }
    
    @MainActor
    private func loadFavorites() {
        do {
            let entities = try context.fetch(FetchDescriptor<FavoritePostEntity>(sortBy: []))
            favorites = Set(entities.map { $0.id })
        } catch {
            print("Failed to load favorites: \(error)")
        }
    }
    
    @MainActor
    func toggle(_ post: Post) {
        if favorites.contains(post.id) {
            remove(post.id)
        } else {
            add(post.id)
        }
    }
    
    @MainActor
    private func add(_ id: Int) {
        let entity = FavoritePostEntity(id: id)
        context.insert(entity)
        do {
            try context.save()
            favorites.insert(id)
        } catch {
            print("Failed to save favorite: \(error)")
        }
    }
    
    @MainActor
    private func remove(_ id: Int) {
        do {
            let entities = try context.fetch(FetchDescriptor<FavoritePostEntity>(sortBy: []))
            if let entity = entities.first(where: { $0.id == id }) {
                context.delete(entity)
                try context.save()
                favorites.remove(id)
            }
        } catch {
            print("Failed to remove favorite: \(error)")
        }
    }
    
    @MainActor
    func contains(_ post: Post) -> Bool {
        favorites.contains(post.id)
    }
}

