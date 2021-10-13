//
//  CommentView.swift
//  dVox
//
//  Created by Aleksandr Molchagin on 8/14/21.
//

import SwiftUI

import NavigationStack

import AlertToast

struct CommentView: View {
    
    @State var usernameString = UserDefaults.standard.string(forKey: "dvoxUsername")
    @State var avatarString = UserDefaults.standard.string(forKey: "dvoxUsernameAvatar")
    
    var post: Post
    
    @State var comment = ""
    
    @ObservedObject var loader: CommentLoader
    
    @State var nextIndex: Int
    
    var votesDictionary: VotesContainer
    
    var username: Username
    
    var postUser = Username()
    
    @State var numberOfComments: Int
    
    @State var refresh = Refresh(started: false, released: false)
    
    @State private var postheight: CGFloat = 0
    
    @State var ready: Bool = false
    
    
    @State var toastTitle: String = "Your comment is sent!"

    @State var toastMessage: String = "It will appear in our decentralized storage soon"

    @State var showToast: Bool = false

    
    init(_username: Username, _post: Post, _votesDictionary: VotesContainer, _commentLoader: CommentLoader){
        username = _username
        post = _post
        numberOfComments = _post.commentsNumber
        nextIndex = 1
        votesDictionary = _votesDictionary
        loader = CommentLoader(_contract: _commentLoader.contract)
    }
    
    var body: some View {
        
        ZStack{
            Color("BlackColor")
                .ignoresSafeArea()
            
            VStack {
                ZStack{
                    
                    Color("WhiteColor")
                    
                
                    
                    VStack{
                    

                        CommentPost(_post: post, _avatar: username.getAvatarString(), _votesDictionary: votesDictionary)
                         
                    
                        Divider()
                        
                            
                            ScrollView {
                                
                                //Gemoetry reader for calculating position...
                                GeometryReader{ reader -> AnyView in
                                    
                                    DispatchQueue.main.async {
                                        
                                        print(reader.frame(in: .global).minY)
                                        if (refresh.startOffset == 0 && ready == true) {
                                            refresh.startOffset = reader.frame(in: .global).minY
                                        }
                                        
                                        refresh.offset = reader.frame(in: .global).minY
                                        
                                        if (refresh.offset - refresh.startOffset > 50 && !refresh.started && ready == true){
                                            refresh.started = true
                                        }
                                        
                                        //checking if refresh is started and drag is released
                                        
                                        if refresh.startOffset  == refresh.offset && refresh.started && !refresh.released && ready == true{
                                            withAnimation(Animation.linear){ refresh.released = true }
                                            updateData();
                                        }
                                        
                                        //checking if invalid becomes valid....
                                        if refresh.startOffset  == refresh.offset && refresh.started && !refresh.released && refresh.invalid && ready == true{
                                            refresh.invalid = false
                                            updateData()
                                        }
                                        
                                        if ready == false{
                                            ready = true
                                        }

                                    }
                                    
                                    return AnyView(Color.white.frame(width: 0, height: 0))
                                }
                                .frame(width: 0, height: 0)
                                
                                ZStack(alignment: Alignment(horizontal: .center, vertical: .top)){
                                    
                                    if (refresh.started && refresh.released) {
                                        ProgressView()
                                            .offset(y: -5)
                                            .progressViewStyle(CircularProgressViewStyle(tint: Color.black))
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
                                       
                                        
                                        if ( numberOfComments != 0 && loader.allComments.count == 0){
                                            if (numberOfComments > 12){
                                                ForEach(0 ..< 12) { number in
                                                ShimmerComment()
                                                    .padding(-20)
                                                    .padding(.horizontal, -10)
                                                    .padding([.bottom], 10)
                                                }
                                            } else {
                                                ForEach(0 ..< post.commentsNumber) { number in
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
                                                        loader.loadMore(post: post, numberOfComments: 6, currentId: comment.id)
                                                    }
                                                }
                                        }
                                        .padding([.bottom], 10)
                                        
//                                    }
                                    }
                                    
                                }
                                .offset(y: refresh.released ? 25: -5)
                                
                            }
                            
                        }
                        
                        Spacer()
                        
                        Divider()
                        
                        HStack{
                            
                            VStack{
                                                                
                                    TextField("Comment as \(usernameString ?? "No data provided")", text: $comment)
                                        .accentColor(Color("BlackColor"))
                                        .colorScheme(.light)
                                        .foregroundColor(Color("BlackColor"))
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
                if (numberOfComments > 12){
                    loader.loadMore(post: post, numberOfComments: 12, currentId: -1)
                } else{
                    loader.loadMore(post: post, numberOfComments: numberOfComments, currentId: -1)
                }
            }
            .toast(isPresenting: $showToast, duration: 4){

                       // `.alert` is the default displayMode
                       //AlertToast(type: .regular, title: "Message Sent!")
                       //Choose .hud to toast alert from the top of the screen
                AlertToast(displayMode: .hud, type: .complete(Color("BlackColor")), title: toastTitle, subTitle: toastMessage, custom: .custom(backgroundColor: Color("WhiteColor"), titleColor: Color("BlackColor"), subTitleColor: Color("BlackColor"), titleFont: Font.custom("Montserrat-Regular", size: 15.0),  subTitleFont: Font.custom("Montserrat-Regular", size: 12.0)))
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
            loader.loadMore(post: post, numberOfComments: 6, currentId: -1)
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
        
        
        var avatar: String
        
        var votesDictionary: VotesContainer
        
        @State private var scrollViewContentSize: CGSize = .zero
        
        init(_post: Post, _avatar: String, _votesDictionary: VotesContainer){
            post = _post
            avatar = _avatar
            votesDictionary = _votesDictionary
        }
        
        var body: some View {
            
            VStack{
                
                ZStack{
                    HStack{
                        Image(avatar)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 45)
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
                                .padding(.top, -35)
                        }
                        
                    }
                    
                }
                .padding([.top, .leading, .trailing], 0)
                
                HStack {
                    ScrollView(.vertical, showsIndicators: false) {
                        Text(post.message)
                            .font(.custom("Montserrat", size: 15))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            GeometryReader { geo -> Color in
                                DispatchQueue.main.async {
                                    scrollViewContentSize = geo.size
                                }
                                return Color.clear
                            }
                        )
                    }
                    .frame(
                        maxHeight: scrollViewContentSize.height
                    )
                }
                .padding(.horizontal, 0)
                
                HStack{
                    
                    VotesBlock(_post: post, _apis: APIs(), _voted: votesDictionary.getVote(postId: post.id), _votesContainer: votesDictionary)
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
                                .foregroundColor(Color("BlackColor"))

                            Spacer()
                        }
                        
                        HStack{
                            
                            Text(comment.message)
                            
                                .font(.custom("Montserrat", size: 14))
                                .frame(alignment: .leading)
                                .foregroundColor(Color("BlackColor"))

                            Spacer()
                        }
                        
                    }
                    .foregroundColor(Color("BlackColor"))
                    Spacer()
                    
                }
                
            }
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

                var com = Comment(id: -1, author: "", message: "", ban: false)
                
                let whatToPost = comment
                
                if (loader.contract.loaded == true) {
    
                    /// Get data at a background thread
                    DispatchQueue.global(qos: .userInitiated).async { [] in
                        
                        showToast = true
                        
                        let currentNumber = UserDefaults.standard.integer(forKey: "dVoxCommentedPosts")
                        UserDefaults.standard.set((currentNumber + 1), forKey: "dVoxCommentedPosts")
                        
                        loader.contract.addComment(postID: postID, author: usernameString ?? "Hacker", message: whatToPost)
                                
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
