//
//  PostLoader.swift
//  dVox
//
//  Created by Aleksandr Molchagin on 8/13/21.
//

import SwiftUI

class PostLoader: ObservableObject  {
        
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest( entity: Item.entity(),sortDescriptors: [NSSortDescriptor(keyPath: \Item.postId, ascending: true)])
    var items: FetchedResults<Item>
    
    
    @Published var savedPosts = [Post(id: 3, title: "eee", author: "text", message: "test", hastag: "ddddd", upVotes: 1, downVotes: 2, commentsNumber: 4, ban: false)]

    @Published var allPosts = [Post]()
    
    init(){
        savedPosts = getFromSavedPosts()
    }
    
    func getPosts(index: Int, apis: APIs, currentId: Int, getPosts: Int){
        print("getting NEW POSTS \(index)")
        savePost(post: Post(id: 3, title: "eee", author: "text", message: "test", hastag: "ddddd", upVotes: 1, downVotes: 2, commentsNumber: 4, ban: false))
        loadMore(apis: apis, numberOfPosts: getPosts, currentId: currentId)
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - apis: <#apis description#>
    ///   - postNumber: <#postNumber description#>
    func loadMore(apis: APIs, numberOfPosts: Int, currentId: Int) {
        
        self.allPosts.append(contentsOf: savedPosts)
        print(savedPosts)

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
                                var Post = Post(id: -1, title: "", author: "", message: "", hastag: "", upVotes: 0, downVotes: 0, commentsNumber: 0, ban: false)
                                Post = contract.getPost(id: i)
                                print("Post: \(Post.id): \(Post.title)")

                                /// Update UI at the main thread
                                DispatchQueue.main.async {
                                    
                                    print("Post: \(Post.id): \(Post.title)")
                                        
                                    self.savePost(post: Post)
                                                              
                                    self.allPosts.append(Post)
                                    
                                }
                            }
                        }
                    }
                }
                timer.invalidate()
            }
        }
    }
    
    func savePost(post: Post){
        
        let item = Item(context: managedObjectContext)
        
        item.postId = Int64(post.id)
        item.author = post.author
        item.title = post.title
        item.message = post.message
        item.hashtag = post.hashtag
        item.upVotes = Int64(post.upVotes)
        item.downVotes = Int64(post.downVotes)
        item.commentsNumber = Int64(post.commentsNumber)
        item.ban = post.ban
        
        print("Saving..........")
        PersistenceController.shared.save()
        
    }
    
    func getFromSavedPosts() -> [Post]{
        var postArray = [Post]()
        print("trying to get a post...")
        Array(items).forEach { item in
            let post = Post(id: Int(item.postId), title: item.title ?? "No title provided", author: item.author ?? "No author provided", message: item.message ?? "No message provided", hastag: item.hashtag ?? "No hashtag provided", upVotes: Int(item.upVotes), downVotes: Int(item.downVotes), commentsNumber: Int(item.commentsNumber), ban: item.ban)
            postArray.append(post)
            print("hm.. \(item.title)")

        }
        return postArray
    }
}

