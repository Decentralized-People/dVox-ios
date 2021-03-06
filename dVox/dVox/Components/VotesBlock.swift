//
//  LikeButton.swift
//  LikeButton
//
//  Created by Fatima Ortega on 8/17/21.
//

import Foundation
import SwiftUI
import Firebase

struct Preview : View {
    
    var body : some View {
        VotesBlock(_post: Post(id: 2, title: "It's time for physics!", author: "@Crazy_snake_95", message: " Aliqua in laboris commodo nisi aute tempor dolor nulla. Laboris deserunt deserunt occaecat cupidatat.Adipisicing do velit cillum fugiat nostrud et veniam laboris laboris velit ut dolor ad.", hastag: "#letsgopeople", upVotes: 3, downVotes: 2, commentsNumber: 5, ban: false), _apis: APIs(), _voted: "", _votesContainer: VotesContainer())
    }
}

struct VotesBlock : View {
    @State var post: Post
    @State var apis: APIs
    @State var votesDictionary: VotesContainer

    @State var isUpVoted: Bool
    @State var isDownVoted: Bool
    
    @State var scaleUp : CGFloat = 1
    @State var opacityUp = 0.0
    
    @State var scaleDown : CGFloat = 1
    @State var opacityDown = 0.0
    
    @State var upVote: Int
    @State var downVote: Int
    
    @State var voteUp: Int = 0;
    @State var voteDown: Int = 0;
    
    init(_post: Post, _apis: APIs, _voted: String, _votesContainer: VotesContainer) {
        post = _post
        apis = _apis
        votesDictionary = _votesContainer
        if ( _voted == "-1"){
            isUpVoted = false
            isDownVoted = true
            downVote = 1
            upVote = 0
        } else if ( _voted == "1"){
            isUpVoted = true
            isDownVoted = false
            upVote = 1
            downVote = 0
        } else {
            isUpVoted = false
            isDownVoted = false
            downVote = 0
            upVote = 0
            
            
        }
    }

    var body: some View {
        HStack{
            ZStack {
                Image("fi-rr-thumbs-up.filled")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                    .padding([.leading], 0)
                    .opacity(isUpVoted ? 0.75 : 0)
                    .animation(.linear)
                
                Image("fi-rr-thumbs-up")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                    .padding([.leading], 0)
                
                CirclesView(isLiked: isUpVoted, radius: 15, speed: 0.1, scale: 0.3)
                    .opacity(self.opacityUp)
                
                CirclesView(isLiked: isUpVoted, radius: 20, speed: 0.3, scale: 0.3)
                    .opacity(self.opacityUp)
                    .rotationEffect(Angle(degrees: 20))
            }.onTapGesture {
                if (self.downVote != 1){
                    if (self.upVote == 0){
                        self.upVote = 1
                        self.voteUp(vote: 1)
                    } else {
                        self.upVote = 0
                        self.voteUp(vote: -1)
                    }
                    self.isUpVoted.toggle()
                    withAnimation (.linear(duration: 0.2)) {
                        self.opacityUp = self.opacityUp == 0 ? 1 : 0
                    }
                    withAnimation {
                        self.opacityUp = self.opacityUp == 0 ? 1 : 0
                    }
                }
            }
            .scaleEffect(self.scaleUp)
            .frame(alignment: .leading)
            .padding([.leading, .bottom], 20)
            
            Text(String(voteUp))
                .font(.custom("Montserrat-Bold", size: 14))
                .frame( alignment: .leading)
                .padding([.bottom ], 20)
                .onAppear(perform: {
                    getVoteUp()
                })
            
            ZStack {
                Image("fi-rr-thumbs-down.filled")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                    .padding([.leading], 0)
                    .opacity(isDownVoted ? 0.75 : 0)
                    .animation(.linear)
                
                Image("fi-rr-thumbs-down")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                    .padding([.leading], 0)
                
                CirclesView(isLiked: isDownVoted, radius: 15, speed: 0.1, scale: 0.3)
                    .opacity(self.opacityDown)
                
                CirclesView(isLiked: isDownVoted, radius: 20, speed: 0.3, scale: 0.3)
                    .opacity(self.opacityDown)
                    .rotationEffect(Angle(degrees: 20))
            }.onTapGesture {
                if (self.upVote != 1){
                    if (self.downVote == 0){
                        self.downVote = 1
                        self.voteDown(vote: 1)
                    } else {
                        self.downVote = 0
                        self.voteDown(vote: -1)
                    }
                    self.isDownVoted.toggle()
                    withAnimation (.linear(duration: 0.2)) {
                        self.opacityDown = self.opacityDown == 0 ? 1 : 0
                    }
                    withAnimation {
                        self.opacityDown = self.opacityDown == 0 ? 1 : 0
                    }
                }
            }
            .scaleEffect(self.scaleDown)
            .frame(alignment: .leading)
            .padding([.bottom ], 20)
            
            Text(String(voteDown))
                .font(.custom("Montserrat-Bold", size: 14))
                .frame( alignment: .leading)
                .padding([.bottom ], 20)
                .onAppear(perform: {
                    getVoteDown()
                })
         
        }
        
    }
    
    func voteUp(vote: Int) {
    
        if (vote == 1){
            votesDictionary.addVote(postId: post.id, vote: 1)
            
            // Increament upvote posts variable for statistics
            let currentNumber = UserDefaults.standard.integer(forKey: "dVoxUpVotedPosts")
            UserDefaults.standard.set((currentNumber + 1), forKey: "dVoxUpVotedPosts")
            
        } else if (vote == -1){
            votesDictionary.addVote(postId: post.id, vote: 404)
            
            // Decrement upvote posts variable for statistics
            let currentNumber = UserDefaults.standard.integer(forKey: "dVoxUpVotedPosts")
            UserDefaults.standard.set((currentNumber - 1), forKey: "dVoxUpVotedPosts")
            
        }
        
        Timer.scheduledTimer(withTimeInterval: 0, repeats: true) { [self] timer in
            
            let add = apis.retriveKey(for: "ContractAddress") ?? "error"
            let inf = apis.retriveKey(for: "InfuraURL") ?? "error"
            let cre = apis.retriveKey(for: "Credentials") ?? "error"
            
            if (add != "error" && inf != "error" && cre != "error") {
                  
                /// Get data at a background thread
                DispatchQueue.global(qos: .userInitiated).async { [] in

                        let ref = Firestore.firestore().collection("Votes").document(add)

                        ref.updateData([
                            "\(post.id)_upvote": FieldValue.increment(Int64(vote))
                        ])
                    
                }
                /// Update UI at the main thread
                DispatchQueue.main.async {
                                    
                    getVoteUp()
                    
                    timer.invalidate()
                }
            }
        }
    }
    
    func voteDown(vote: Int) {
        
        if (vote == 1){
            votesDictionary.addVote(postId: post.id, vote: -1)
            
            // Increment downvote posts variable for statistics
            let currentNumber = UserDefaults.standard.integer(forKey: "dVoxDownVotedPosts")
            UserDefaults.standard.set((currentNumber + 1), forKey: "dVoxDownVotedPosts")
            
        } else if (vote == -1){
            votesDictionary.addVote(postId: post.id, vote: 404)
            
            // Decrement downvote posts variable for statistics
            let currentNumber = UserDefaults.standard.integer(forKey: "dVoxDownVotedPosts")
            UserDefaults.standard.set((currentNumber - 1), forKey: "dVoxDownVotedPosts")
            
        }

        Timer.scheduledTimer(withTimeInterval: 0, repeats: true) { [self] timer in
            
            let add = apis.retriveKey(for: "ContractAddress") ?? "error"
            let inf = apis.retriveKey(for: "InfuraURL") ?? "error"
            let cre = apis.retriveKey(for: "Credentials") ?? "error"
            
            if (add != "error" && inf != "error" && cre != "error") {
                  
                /// Get data at a background thread
                DispatchQueue.global(qos: .userInitiated).async { [] in
                    
                    
                        let ref = Firestore.firestore().collection("Votes").document(add)

                        ref.updateData([
                            "\(post.id)_downvote": FieldValue.increment(Int64(vote))
                        ])

                }
                /// Update UI at the main thread
                DispatchQueue.main.async {
                    
                    getVoteDown()
                    
                    timer.invalidate()
                }
            }
        }
    }
    
    func getVoteUp() {
        Timer.scheduledTimer(withTimeInterval: 0, repeats: true) { [self] timer in
            
            var currentPost = 0
            
            let add = apis.retriveKey(for: "ContractAddress") ?? "error"
            
            if (add != "error") {
                  
                DispatchQueue.global(qos: .userInitiated).async { [] in
                    
                    let ref = Firestore.firestore().collection("Votes").document(add)
                    
                    ref.getDocument{ [self] (document, error) in
                        
                        if let document = document, document.exists{
                            
                            currentPost = Int(document.get("\(post.id)_upvote") as? Int64 ?? 0)
                            
                            print("\(post.id) Current UpVote: \(currentPost)")
                            
                        } else {

                            currentPost = 0
                        }
                        voteUp = currentPost
                    }

                }
                /// Update UI at the main thread
                DispatchQueue.main.async {
    
                    timer.invalidate()
                }
            }
        }

    }
    
    func getVoteDown() {
        Timer.scheduledTimer(withTimeInterval: 0, repeats: true) { [self] timer in
            
            var currentPost = 0
            
            let add = apis.retriveKey(for: "ContractAddress") ?? "error"
            
            if (add != "error") {
                  
                DispatchQueue.global(qos: .userInitiated).async { [] in
                    
                    let ref = Firestore.firestore().collection("Votes").document(add)
                    
                    ref.getDocument{ [self] (document, error) in
                        
                        if let document = document, document.exists{
                            
                            currentPost = Int(document.get("\(post.id)_downvote") as? Int64 ?? 0)
                            
                            print("\(post.id) Current DownVote: \(currentPost)")
                            
                        } else {

                            currentPost = 0
                        }
                        voteDown = currentPost
                    }

                }
                /// Update UI at the main thread
                DispatchQueue.main.async {

                    timer.invalidate()
                    
                }
            }
        }

    }
    
}

struct CirclesView : View {
    
    var isLiked : Bool
    let angle : CGFloat = 40
    let radius : CGFloat
    let speed : Double
    let scale : CGFloat
    
    var body: some View {
        //View Elements
        ZStack {
            ForEach (0..<9) { num in
                Circle()
                    .fill(Color.red)
                    .frame(width: 10, height: 10)
                    .scaleEffect(self.isLiked ? 0.1 : self.scale)
                    .animation(.linear(duration: self.speed))
                    .offset(x:  self.radius * cos(CGFloat(num) * self.angle * .pi / 180),
                            y: self.radius * sin(CGFloat(num) * self.angle * .pi / 180))
            }
        }
    }
    
    struct LikeButton : View {
        
        
        var body: some View {
            
            VStack {
                
                Preview()
            }
        }
        
    }
    
    
    
    
    
    
    struct LikeButton_Previews: PreviewProvider {
        static var previews: some View {
            LikeButton()
        }
    }
}
