//
//  CommentLoader.swift
//  dVox
////

import SwiftUI

class CommentLoader: ObservableObject  {
    
    @Published var allComments = [Comment]()
    
    @Published var tempComments = [Comment]()
    
    @Published var noMoreComments = false
    
    @Published var contract: SmartContract
    
    init(_contract: SmartContract){
        contract = _contract
    }

    func addComment(comment: Comment){
        withAnimation(Animation.linear){
            self.allComments.append(comment)
        }
    }
        
    func getComments(index: Int, apis: APIs, post: Post, currentId: Int, getComments: Int){
        print("Getting new comments, cycle \(index)")
        loadMore(post: post, numberOfComments: getComments, currentId: currentId)
    }

    func loadMore(post: Post, numberOfComments: Int, currentId: Int) {
    
        
        print("Loading more posts...")

        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [self] timer in


            if (self.contract.loaded == true) {
                timer.invalidate()

                /// Get data at a background thread
                DispatchQueue.global(qos: .userInitiated).async {

                    if (post.id >= 1){

                        var commentCount = 0;
                        if currentId == -1 {
                            commentCount =  self.contract.getPost(id: post.id).commentsNumber
                        } else {
                            commentCount = currentId - 2
                        }
                        if commentCount > 0 {
                            for i in stride(from: commentCount, to: commentCount - numberOfComments, by: -1) {
                                if i > 0 {

                                    let Comment = self.contract.getComment(postId: post.id, commentId: i)

                                    DispatchQueue.main.async { [self] in

                                        print(Comment.id)

                                        if (Comment.ban != true){
                                            self.tempComments.append(Comment)
                                        }

                                        if (Comment.id == 1){
                                            noMoreComments = true
                                        }

                                    }
                                }
                            }
                            /// Update UI at the main thread
                            DispatchQueue.main.async {


                                withAnimation(Animation.linear){

                                    self.allComments.append(contentsOf: self.tempComments.reversed())

                                    self.tempComments = []

                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
