//
//  PostsListView.swift
//  FavPosts
//
//  Created by Gaurav Patel on 02/10/25.
//

import SwiftUI
import SwiftData

struct PostsListView: View {
    @EnvironmentObject var postsVM: PostsViewModel
    @Environment(\.modelContext) private var context
    @Query private var favoritePosts: [FavoritePostEntity]
    @StateObject private var alertStore = FavoritesAlertStore()
    
    var body: some View {
        VStack {
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search by title...", text: $postsVM.searchText)
                    .textFieldStyle(.roundedBorder)
            }
            .padding([.horizontal, .top])
            
            // Content
            Group {
                if postsVM.isLoading && postsVM.posts.isEmpty {
                    ProgressView("Loading posts...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = postsVM.errorMessage {
                    VStack(spacing: 12) {
                        Text("Error: \(error)")
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            Task { await postsVM.loadPosts() }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(postsVM.filteredPosts) { post in
                        NavigationLink(value: post) {
                            PostRowView(post: post, alertStore: alertStore)
                                .environment(\.modelContext, context)
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        // Prevent multiple refreshes
                        await postsVM.loadPosts()
                        postsVM.updateFilteredPosts(text: postsVM.searchText)
                    }
                }
            }
            .animation(.default, value: postsVM.filteredPosts)
        }
        .navigationTitle("Posts")
        .task {
            if postsVM.posts.isEmpty {
                await postsVM.loadPosts()
            }
        }
    }
}

#Preview {
    PostsListView()
        .environmentObject(PostsViewModel())
        .modelContainer(for: FavoritePostEntity.self, inMemory: true)
}
