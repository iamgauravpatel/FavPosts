//
//  FavoritesManager.swift
//  FavPosts
//
//  Created by Gaurav Patel on 02/10/25.
//

import Foundation
import SwiftData

struct FavoritesManager {
    static func isFavorite(_ post: Post, favorites: [FavoritePostEntity]) -> Bool {
        favorites.contains(where: { $0.id == post.id })
    }
    
    static func toggleFavorite(_ post: Post,
                               context: ModelContext,
                               favorites: [FavoritePostEntity],
                               alertStore: FavoritesAlertStore? = nil) async {
        do {
            if let entity = favorites.first(where: { $0.id == post.id }) {
                context.delete(entity)
            } else {
                context.insert(FavoritePostEntity(id: post.id))
            }
            try context.save()
        } catch {
            print("Failed to toggle favorite: \(error)")
            await MainActor.run {
                alertStore?.showError("Failed to save favorite: \(error.localizedDescription)")
            }
        }
    }
    
    static func favoriteIDs(from favorites: [FavoritePostEntity]) -> Set<Int> {
        Set(favorites.map(\.id))
    }
}
