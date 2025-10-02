//
//  Item.swift
//  FavPosts
//
//  Created by Gaurav Patel on 02/10/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
