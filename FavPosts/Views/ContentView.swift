//
//  ContentView.swift
//  FavPosts
//
//  Created by Gaurav Patel on 02/10/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        MainTabView()
    }
}

struct MainTabView: View {
    @EnvironmentObject var postsVM: PostsViewModel
    
    var body: some View {
        TabView {
            NavigationStack {
                PostsListView()
                    .navigationDestination(for: Post.self) { post in
                        PostDetailView(post: post)
                    }
            }
            .tabItem {
                Label("Posts", systemImage: "list.bullet")
            }
            
            NavigationStack {
                FavoritesView()
                    .navigationDestination(for: Post.self) { post in
                        PostDetailView(post: post)
                    }
            }
            .tabItem {
                Label("Favorites", systemImage: "heart.fill")
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(PostsViewModel())
        .modelContainer(for: FavoritePostEntity.self, inMemory: true)
}
