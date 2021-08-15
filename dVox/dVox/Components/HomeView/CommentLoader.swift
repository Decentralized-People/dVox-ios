//
//  CommentLoader.swift
//  dVox
////

import SwiftUI

class CommentLoader: ObservableObject  {
    
    
    
    @Published var allComments_ = [Comment]()
    
    func getComments(index: Int, apis: APIs, postId: Int, currentId: Int, getComments: Int){
        print("Getting new comments, cycle \(index)")
        loadMore(apis: apis, postId: postId, numberOfComments: getComments, currentId: currentId)
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - apis: <#apis description#>
    ///   - postNumber: <#postNumber description#>
    func loadMore(apis: APIs, postId: Int, numberOfComments: Int, currentId: Int) {
        
        print("Loading more posts...")
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            
            let add = apis.retriveKey(for: "ContractAddress") ?? "error"
            let inf = apis.retriveKey(for: "InfuraURL") ?? "error"
            let cre = apis.retriveKey(for: "Credentials") ?? "error"
            
            if (add != "error" && inf != "error" && cre != "error") {
                
                let contract = SmartContract(credentials: cre, infura: inf, address: add)
                
                /// Get data at a background thread
                DispatchQueue.global(qos: .userInitiated).async {
                    
                    if (postId >= 1){
                    
                        var commentCount = 0;
                        if currentId == -1 {
                            commentCount =  contract.getPost(id: contract.getPostCount()).commentsNumber
                        } else {
                            commentCount = currentId - 2
                        }
                        if commentCount > 0 {
                            for i in stride(from: commentCount, to: commentCount - numberOfComments, by: -1) {
                                if i > 0 {
                                   
                                    let Comment = contract.getComment(postId: postId, commentId: i)
                                    
                                    /// Update UI at the main thread
                                    DispatchQueue.main.async {
                                        
                                        print(Comment.id)
                                        self.allComments_.append(Comment)
                                        
                                    }
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

