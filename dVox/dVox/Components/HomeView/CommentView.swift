//
//  CommentView.swift
//  dVox
//
//  Created by Aleksandr Molchagin on 8/14/21.
//

import SwiftUI

import NavigationStack

struct CommentView: View {
    
    @State var usernameString = UserDefaults.standard.string(forKey: "dvoxUsername")
    @State var avatarString = UserDefaults.standard.string(forKey: "dvoxUsernameAvatar")
    
    var post: Post
    
    @State var comment = ""
    
    var apis: APIs
    
    @ObservedObject var loader = CommentLoader()
    
    var comments = [
        Comment(id: 1, author: "@Lazy_snake_9", message: "Hello brother!", ban: false),
        Comment(id: 1, author: "@Black_and_white_snake_23", message: "I totally agree, but why this or not this?", ban: false),
        Comment(id: 1, author: "@Cozy_snake_85", message: "Aliqua in laboris commodo nisi aute tempor dolor nulla. Laboris deserunt deserunt occaecat cupidatat. Deserunt velit ullamco nisi deserunt sint reprehenderit ea. Proident deserunt irure culpa ea ad dolor magna aute aliquip ullamco.", ban: false),
        Comment(id: 1, author: "author", message: "message", ban: false),
        Comment(id: 1, author: "author", message: "message", ban: false),
    ]
    
    @State var nextIndex: Int
    
    var votesDictionary: VotesContainer
    
    
    var username: Username
    
    var postUser = Username()
    
    @State var numberOfComments: Int
    
    @State var refresh = Refresh(started: false, released: false)
    
    init(_apis: APIs, _username: Username, _post: Post, _votesDictionary: VotesContainer){
        apis = _apis
        username = _username
        post = _post
        numberOfComments = _post.commentsNumber
        nextIndex = 1
        votesDictionary = _votesDictionary
    }
    
    var body: some View {
        
        ZStack{
            Color("BlackColor")
                .ignoresSafeArea()
            
            VStack {
                ZStack{
                    
                    Color("WhiteColor")
                    
                    VStack{
                    
                            ScrollView {
                                //Gemoetry reader for calculating position...
                                GeometryReader{ reader -> AnyView in
                                    
                                    DispatchQueue.main.async {
                                        if (refresh.startOffset == 0) {
                                            refresh.startOffset = reader.frame(in: .global).minY
                                        }
                                        
                                        refresh.offset = reader.frame(in: .global).minY
                                        
                                        if (refresh.offset - refresh.startOffset > 90 && !refresh.started){
                                            refresh.started = true
                                        }
                                        
                                        //checking if refresh is started and drag is released
                                        
                                        if refresh.startOffset  == refresh.offset && refresh.started && !refresh.released{
                                            withAnimation(Animation.linear){ refresh.released = true }
                                            updateData();
                                        }
                                        
                                        //checking if invalid becomes valid....
                                        if refresh.startOffset  == refresh.offset && refresh.started && !refresh.released && refresh.invalid{
                                            refresh.invalid = false
                                            updateData()
                                        }

                                    }
                                    
                                    return AnyView(Color.white.frame(width: 0, height: 0))
                                }
                                .frame(width: 0, height: 0)
                                
                                ZStack(alignment: Alignment(horizontal: .center, vertical: .top)){
                                    
                                    if (refresh.started && refresh.released) {
                                        ProgressView()
                                            .offset(y: -35)
                                            .progressViewStyle(CircularProgressViewStyle(tint: Color("BlackColor")))
                                    }
                                    else {
                                        Image(systemName: "arrow.down")
                                            .font(.system(size: 16, weight: .heavy))
                                            .foregroundColor(.black)
                                            .rotationEffect(.init(degrees: refresh.started ? 180 : 0))
                                            .offset(y: -25)
                                            .animation(.easeIn)
                                            .padding(.bottom, 10)
                                    }
                                    LazyVStack{
                                        CommentPost(_post: post, _avatar: username.getAvatarString(), _apis: apis, _votesDictionary: votesDictionary)
                                            .padding(.top,5)
                                        Divider()
                                        
                                        if (loader.noMoreComments == false && numberOfComments != 0){
                                            if numberOfComments < 15{
                                                ForEach(0 ..< post.commentsNumber) { number in
                                                ShimmerComment()
                                                    .padding(-20)
                                                    .padding(.horizontal, -10)
                                                    .padding([.bottom], 10)
                                                }
                                            } else {
                                                ForEach(0 ..< 15) { number in
                                                ShimmerComment()
                                                    .padding(-20)
                                                    .padding(.horizontal, -10)
                                                    .padding([.bottom], 10)
                                                }
                                            }
                                        }
                                        else{
                                        ForEach(loader.allComments.indices, id: \.self) { index in
                                            let comment = loader.allComments[index]
                                            CommentItem(_comment: comment)
                                                .onAppear{
                                                    print("Index \(index), nTl \(6)")
                                                    if (index == loader.allComments.count-1 && loader.noMoreComments == false)  {
                                                        loader.getComments(index: index, apis: apis, post: post, currentId: comment.id, getComments: 6)
                                                    }
                                                }
                                        }
                                        .padding([.bottom], 10)
                                        
                                    }
                                    }
                                    
                                }
                                .offset(y: refresh.released ? 25: -5)
                                
                            //}
                            
                        }
                        
                        Spacer()
                        
                        Divider()
                        
                        HStack{
                            
                            VStack{
                                
                                TextField("Comment as \(usernameString ?? "No data provided")", text: $comment)
                                    .accentColor(Color("BlackColor"))
                                    .font(.custom("Montserrat", size: 15))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top, 15)
                                    .padding(.leading, 5)
                                
                            }
                            
                            Button(action: {
                                addComment(postID: post.id)
                            }) {
                                Text("Post")
                                    .font(.custom("Montserrat-Bold", size: 20))
                                    .foregroundColor(Color("BlackColor"))
                                    .padding(.trailing, 5)
                                    .padding(.top, 15)
                                    .frame(alignment: .trailing)
                            }
                        }
                    }
                }
                .padding(.bottom, 30)
                .padding(.top, 30)
                .padding(.horizontal, 20)
                .background(RoundedCorners(tl: 20, tr: 20, bl: 20, br: 20).fill(Color("WhiteColor")))
            }
            .padding(.bottom, 10)
            .padding(.top, 10)
            .padding(.horizontal, 10)
            .onAppear {
                loader.getComments(index: 0, apis: apis, post: post, currentId: -1, getComments: 6)
            }
            
        }
    }
    
    func updateData(){
        print("Updating data....")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            withAnimation(Animation.linear){
                
                if refresh.startOffset == refresh.offset{
                    loader.allComments = []
                    refresh.released = false
                    refresh.started = false
                } else {
                    refresh.invalid = true
                }
            }
            loader.getComments(index: 0, apis: apis, post: post, currentId: -1, getComments: 6)
            loader.noMoreComments = false
        }
    }
    
    struct Refresh{
        var startOffset: CGFloat = 0
        var offset: CGFloat = 0
        var started: Bool
        var released: Bool
        var invalid: Bool = false
    }
    
    struct CommentPost: View {
        
        var post: Post
        
        var apis: APIs
        
        var avatar: String
        
        var votesDictionary: VotesContainer
        
        init(_post: Post, _avatar: String, _apis: APIs, _votesDictionary: VotesContainer){
            post = _post
            avatar = _avatar
            apis = _apis
            votesDictionary = _votesDictionary
        }
        
        var body: some View {
            
            VStack{
                
                ZStack{
                    HStack{
                        Image(avatar)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 45)
                            .padding([.trailing], 5)
                        
                        VStack{
                            Text(post.title)
                                .font(.custom("Montserrat-Bold", size: 20))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(post.author)
                                .font(.custom("Montserrat", size: 14))
                                
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        PopView {
                            Image("fi-rr-cross-small")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20)
                                .padding(.top, -30)
                        }
                        
                    }
                    
                }
                .padding([.top, .leading, .trailing], 0)
                HStack{
                    Text(post.message)
                        .font(.custom("Montserrat", size: 15))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 0)
                HStack{
                    
                    VotesBlock(_post: post, _apis: apis, _voted: votesDictionary.getVote(postId: post.id), _votesContainer: votesDictionary)
                        .padding(.leading, -20)
                    
                    
                    //                    Button(action: {
                    //
                    //                    })
                    //                    {
                    //                        Image("fi-rr-comment")
                    //                            .resizable()
                    //                            .aspectRatio(contentMode: .fit)
                    //                            .frame(width: 20)
                    //                            .padding([.leading], 5)
                    //                    }
                    //
                    //                    .frame(alignment: .leading)
                    //                    .padding([.bottom], 20)
                    //
                    //                    Text(String(post.commentsNumber))
                    //                        .font(.custom("Montserrat-Bold", size: 14))
                    //                        .frame( alignment: .leading)
                    //                        .padding([.bottom ], 20)
                    
                    Text(post.hashtag)
                        .font(.custom("Montserrat-Bold", size: 14))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding([.leading, .bottom], 20)
                }
                
            }
            .foregroundColor(Color("BlackColor"))
            .frame(maxWidth: .infinity, alignment: .top)
        }
    }
    
    struct CommentItem: View {
        
        var comment: Comment
        
        var commentUser = Username()
        
        init(_comment: Comment){
            comment = _comment
            commentUser.stringToUsername(usernameString: comment.author)
        }
        
        var body: some View {
            
            VStack{
                
                HStack{
                    VStack{
                        Image(commentUser.getAvatarString())
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30)
                            .padding(.top, 5)
                            .padding(.trailing, 5)
                        
                        Spacer()
                    }
                    
                    VStack{
                        
                        HStack{
                            
                            Text(commentUser.getUsernameString())
                                .font(.custom("Montserrat-Bold", size: 14))
                                .frame(alignment: .leading)
                            Spacer()
                        }
                        
                        HStack{
                            
                            Text(comment.message)
                                .font(.custom("Montserrat", size: 14))
                                .frame(alignment: .leading)
                            Spacer()
                        }
                        
                    }
                    Spacer()
                    
                }
                
            }
        }
    }
    struct CommentView_Preview: PreviewProvider {
        
        static var previews: some View {
            CommentView(_apis: APIs(), _username: Username(), _post: Post(id: 1, title: "This is the title", author: "@Lazy_snake_1", message: "Ullamco nulla reprehenderit fugiat pariatur. Aliqua in laboris commodo nisi aute tempor dolor nulla. Laboris deserunt deserunt occaecat cupidatat. Deserunt velit ullamco nisi deserunt sint reprehenderit ea. Proident deserunt irure culpa ea ad dolor magna aute aliquip ullamco. Laboris deserunt nisi amet elit velit dolor laboris aute. Adipisicing do velit cillum fugiat nostrud et veniam laboris laboris velit ut dolor ad.", hastag: "#physicstalk", upVotes: 10, downVotes: 4, commentsNumber: 7, ban: false), _votesDictionary: VotesContainer())
        }
    }
    
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
    
    func addComment(postID: Int) {
        if comment != "" {
            Timer.scheduledTimer(withTimeInterval: 0, repeats: true) { [self] timer in
    
                let add = apis.retriveKey(for: "ContractAddress") ?? "error"
                let inf = apis.retriveKey(for: "InfuraURL") ?? "error"
                let cre = apis.retriveKey(for: "Credentials") ?? "error"
                
                var com = Comment(id: -1, author: "", message: "", ban: false)
    
                let whatToPost = comment
                
                if (add != "error" && inf != "error" && cre != "error") {
    
                    /// Get data at a background thread
                    DispatchQueue.global(qos: .userInitiated).async { [] in
                        let contract = SmartContract(credentials: cre, infura: inf, address: add)
                        
                        contract.addComment(postID: postID, author: usernameString ?? "Hacker", message: whatToPost)
                                
                    }
                    /// Update UI at the main thread
                    DispatchQueue.main.async {
                        com = Comment(id: -1, author: usernameString ?? "Hacker", message: comment, ban: false)

                    
                        loader.addComment(comment: com)
                        
                        comment = ""

                        
                        timer.invalidate()
                    }
                }
            }
        
        }
    }
    
}

