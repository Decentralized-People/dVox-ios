
//
//  Comment.swift
//  Comment
//
//

import Foundation
import SwiftUI


class Comment: Identifiable {
    var id: Int
    var author: String
    var message: String
    var ban: Bool
    
    init(id: Int, author: String, message: String, ban: Bool) {
        self.id = id
        self.author = author
        self.message = message
        self.ban = ban
    }
}
