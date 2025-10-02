//
//  PostsViewModel.swift
//  FavPosts
//
//  Created by Gaurav Patel on 02/10/25.
//

import Foundation
import Combine

@MainActor
final class PostsViewModel: ObservableObject {
    @Published private(set) var posts: [Post] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let network: NetworkServiceProtocol
    private var searchTask: Task<Void, Never>? = nil
    
    @Published private(set) var filteredPosts: [Post] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init(network: NetworkServiceProtocol = NetworkService()) {
        self.network = network
        
        $searchText
            .removeDuplicates()
            .sink { [weak self] newValue in
                self?.debounceSearch(newValue)
            }
            .store(in: &cancellables)
    }
    
    private func debounceSearch(_ text: String) {
        // Cancel previous task
        searchTask?.cancel()
        searchTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 300_000_000) // 300ms debounce
            updateFilteredPosts(text: text)
        }
    }
    
    func updateFilteredPosts(text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !trimmed.isEmpty else {
            filteredPosts = posts
            return
        }
        filteredPosts = posts.filter { $0.title.lowercased().contains(trimmed) }
    }
    
    func loadPosts() async {
        isLoading = true
        errorMessage = nil
        do {
            let fetched = try await network.fetchPosts()
            posts = fetched
            updateFilteredPosts(text: searchText)
        } catch {
            if let ne = error as? NetworkError {
                errorMessage = ne.localizedDescription
            } else {
                errorMessage = error.localizedDescription
            }
        }
        isLoading = false
    }
}

struct MockData {
    static let post1 = Post(userId: 1, id: 1, title: "Sample Post 1", body: "This is the body of post 1.")
    static let post2 = Post(userId: 2, id: 2, title: "Another Post", body: "This is the body of post 2.")
    static let posts = [post1, post2]
}
