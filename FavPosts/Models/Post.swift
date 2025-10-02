//
//  Post.swift
//  FavPosts
//
//  Created by Gaurav Patel on 02/10/25.
//

import Foundation

struct Post: Identifiable, Codable, Equatable, Hashable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

