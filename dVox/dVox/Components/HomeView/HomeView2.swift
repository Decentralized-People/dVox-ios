//
//  HomeView.swift
//  HomeView
//
//  Created by Revaz Bakuradze on 03.08.21.
//

import Foundation
import SwiftUI
import Firebase
import NavigationStack

struct HomeView2: View {
        
    var apis: APIs
    
    var posts = [
        Post(id: 1, title: "This is the title", author: "@Lazy_snake_1", message: "Ullamco nulla reprehenderit fugiat pariatur. Aliqua in laboris commodo nisi aute tempor dolor nulla. Laboris deserunt deserunt occaecat cupidatat. Deserunt velit ullamco nisi deserunt sint reprehenderit ea. Proident deserunt irure culpa ea ad dolor magna aute aliquip ullamco. Laboris deserunt nisi amet elit velit dolor laboris aute. Adipisicing do velit cillum fugiat nostrud et veniam laboris laboris velit ut dolor ad.", hastag: "#physicstalk", upVotes: 10, downVotes: 4, commentsNumber: 7, ban: false),
        Post(id: 2, title: "It's time for physics!", author: "@Crazy_snake_95", message: " Aliqua in laboris commodo nisi aute tempor dolor nulla. Laboris deserunt deserunt occaecat cupidatat.Adipisicing do velit cillum fugiat nostrud et veniam laboris laboris velit ut dolor ad.", hastag: "#letsgopeople", upVotes: 3, downVotes: 2, commentsNumber: 5, ban: false),
    ]
    
    @ObservedObject var loader: PostLoader2
    
    @ObservedObject var commentLoader: CommentLoader
    
    @State var nextIndex: Int

    var numberOfPostsToLoad = 6
    
    var username: Username
    
    @State var items: [Item] = [Item]()
    
    @State var refresh = Refresh(started: false, released: false)
    
    let codeDM = PersistenceController()
    
    let votesDictionary = VotesContainer()
    
    let state: Bool = true
    
    
    init(_apis: APIs, _username: Username, _loader: PostLoader2, _commentsLoader: CommentLoader){
        apis = _apis
        username = _username
        loader = _loader
        commentLoader = _commentsLoader
        nextIndex = 1
    }
    
    var body: some View {
        
        ZStack {
            Color("BlackColor")
                .ignoresSafeArea()
                .onAppear(perform: {
                    if (UserDefaults.standard.bool(forKey: "SERVER_CHANGED")){
                        loader.items = []
                        loader.getPosts(index: 0, currentId: -1, getPosts:12)
                        loader.noMorePosts = false
                        refresh.released = false
                        refresh.started = false
                        refresh.startOffset = 0
                        UserDefaults.standard.set(false, forKey: "SERVER_CHANGED")
                    }
                })
            
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
                                
                                print(reader.frame(in: .global).minY)

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
                                                loader.getPosts(index: 0, currentId: -1, getPosts:12)
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
                                                loader.getPosts(index: 0, currentId: -1, getPosts: 12)
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
                                    CardRow(_apis: apis, _username: username, _post: post, _votesDictionary: votesDictionary, _commentLoader: commentLoader, _loader: loader, _index: index)
                                        .onAppear{
                                            print("(\(index)) Post with id \(post.id) appeared: \n \(post.title) ")
                                            if (index == loader.items.count-1 && loader.noMorePosts == false) {
                                                loader.getPosts(index: nextIndex, currentId: post.id, getPosts: 8)
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
        
        @ObservedObject var loader: PostLoader2
        
        @State private var isActive = false
        
        @State var upVote = 0
        
        @State var downVote = 0
        
        @State var votesDictionary: VotesContainer
                
        var apis: APIs
        
        var username: Username
        
        var postUser = Username()
        
        @State var commentView: CommentView!
        
        @ObservedObject var commentLoader: CommentLoader
        
        @State var overlayOn: Bool = false;
        
        @State var overlayOfOverlayOn: Bool = false;
    
        @State var currentSelection: Int = 0;
        
        var curIndex: Int;
        
        var questionArray = ["Hide this post?", "Block this author?", "Report this post?"]
        
        
        @State var postIsHidden = false
        @State var hiddenPostProps = ["Title", "Author", "Message", "Hashtag"]
    
        init(_apis: APIs, _username: Username, _post: Post, _votesDictionary: VotesContainer, _commentLoader: CommentLoader, _loader: PostLoader2, _index: Int){
            apis = _apis
            username = _username
            eachPost = _post
            votesDictionary = _votesDictionary
            commentLoader = _commentLoader
            loader = _loader
            curIndex = _index
            postUser.stringToUsername(usernameString: eachPost.author)
        }
        
        var body: some View {
            
            ZStack{
              
                if postIsHidden {
                    hiddenPost
                } else {
                    postBody
                    if overlayOn {
                        postOverlay
                    }
                }

            }
        }
        
        var postBody: some View {
            ZStack{
                VStack{
                    HStack{
                        Image(postUser.getAvatarString())
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 45)
                            .padding(.trailing, 5)


                        
                        VStack{
                            Text(eachPost.title)
                                .font(.custom("Montserrat-Bold", size: 20))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(postUser.getUsernameString())
                                .font(.custom("Montserrat", size: 14))
                                
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding([.top, .leading], 20)
                    .padding(.trailing, 10)

                    HStack{
                        Text(eachPost.message)
                            .font(.custom("Montserrat", size: 15))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(6)
                    }
                    .padding(.horizontal, 20.0)
                    HStack{
                        
                        VotesBlock(_post: eachPost, _apis: apis, _voted: votesDictionary.getVote(postId: eachPost.id), _votesContainer: votesDictionary)
                        
                        PushView(destination: CommentView(_username: postUser, _post: eachPost, _votesDictionary: votesDictionary, _commentLoader: commentLoader), isActive: $isActive) {
                            
                            
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
                
                VStack{
                        
                    HStack{
                        Spacer()
                        Button(action: {
                            withAnimation(.linear(duration: 0.2), {
                                overlayOn = true
                            })
                        }){
                        Image("fi-rr-menu-dots")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20)
                        }
                    }
                    .padding(.top, 10)
                    .padding(.trailing, 30)
                    
                    Spacer()
                }
            }
        }
        
        var hiddenPost: some View {
            ZStack{
                VStack{
                    HStack{
                        Image("@avatar_hacker")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 45)
                            .padding(.trailing, 5)


                        
                        VStack{
                            Text(hiddenPostProps[0])
                                .font(.custom("Montserrat-Bold", size: 20))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(hiddenPostProps[1])
                                .font(.custom("Montserrat", size: 14))
                                
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding([.top, .leading], 20)
                    .padding(.trailing, 10)

                    HStack{
                        Text(hiddenPostProps[2])
                            .font(.custom("Montserrat", size: 15))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(6)
                    }
                    .padding(.horizontal, 20.0)
                    HStack{
                        
                        
                        Text(hiddenPostProps[3])
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
        
        var postOverlay: some View {
                        
            ZStack{
                
            
            // ALL QUESTIONS // // // // // // // // // // // // // // // // //
            HStack{
                Spacer()

                VStack{
                    ZStack{
                        VStack{
                                
                            HStack{
                                Spacer()
                                Button(action: {
                                    withAnimation(.default, {
                                        overlayOn = false
                                    })
                                }){
                                Image("fi-rr-cross-small")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20)
                                }
                            }
                            .padding(.top, 10)
                            .padding(.trailing, 10)
                            
                            Spacer()
                        }
                        
                        VStack{
                            HStack{
                                Button(action: {
                                    currentSelection = 0;
                                    overlayOfOverlayOn = true
                                })
                                {
                                Image("fi-rr-eye-crossed")
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20)
                                
                                Text("Hide post")
                                    .foregroundColor(Color("BlackColor"))
                                    .font(.custom("Montserrat-Bold", size: 14))
                                
                                Spacer()
                                }
                                .padding(.trailing, 60)

                            }
                            HStack{
                                Button(action: {
                                    currentSelection = 1;
                                    overlayOfOverlayOn = true
                                })
                                {
                                Image("fi-rr-user-delete")
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20)
                                Text("Block author")
                                    .foregroundColor(Color("BlackColor"))
                                    .font(.custom("Montserrat-Bold", size: 14))
                                
                                Spacer()
                                }
                                .padding(.trailing, 60)

                            }
                            .padding(.vertical, 5)
                            HStack{
                                Button(action: {
                                    currentSelection = 2;
                                    overlayOfOverlayOn = true
                                })
                                {
                                Image("fi-rr-flag")
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20)
                                Text("Report")
                                    .foregroundColor(Color("BlackColor"))
                                    .font(.custom("Montserrat-Bold", size: 14))
                                
                                Spacer()
                                }
                                .padding(.trailing, 60)
                            }
                            .padding(.bottom, 5)
                        }
                        .padding(10)
                    }
                    .padding(.leading, 10)
                    .background(RoundedCorners(tl: 20, tr: 20, bl: 20, br: 20).fill(Color("WhiteColor")))
                    .cornerRadius(20).shadow(radius: 20)
                    .frame(width: 300, height: 130)
                    
                    Spacer()
                }
            }
            .padding(.trailing, 10)
            // // // // // // // // // // // // // // // // // // // // // // // //
                if overlayOfOverlayOn{
                    HStack{
                        Spacer()

                        VStack{
                            ZStack{
                                VStack{
                                        
                                    HStack{
                                        Spacer()
                                        Button(action: {
                                            withAnimation(.default, {
                                                overlayOfOverlayOn = false
                                                overlayOn = false
                                            })
                                        }){
                                        Image("fi-rr-cross-small")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20)
                                        }
                                    }
                                    .padding(.top, 10)
                                    .padding(.trailing, 10)
                                    
                                    Spacer()
                                }
                                
                                VStack{
                                  
                                   
                                    HStack{
                                        Button(action: {
                                        })
                                        {
                                            
                                            
                                        Text(questionArray[currentSelection])
                                            .foregroundColor(Color("BlackColor"))
                                            .font(.custom("Montserrat-Bold", size: 14))
                                            .lineLimit(3)
                                        
                                        }
                                        .padding(.horizontal, 30)
                                    }
                                    
                                    Spacer()
                                    
                                    HStack{
                                    
                                        Button(action: {
                                            withAnimation(.default) {
                                                overlayOfOverlayOn = false
                                            }
                                        })
                                        {
                                            (Text("No")
                                                .padding(10))
                                                .foregroundColor(Color("BlackColor"))
                                                .font(.custom("Montserrat-Bold", size: 14))
                                                .minimumScaleFactor(0.01)
                                                .lineLimit(3)
                                        }
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            withAnimation(.default) {
                                                overlayOfOverlayOn = false
                                                overlayOn = false
                                                postOptions(action: currentSelection, postId: eachPost.id)
                                            }
                                            
                                        })
                                        {
                                            (Text("Yes")
                                                .padding(10))
                                                .foregroundColor(Color("BlackColor"))
                                                .font(.custom("Montserrat-Bold", size: 14))
                                                .minimumScaleFactor(0.01)
                                                .lineLimit(3)
                                        }
                                    }
                                    .padding(.horizontal, 30)
                                    
                                    
                                }
                                .padding(30)
                            }
                            .background(RoundedCorners(tl: 20, tr: 20, bl: 20, br: 20).fill(Color("WhiteColor")))
                            .cornerRadius(20).shadow(radius: 20)
                            .frame(width: 300, height: 130)
                            
                            Spacer()
                        }
                    }
                    .padding(.trailing, 10)
                }
            
            
            }
           
            
        }
        
        /// Action:
        ///  0 - Hide the post
        ///  1 - Block the author
        ///  2 - Report the post
        func postOptions(action: Int, postId: Int){
            switch action{
                
            case 0:
                let banContainer = BanContainer()
                banContainer.setBan(postId: postId, ban: true)
                print("removing..\(postId)")
                hiddenPostProps[0] = returnStars(str: loader.items[curIndex].title ?? "****")
                hiddenPostProps[1] = returnStars(str: loader.items[curIndex].author ?? "****")
                hiddenPostProps[2] = returnStars(str: loader.items[curIndex].message ?? "****")
                hiddenPostProps[3] = returnStars(str: loader.items[curIndex].hashtag ?? "****")
                postIsHidden = true
    
            case 1:
                let banAuthorConatiner = BanAuthorContainer()
                banAuthorConatiner.setBan(author: loader.items[curIndex].title ?? "error", ban: true)
                loader.items = []
                loader.getPosts(index: 0, currentId: -1, getPosts:12)
                loader.noMorePosts = false

            case 2:
                
                /// Get data at a background thread
                DispatchQueue.global(qos: .userInitiated).async { [] in

                    var doc = UserDefaults.standard.string(forKey: "SCHOOL_LOCATION") ?? "Error"
                    
                    var ref = Firestore.firestore().collection("Reports").document("PublicLocation")

                    if UserDefaults.standard.bool(forKey: "SCHOOL_ENABLE"){
                        ref = Firestore.firestore().collection("Reports").document(doc)
                    }
                    ref.updateData([
                        "\(postId)": "Requested to ban"
                    ])
                
                }
                /// Update UI at the main thread
                DispatchQueue.main.async {
                                    
       
                }

                    
                
            default:
                print("HomeView2. Check the switcher. The operation is wrong.")
            }
        }
        
        func returnStars(str: String) -> String {
            var stringToReturn = "";
            for _ in str {
                stringToReturn.append("*")
            }
            return stringToReturn

        }
        
        struct HomeView_Previews: PreviewProvider {

            static var previews: some View {
                HomeView2(_apis: APIs(), _username: Username(), _loader: PostLoader2(_contract: SmartContract()), _commentsLoader: CommentLoader(_contract: SmartContract()))
            }
        }
    }
}
