//
//  FavPostsApp.swift
//  FavPosts
//
//  Created by Gaurav Patel on 02/10/25.
//

import SwiftUI
import SwiftData

@main
struct FavPostsApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FavoritePostEntity.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @StateObject private var postsVM = PostsViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environmentObject(postsVM)
        .modelContainer(sharedModelContainer)
    }
}
