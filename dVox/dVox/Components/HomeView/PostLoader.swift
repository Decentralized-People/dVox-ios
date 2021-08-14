//
//  PostLoader.swift
//  dVox
//
//  Created by Aleksandr Molchagin on 8/13/21.
//

import SwiftUI

class PostLoader: ObservableObject  {
    
    @Published var allPosts_ = [Post]()
    
    func getPosts(index: Int, apis: APIs, currentId: Int, getPosts: Int){
        print("getting NEW POSTS \(index)")
        loadMore(apis: apis, numberOfPosts: getPosts, currentId: currentId)
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - apis: <#apis description#>
    ///   - postNumber: <#postNumber description#>
    func loadMore(apis: APIs, numberOfPosts: Int, currentId: Int) {
  
        print("Loading more posts...")

        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
    
            let add = apis.retriveKey(for: "ContractAddress") ?? "error"
            let inf = apis.retriveKey(for: "InfuraURL") ?? "error"
            let cre = apis.retriveKey(for: "Credentials") ?? "error"

            if (add != "error" && inf != "error" && cre != "error") {
                
                 let contract = SmartContract(credentials: cre, infura: inf, address: add)
                
                 /// Get data at a background thread
                 DispatchQueue.global(qos: .userInitiated).async {
                     var postCount = 0;
                     if currentId == -1 {
                         postCount = contract.getPostCount()
                     } else {
                         postCount = currentId - 2
                     }
                     if postCount > 0 {
                         for i in stride(from: postCount, to: postCount - numberOfPosts, by: -1) {
                             if i > 0 {
                                 var Post = Post(id: -1, title: "", author: "", message: "", hastag: "", votes: -999)
                                 Post = contract.getPost(id: i)
                                
                                 /// Update UI at the main thread
                                 DispatchQueue.main.async {
                                     
                                     print(Post.id)
                                     self.allPosts_.append(Post)
                                     
                                    }
                             }
                         }
                     }
                 }
                timer.invalidate()
            }
        }
    }
}

