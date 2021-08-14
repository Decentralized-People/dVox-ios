
//
//  Post.swift
//  Post
//
//  Created by Revaz Bakuradze on 27.07.21.
//

import Foundation
import SwiftUI


class Post: Identifiable {
    var id: Int
    var title: String
    var author: String
    var message: String
    var hastag: String
    var upVotes: Int
    var downVotes: Int
    var commentsNumber: Int
    var ban: Bool
    
    init(id: Int, title: String, author: String, message: String, hastag: String, votes: Int) {
        self.id = id
        self.title = title
        self.author = author
        self.message = message
        self.hastag = hastag
        self.upVotes = 0
        self.downVotes = 0
        self.commentsNumber = 0
        self.ban = false
    }
}
