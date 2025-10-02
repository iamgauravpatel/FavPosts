//
//  PostRowView.swift
//  FavPosts
//
//  Created by Gaurav Patel on 02/10/25.
//

import SwiftUI
import SwiftData

struct PostRowView: View {
    let post: Post
    @Environment(\.modelContext) private var context
    @Query private var favoritePosts: [FavoritePostEntity]
    @ObservedObject var alertStore: FavoritesAlertStore
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(post.title)
                    .font(.headline)
                    .lineLimit(2)
                Text("User ID: \(post.userId)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button {
                Task {
                    await FavoritesManager.toggleFavorite(post, context: context, favorites: favoritePosts, alertStore: alertStore)
                }
            } label: {
                Image(systemName: FavoritesManager.isFavorite(post, favorites: favoritePosts) ? "heart.fill" : "heart")
                    .imageScale(.large)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 8)
        .alert(isPresented: Binding(
            get: { alertStore.favoriteError != nil },
            set: { isPresented in if !isPresented { alertStore.dismiss() } }
        )) {
            Alert(
                title: Text("Error"),
                message: Text(alertStore.favoriteError ?? ""),
                dismissButton: .default(Text("OK"), action: { alertStore.dismiss() })
            )
        }
    }
}

#Preview {
    PostRowView(post: MockData.post1, alertStore: FavoritesAlertStore())
}
