//
//  HomeView.swift
//  HomeView
//
//  Created by Revaz Bakuradze on 03.08.21.
//

import Foundation
import SwiftUI

import NavigationStack

struct HomeView: View {
    
    var apis: APIs
    
    var posts = [
        Post(id: 1, title: "This is the title", author: "@Lazy_snake_1", message: "Ullamco nulla reprehenderit fugiat pariatur. Aliqua in laboris commodo nisi aute tempor dolor nulla. Laboris deserunt deserunt occaecat cupidatat. Deserunt velit ullamco nisi deserunt sint reprehenderit ea. Proident deserunt irure culpa ea ad dolor magna aute aliquip ullamco. Laboris deserunt nisi amet elit velit dolor laboris aute. Adipisicing do velit cillum fugiat nostrud et veniam laboris laboris velit ut dolor ad.", hastag: "#physicstalk", upVotes: 10, downVotes: 4, commentsNumber: 7, ban: false),
        Post(id: 2, title: "It's time for physics!", author: "@Crazy_snake_95", message: " Aliqua in laboris commodo nisi aute tempor dolor nulla. Laboris deserunt deserunt occaecat cupidatat.Adipisicing do velit cillum fugiat nostrud et veniam laboris laboris velit ut dolor ad.", hastag: "#letsgopeople", upVotes: 3, downVotes: 2, commentsNumber: 5, ban: false),
    ]
    
    @ObservedObject var loader: PostLoader
    
    @State var nextIndex: Int
    
    @State var votesDictionary = VotesContainer()
    
    var numberOfPostsToLoad = 6
    
    var username: Username
    
    var codeDM: PersistenceController
    
    @State var items: [Item] = [Item]()
    
    init(_apis: APIs, _username: Username, _codeDM: PersistenceController, _postLoader: PostLoader){
        apis = _apis
        username = _username
        codeDM = _codeDM
        loader = _postLoader
        nextIndex = 1
    }
    
    var body: some View {
        
        ZStack {
            Color("BlackColor")
                .ignoresSafeArea()
            
            ZStack{
                Color("BlackColor")
                    .ignoresSafeArea()
                if (loader.items.count == 0){
                    ScrollView{
                        LazyVStack{
                            ForEach(0 ..< 1) { number in
                                ShimmerPost()
                                    .padding([.bottom], 10)
                            }
                            Spacer()
                        }
                    }
                } else {
                    ScrollView{
                        LazyVStack{
                            ForEach(loader.items.indices, id: \.self) { index in
                                let post = Post(id: Int(loader.items[index].postId), title: loader.items[index].title ?? "No data provided", author: loader.items[index].author ?? "No data provided", message: loader.items[index].message ?? "No data provided", hastag: loader.items[index].hashtag ?? "No data provided", upVotes: Int(loader.items[index].upVotes), downVotes: Int(loader.items[index].downVotes), commentsNumber: Int(loader.items[index].commentsNumber), ban: false)
                                CardRow(_apis: apis, _username: username, _post: post, _votesDictionary: votesDictionary)
                                    .onAppear{
                                        print("(\(index)) Post with id \(post.id) appeared: \n \(post.title) ")
                                        if (index == loader.items.count-1 && loader.noMorePosts == false) {
                                            loader.getPosts(index: nextIndex, currentId: post.id, getPosts: 6)
                                            nextIndex += 1
                                        }
                                    }
                            }
                            .padding([.bottom], 10)
                            
                            if loader.noMorePosts == false {
                                ForEach(0 ..< 1) { number in
                                    ShimmerPost()
                                        .padding([.bottom], 10)
                                }
                                
                            }
                            
                        }
                    }
                    
                }}
                .navigationBarHidden(true)
        }
    }
    
    struct CardRow: View {
        @State var eachPost: Post
        
        @State private var isActive = false
        
        @State var upVote = 0
        
        @State var downVote = 0
        
        @State var votesDictionary: VotesContainer
        
        var apis: APIs
        
        var username: Username
        
        var postUser = Username()
        

        init(_apis: APIs, _username: Username, _post: Post, _votesDictionary: VotesContainer){
            apis = _apis
            username = _username
            eachPost = _post
            votesDictionary = _votesDictionary
            postUser.stringToUsername(usernameString: eachPost.author)
            VotesBlock(_postId: eachPost.id, _apis: apis, _voted: votesDictionary.getVote(postId: eachPost.id), _votesContainer: votesDictionary)

        }
        
        var body: some View {
            
            ZStack{
                
                VStack{
                    HStack{
                        Image(postUser.getAvatarString())
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 45)
                            .padding([.trailing], 5)
                        
                        VStack{
                            Text(eachPost.title)
                                .font(.custom("Montserrat-Bold", size: 20))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(postUser.getUsernameString())
                                .font(.custom("Montserrat", size: 14))
                                
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding([.top, .leading, .trailing], 20)
                    HStack{
                        Text(eachPost.message)
                            .font(.custom("Montserrat", size: 15))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(6)
                    }
                    .padding(.horizontal, 20.0)
                    HStack{
                        
                        VotesBlock(_postId: eachPost.id, _apis: apis, _voted: votesDictionary.getVote(postId: eachPost.id), _votesContainer: votesDictionary)
                        
                        PushView(destination: CommentView(_apis: apis, _username: postUser, _post: eachPost, _votesDictionary: votesDictionary), isActive: $isActive) {
                            
                            
                            Button(action: {
                                self.isActive.toggle()
                            })
                            {
                                Image("fi-rr-comment")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20)
                            }
                        }
                        
                        
                        .frame(alignment: .leading)
                        .padding([.bottom], 20)
                        
                        Text(String(eachPost.commentsNumber))
                            .font(.custom("Montserrat-Bold", size: 14))
                            .frame( alignment: .leading)
                            .padding([.bottom ], 20)
                        
                        Text(eachPost.hashtag)
                            .font(.custom("Montserrat-Bold", size: 14))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding([.leading, .bottom, .trailing], 20)
                    }
                    
                }
                .background(RoundedCorners(tl: 20, tr: 20, bl: 20, br: 20).fill(Color("WhiteColor")))
                .foregroundColor(Color("BlackColor"))
                .padding(.horizontal, 10)
                
            }
        }
        
        //        struct HomeView_Previews: PreviewProvider {
        //            static var previews: some View {
        //                var apis = APIs()
        //                HomeView(_apis: apis, _username: Username(), _codeDM: PersistenceController(), _postLoader: PostLoader(PersistenceController()))
        //            }
        //        }
        
        struct RoundedCorners: Shape {
            var tl: CGFloat = 0.0
            var tr: CGFloat = 0.0
            var bl: CGFloat = 0.0
            var br: CGFloat = 0.0
            
            func path(in rect: CGRect) -> Path {
                var path = Path()
                
                let w = rect.size.width
                let h = rect.size.height
                
                // Make sure we do not exceed the size of the rectangle
                let tr = min(min(self.tr, h/2), w/2)
                let tl = min(min(self.tl, h/2), w/2)
                let bl = min(min(self.bl, h/2), w/2)
                let br = min(min(self.br, h/2), w/2)
                
                path.move(to: CGPoint(x: w / 2.0, y: 0))
                path.addLine(to: CGPoint(x: w - tr, y: 0))
                path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr,
                            startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
                
                path.addLine(to: CGPoint(x: w, y: h - br))
                path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br,
                            startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
                
                path.addLine(to: CGPoint(x: bl, y: h))
                path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl,
                            startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
                
                path.addLine(to: CGPoint(x: 0, y: tl))
                path.addArc(center: CGPoint(x: tl, y: tl), radius: tl,
                            startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
                
                return path
            }
        }
    
    
//    func ban(post: Int) {
//
//        Timer.scheduledTimer(withTimeInterval: 0, repeats: true) { [self] timer in
//
//            let add = apis.retriveKey(for: "ContractAddress") ?? "error"
//            let inf = apis.retriveKey(for: "InfuraURL") ?? "error"
//            let cre = apis.retriveKey(for: "Credentials") ?? "error"
//
//            if (add != "error" && inf != "error" && cre != "error") {
//
//                /// Get data at a background thread
//                DispatchQueue.global(qos: .userInitiated).async { [] in
//                    let contract = SmartContract(credentials: cre, infura: inf, address: add)
//                    contract.banPost(postId: post)
//                }
//                /// Update UI at the main thread
//                DispatchQueue.main.async {
//
//                    timer.invalidate()
//                }
//            }
//        }
//    }
        
    }
}
