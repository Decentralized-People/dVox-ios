//
//  SourceOfTruth.swift
//  dVox
//
//  Created by Aleksandr Molchagin on 8/13/21.
//

import SwiftUI

class SourceOfTruth: ObservableObject {
    
    @Published var allPosts_ = [Post]()
    
    func getPosts(index: Int){
        print("getting... \(index)")
        switch index {
        case 0:
            allPosts_.append(contentsOf: [
                Post(id: 1, title: "Why why why", author: "Aleksandr", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag1", votes: 1),
                
                Post(id: 2, title: "Hello world", author: "Revaz", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag2", votes: 0),
                
                Post(id: 3, title: "Hello there", author: "David", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag3", votes: -10),
                
                Post(id: 4, title: "hello w o r l d", author: "Fatima", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag4", votes: 4),
                
                Post(id: 3, title: "Hello there", author: "David", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag3", votes: -10),
                
                Post(id: 4, title: "hello w o r l d", author: "Fatima", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag4", votes: 4),
                
            ])
        case 1:
            allPosts_.append(contentsOf: [
                Post(id: 1, title: "Why why why", author: "Aleksandr", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag1", votes: 1),
                
                Post(id: 2, title: "Hello world", author: "Revaz", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag2", votes: 0),
                
                Post(id: 3, title: "Hello there", author: "David", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag3", votes: -10),
                
                Post(id: 4, title: "hello w o r l d", author: "Fatima", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag4", votes: 4)
                ,
                
                Post(id: 3, title: "Hello there", author: "David", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag3", votes: -10),
                
                Post(id: 4, title: "hello w o r l d", author: "Fatima", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag4", votes: 4),
            ])
        case 2:
            allPosts_.append(contentsOf: [
                Post(id: 1, title: "Why why why", author: "Aleksandr", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag1", votes: 1),
                
                Post(id: 2, title: "Hello world", author: "Revaz", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag2", votes: 0),
                
                Post(id: 3, title: "Hello there", author: "David", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag3", votes: -10),
                
                Post(id: 4, title: "hello w o r l d", author: "Fatima", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag4", votes: 4),
    
                
                Post(id: 3, title: "Hello there", author: "David", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag3", votes: -10),
                
                Post(id: 4, title: "hello w o r l d", author: "Fatima", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag4", votes: 4),
            ])
        case 4:
            allPosts_.append(contentsOf: [
                Post(id: 1, title: "Why why why", author: "Aleksandr", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag1", votes: 1),
                
                Post(id: 2, title: "Hello world", author: "Revaz", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag2", votes: 0),
                
                Post(id: 3, title: "Hello there", author: "David", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag3", votes: -10),
                
                Post(id: 4, title: "hello w o r l d", author: "Fatima", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag4", votes: 4),
    
                
                Post(id: 3, title: "Hello there", author: "David", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag3", votes: -10),
                
                Post(id: 4, title: "hello w o r l d", author: "Fatima", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag4", votes: 4),
            ])
        case 5:
            allPosts_.append(contentsOf: [
                Post(id: 1, title: "Why why why", author: "Aleksandr", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag1", votes: 1),
                
                Post(id: 2, title: "Hello world", author: "Revaz", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag2", votes: 0),
                
                Post(id: 3, title: "Hello there", author: "David", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag3", votes: -10),
                
                Post(id: 4, title: "hello w o r l d", author: "Fatima", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag4", votes: 4)
            ])
        default:
            return
        }
    }
}
