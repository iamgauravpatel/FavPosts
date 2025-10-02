//
//  FavoritesView.swift
//  FavPosts
//
//  Created by Gaurav Patel on 02/10/25.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(\.modelContext) private var context
    @Query private var favoritePosts: [FavoritePostEntity]
    @EnvironmentObject private var postsVM: PostsViewModel
    @StateObject private var alertStore = FavoritesAlertStore()

    // Build posts ordered by original posts VM order
    private var favoriteIDs: Set<Int> { FavoritesManager.favoriteIDs(from: favoritePosts) }
    private var favorites: [Post] {
        postsVM.posts.filter { favoriteIDs.contains($0.id) }
    }

    var body: some View {
        VStack {
            if postsVM.posts.isEmpty {
                // Ensure posts are loaded (so favorites list has post metadata)
                ProgressView("Loading posts...")
                    .task { await postsVM.loadPosts() }
            }

            List {
                ForEach(favorites) { post in
                    NavigationLink(value: post) {
                        PostRowView(post: post, alertStore: alertStore)
                            .environment(\.modelContext, context)
                    }
                }
                .onDelete { indexSet in
                    // Allow swipe-to-delete from favorites list
                    let idsToRemove = indexSet.compactMap { favorites[$0].id }
                    Task {
                        do {
                            // Remove entities matching those IDs
                            for id in idsToRemove {
                                if let entity = favoritePosts.first(where: { $0.id == id }) {
                                    context.delete(entity)
                                }
                            }
                            try context.save()
                        } catch {
                            print("Failed to remove favorite(s): \(error)")
                        }
                    }
                }
            }
            .listStyle(.plain)
            .overlay {
                if favorites.isEmpty {
                    Text("No favorites yet")
                        .foregroundColor(.secondary)
                        .padding()
                }
            }
        }
        .navigationTitle("Favorites")
    }
}

#Preview {
    FavoritesView()
        .environmentObject(PostsViewModel())
        .modelContainer(for: FavoritePostEntity.self, inMemory: true)
}
