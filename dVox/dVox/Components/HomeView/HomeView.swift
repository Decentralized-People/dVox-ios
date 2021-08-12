//
//  HomeView.swift
//  HomeView
//
//  Created by Revaz Bakuradze on 03.08.21.
//

import Foundation
import SwiftUI

//let numberOfPostss = contract.getPostCount()


struct HomeView: View {
    
    var apis: APIs
    
    @State var allPosts = [
        Post(id: 1, title: "Why why why", author: "Aleksandr", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag1", votes: 1),
        
        Post(id: 2, title: "Hello world", author: "Revaz", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag2", votes: 0),
        
        Post(id: 3, title: "Hello there", author: "David", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag3", votes: -10),
        
        Post(id: 4, title: "hello w o r l d", author: "Fatima", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag4", votes: 4)
    ]
    
    init(_apis: APIs){
        apis = _apis
        que()
    }
    
    var body: some View {
        
            ZStack {
                Color("BlackColor")
                    .ignoresSafeArea()
                PostList(posts: allPosts)

    }
 }
    func que() {
         Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { timer in
            let add = apis.retriveKey(for: "ContractAddress") ?? "error"
            let inf = apis.retriveKey(for: "InfuraURL") ?? "error"
            let cre = apis.retriveKey(for: "Credentials") ?? "error"
             
             if (add != "error" && inf != "error" && cre != "error") {
                 let contract = SmartContract(credentials: cre, infura: inf, address: add)
                 
                 let postCount = contract.getPostCount()
                 
                 for i in stride(from: postCount, to: postCount - 5, by: -1) {
                     let Post = contract.getPost(id: i)
                     allPosts.append(Post)
                     print("Post \(i)")
                 }
                
                 timer.invalidate()
             }
         }
    }
}
