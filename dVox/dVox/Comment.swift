
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
    
    init(id: Int, author: String, message: String) {
        self.id = id
        self.author = author
        self.message = messggage
    }
}
