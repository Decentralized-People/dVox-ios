//
//  Post.swift
//  Post
//
//  Created by Revaz Bakuradze on 27.07.21.
//

import Foundation
import SwiftUI

class Post {
    var id: Int
    var title: String
    var author: String
    var message: String
    var hastag: String
    var votes: Int
    var ban: Bool
    
    init(title: String, author: String, message: String, hastag: String) {
        //Get Post Count from Smart Contract and increment 1 to that number for the new post ID
        self.id = 123;
        self.title = title
        self.author = author
        self.message = message
        self.hastag = hastag
        self.votes = 0
        self.ban = false
    }
}

