//
//  SourceOfTruth.swift
//  dVox
//
//  Created by Aleksandr Molchagin on 8/13/21.
//

import SwiftUI

class SourceOfTruth: ObservableObject {
    
    @Published var allPosts_ = [Post]()
    
    func getPosts(index: Int, apis: APIs){
        print("getting... \(index)")
        loadMore(apis: apis, postNumber: 6)
    }
    
    func loadMore(apis: APIs, postNumber: Int) {
  
        print("This is run on a background queue")

        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { timer in
    
            let add = apis.retriveKey(for: "ContractAddress") ?? "error"
            let inf = apis.retriveKey(for: "InfuraURL") ?? "error"
            let cre = apis.retriveKey(for: "Credentials") ?? "error"

            if (add != "error" && inf != "error" && cre != "error") {
                
                 let contract = SmartContract(credentials: cre, infura: inf, address: add)
                
                 DispatchQueue.global(qos: .userInitiated).async {
                     let postCount = contract.getPostCount()
                     for i in stride(from: postCount, to: postCount - postNumber, by: -1) {
                         var Post = Post(id: -1, title: "", author: "", message: "", hastag: "", votes: -999)
                         Post = contract.getPost(id: i)
                 DispatchQueue.main.async {
                      self.allPosts_.append(Post)
                    }
                 }
                 timer.invalidate()
                 }
            }
        }
    }
}

