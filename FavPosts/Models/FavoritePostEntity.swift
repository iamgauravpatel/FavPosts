//
//  FavoritePostEntity.swift
//  FavPosts
//
//  Created by Gaurav Patel on 02/10/25.
//

import SwiftData
import Foundation

@Model
final class FavoritePostEntity {
    @Attribute(.unique) var id: Int

    init(id: Int) {
        self.id = id
    }
}
