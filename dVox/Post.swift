
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
    var hashtag: String
    var upVotes: Int
    var downVotes: Int
    var commentsNumber: Int
    var ban: Bool
    
    init(id: Int, title: String, author: String, message: String, hastag: String, upVotes: Int, downVotes: Int, commentsNumber: Int, ban: Bool) {
        self.id = id
        self.title = title
        self.author = author
        self.message = message
        self.hashtag = hastag
        self.upVotes = upVotes
        self.downVotes = downVotes
        self.commentsNumber = commentsNumber
        self.ban = ban
    }
}
