//
//  CommentLoader.swift
//  dVox
////

import SwiftUI

class CommentLoader: ObservableObject  {
    
    @Published var allComments = [Comment]()
    
    @Published var tempComments = [Comment]()
        
    func getComments(index: Int, apis: APIs, post: Post, currentId: Int, getComments: Int){
        print("Getting new comments, cycle \(index)")
        loadMore(apis: apis, post: post, numberOfComments: getComments, currentId: currentId)
    }

    func loadMore(apis: APIs, post: Post, numberOfComments: Int, currentId: Int) {
        
        print("Loading more posts...")
        
        Timer.scheduledTimer(withTimeInterval: 0, repeats: true) { timer in
            
            let add = apis.retriveKey(for: "ContractAddress") ?? "error"
            let inf = apis.retriveKey(for: "InfuraURL") ?? "error"
            let cre = apis.retriveKey(for: "Credentials") ?? "error"
            
            if (add != "error" && inf != "error" && cre != "error") {
                
                let contract = SmartContract(credentials: cre, infura: inf, address: add)
                
                /// Get data at a background thread
                DispatchQueue.global(qos: .userInitiated).async {
                    
                    if (post.id >= 1){
                    
                        var commentCount = 0;
                        if currentId == -1 {
                            commentCount =  post.commentsNumber
                        } else {
                            commentCount = currentId - 2
                        }
                        if commentCount > 0 {
                            for i in stride(from: commentCount, to: commentCount - numberOfComments, by: -1) {
                                if i > 0 {
                                   
                                    let Comment = contract.getComment(postId: post.id, commentId: i)
                                    
                                    DispatchQueue.main.async { [self] in
                                        
                                        print(Comment.id)
                                        
                                        self.tempComments.append(Comment)
                                        
                                    }
                                }
                            }
                            /// Update UI at the main thread
                            DispatchQueue.main.async {
                                                            
                                self.allComments.append(contentsOf: self.tempComments.reversed())
                
                                self.tempComments = []
                            }
                        }
                    }
                }
                timer.invalidate()
            }
        }
    }
}

