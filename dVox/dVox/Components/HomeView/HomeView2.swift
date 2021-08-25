//
//  HomeView.swift
//  HomeView
//
//  Created by Revaz Bakuradze on 03.08.21.
//

import Foundation
import SwiftUI

import NavigationStack

struct HomeView2: View {
        
    var apis: APIs
    
    var posts = [
        Post(id: 1, title: "This is the title", author: "@Lazy_snake_1", message: "Ullamco nulla reprehenderit fugiat pariatur. Aliqua in laboris commodo nisi aute tempor dolor nulla. Laboris deserunt deserunt occaecat cupidatat. Deserunt velit ullamco nisi deserunt sint reprehenderit ea. Proident deserunt irure culpa ea ad dolor magna aute aliquip ullamco. Laboris deserunt nisi amet elit velit dolor laboris aute. Adipisicing do velit cillum fugiat nostrud et veniam laboris laboris velit ut dolor ad.", hastag: "#physicstalk", upVotes: 10, downVotes: 4, commentsNumber: 7, ban: false),
        Post(id: 2, title: "It's time for physics!", author: "@Crazy_snake_95", message: " Aliqua in laboris commodo nisi aute tempor dolor nulla. Laboris deserunt deserunt occaecat cupidatat.Adipisicing do velit cillum fugiat nostrud et veniam laboris laboris velit ut dolor ad.", hastag: "#letsgopeople", upVotes: 3, downVotes: 2, commentsNumber: 5, ban: false),
    ]
    
    @ObservedObject var loader: PostLoader2
    
    @State var nextIndex: Int
    
    
    var numberOfPostsToLoad = 6
    
    var username: Username
    

    @State var items: [Item] = [Item]()
    
    @State var refresh = Refresh(started: false, released: false)
    
    let codeDM = PersistenceController()
    
    let votesDictionary = VotesContainer()
    
    let state: Bool = true
    
    init(_apis: APIs, _username: Username, _loader: PostLoader2){
        apis = _apis
        username = _username
        loader = _loader
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
                        
                        //Gemoetry reader for calculating position...
                        GeometryReader{ reader -> AnyView in
                            
                            DispatchQueue.main.async {
                                
                                
                                if (refresh.startOffset == 0) {
                                    refresh.startOffset = reader.frame(in: .global).minY
                                    
                                }

                                var offvar = reader.frame(in: .global).minY

                               // ASSIGNING A VARIABLE CAUSES APP TO CRASH -> CALLING READER ALL THE TIME
                               // refresh.offset = reader.frame(in: .global).minY

                                if (offvar - refresh.startOffset > 90 && !refresh.started){
                                    refresh.started = true
                                }

                                //checking if refresh is started and drag is released

                                if refresh.startOffset == offvar && refresh.started && !refresh.released{
                                    withAnimation(Animation.linear){ refresh.released = true }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                        withAnimation(Animation.linear){
                                            
                                            if refresh.startOffset == offvar{
                                                loader.items = []
                                                loader.getPosts(index: 0, currentId: -1, getPosts: 6)
                                                loader.noMorePosts = false
                                                refresh.released = false
                                                refresh.started = false
                                                refresh.startOffset = 0
                                                
                                            } else {
                                                refresh.invalid = true
                                            }
                                        }
                                    }
                                    
                                }

                                //checking if invalid becomes valid....
                                if refresh.startOffset  == offvar && refresh.started && !refresh.released && refresh.invalid{
                                    refresh.invalid = false
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                        withAnimation(Animation.linear){
                                            
                                            if refresh.startOffset == offvar{
                                                loader.items = []
                                                loader.getPosts(index: 0, currentId: -1, getPosts: 6)
                                                loader.noMorePosts = false
                                                refresh.released = false
                                                refresh.started = false
                                                refresh.startOffset = 0
                                            }
                                            else{
                                                refresh.invalid = true
                                            }
                                        }

                                    }
                                    
                                }


                            }

                            return AnyView(Color.black.frame(width: 0, height: 0))
                        }
                        .frame(width: 0, height: 0)
                        
                        ZStack(alignment: Alignment(horizontal: .center, vertical: .top)){
                            
                            if (refresh.started && refresh.released) {
                                ProgressView()
                                    .offset(y: -35)
                                    .progressViewStyle(CircularProgressViewStyle(tint: Color("WhiteColor")))
                                    .scaleEffect(1.5, anchor: .center)
                            }
                            else {
                            Image(systemName: "arrow.down")
                                .font(.system(size: 16, weight: .heavy))
                                .foregroundColor(.white)
                                .rotationEffect(.init(degrees: refresh.started ? 180 : 0))
                                .offset(y: -25)
                                .animation(.easeIn)
                                .padding(.bottom, 10)
                            }
                            
                            LazyVStack{
                                ForEach(loader.items.indices, id: \.self) { index in
                                    let post = Post(id: Int(loader.items[index].postId), title: loader.items[index].title ?? "No data provided", author: loader.items[index].author ?? "No data provided", message: loader.items[index].message ?? "No data provided", hastag: loader.items[index].hashtag ?? "No data provided", upVotes: Int(loader.items[index].upVotes), downVotes: Int(loader.items[index].downVotes), commentsNumber: Int(loader.items[index].commentsNumber), ban: false)
                                    CardRow(_apis: apis, _username: username, _post: post, _votesDictionary: votesDictionary)
                                        .onAppear{
                                            print("(\(index)) Post with id \(post.id) appeared: \n \(post.title) ")
                                            if (index == loader.items.count-1 && posts.count == 3) {
                                                //loader.getPosts(index: nextIndex, currentId: post.id, getPosts: 6)
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
                        .offset(y: refresh.released ? 50: -5)
                    }
                    
                }}
                .navigationBarHidden(true)
                .environmentObject(loader)
        }
    }
    
//    func updateData(){
//        print("Updating data....")
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
//            withAnimation(Animation.linear){
//
//                if refresh.startOffset == 0{
//                    loader.items = []
//                    refresh.released = false
//                    refresh.started = false
//                } else {
//                    refresh.invalid = true
//                }
//            }
//            loader.getPosts(index: 0, currentId: -1, getPosts: 6)
//            loader.noMorePosts = false
//        }
//    }
    
   
    struct Refresh{
        var startOffset: CGFloat = 0
        //var offset: CGFloat = 0
        var started: Bool
        var released: Bool
        var invalid: Bool = false
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
                        
                        VotesBlock(_post: eachPost, _apis: apis, _voted: votesDictionary.getVote(postId: eachPost.id), _votesContainer: votesDictionary)
                        
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
        
//        struct RoundedCorners: Shape {
//            var tl: CGFloat = 0.0
//            var tr: CGFloat = 0.0
//            var bl: CGFloat = 0.0
//            var br: CGFloat = 0.0
//
//            func path(in rect: CGRect) -> Path {
//                var path = Path()
//
//                let w = rect.size.width
//                let h = rect.size.height
//
//                // Make sure we do not exceed the size of the rectangle
//                let tr = min(min(self.tr, h/2), w/2)
//                let tl = min(min(self.tl, h/2), w/2)
//                let bl = min(min(self.bl, h/2), w/2)
//                let br = min(min(self.br, h/2), w/2)
//
//                path.move(to: CGPoint(x: w / 2.0, y: 0))
//                path.addLine(to: CGPoint(x: w - tr, y: 0))
//                path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr,
//                            startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
//
//                path.addLine(to: CGPoint(x: w, y: h - br))
//                path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br,
//                            startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
//
//                path.addLine(to: CGPoint(x: bl, y: h))
//                path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl,
//                            startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
//
//                path.addLine(to: CGPoint(x: 0, y: tl))
//                path.addArc(center: CGPoint(x: tl, y: tl), radius: tl,
//                            startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
//
//                return path
//            }
//        }
//
    
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
