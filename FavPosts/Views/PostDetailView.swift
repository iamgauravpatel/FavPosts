//
//  PostDetailView.swift
//  FavPosts
//
//  Created by Gaurav Patel on 02/10/25.
//

import SwiftUI
import SwiftData

struct PostDetailView: View {
    let post: Post
    @Environment(\.modelContext) private var context
    @Query private var favoritePosts: [FavoritePostEntity]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(post.title)
                            .font(.title)
                            .bold()
                        Text("User ID: \(post.userId)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Button {
                        Task {
                            await FavoritesManager.toggleFavorite(post, context: context, favorites: favoritePosts)
                        }
                    } label: {
                        Image(systemName: FavoritesManager.isFavorite(post, favorites: favoritePosts) ? "heart.fill" : "heart")
                            .imageScale(.large)
                    }
                    .buttonStyle(.plain)
                }
                
                Text(post.body)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    PostDetailView(post: MockData.post1)
        .environmentObject(PostsViewModel())
}
