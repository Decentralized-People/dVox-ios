//
//  PostLoader.swift
//  dVox
//
//  Created by Aleksandr Molchagin on 8/13/21.
//

import SwiftUI

class PostLoader2: ObservableObject  {
    
    
    @Published var items: [Item] = [Item]()
    
    @Published var posts = [Post]()
    
    @Published var countOfPosts = 1
    
    @Published var noMorePosts = false
    
    let codeDM: PersistenceController = PersistenceController()
    
    let apis = APIs()
    
    @Published var votesDictionary: VotesContainer = VotesContainer()
    
    
    init(){
        apis.resetAPIs()
        apis.getAPIs()
        getPosts(index: 0, currentId: -1, getPosts: 6)
        print("Inited")
    }
    
    func getPosts(index: Int, currentId: Int, getPosts: Int){
        if (index == 0){
            codeDM.deleteAllItems()
        }
        print("WAVE \(index). Getting posts...")
        
        loadMore(numberOfPosts: getPosts, currentId: currentId)
    }
    

    func loadMore(numberOfPosts: Int, currentId: Int) {


        
        print("Loading...")
    
        Timer.scheduledTimer(withTimeInterval: 0, repeats: true) { [self] timer in
            
            let add = apis.retriveKey(for: "ContractAddress") ?? "error"
            let inf = apis.retriveKey(for: "InfuraURL") ?? "error"
            let cre = apis.retriveKey(for: "Credentials") ?? "error"
            
            if (add != "error" && inf != "error" && cre != "error") {
                
                var localCountOfPosts = 0;
                                
                /// Get data at a background thread
                DispatchQueue.global(qos: .userInitiated).async { [self] in
                    
                    let start = clock();
                    //main body of the function taking up time
                    
                    let contract = SmartContract(credentials: cre, infura: inf, address: add)


                    
                    let end = clock();

                    //add this at the bottom and keep accumulating time spent across all calls
                    let time_consumed = (Int32)(end - start) / CLOCKS_PER_SEC;
                    
                    print("TIME CONSUMED: \(time_consumed)")
                    
                    localCountOfPosts = contract.getPostCount()

                    
                    var postCount = 0;
                    if currentId == -1 {
                        postCount = localCountOfPosts
                    } else {
                        postCount = currentId - 1
                    }
                    if postCount > 0 {
                        for i in stride(from: postCount, to: postCount - numberOfPosts, by: -1) {
                            if i > 0 {
                                var Post = Post(id: -1, title: "", author: "", message: "", hastag: "", upVotes: 0, downVotes: 0, commentsNumber: 0, ban: false)
                                Post = contract.getPost(id: i)
                                
                                DispatchQueue.main.async {
                                    
                                    countOfPosts = localCountOfPosts
                                    
                                    if (votesDictionary.getVote(postId: Post.id) == "1"){
                                        Post.upVotes =  Post.upVotes - 1
                                    } else if (votesDictionary.getVote(postId: Post.id) == "-1"){
                                        Post.downVotes =  Post.downVotes - 1
                                    }
                                    
                                    if (Post.ban != true){
                                        print("Post \(Post.id): \(Post.title)")
                                        posts.append(Post)
                                    }
                                    
                                    if (Post.id == 1){
                                        noMorePosts = true
                                    }
                                    
                                }
                            }
                        }
                        /// Update UI at the main thread
                        DispatchQueue.main.async {
                            
                            withAnimation(Animation.linear){

                                codeDM.savePosts(posts: posts)
                                
                                items = codeDM.getallItems().sorted(by: { item1, item2 in
                                    return item1.postId > item2.postId
                                })
                                
                                posts = []
                                
                           
                            }
                        }
                    }
                }
                timer.invalidate()
            }
        }
        
    }
}

