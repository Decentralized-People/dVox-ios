//
//  CommentView.swift
//  dVox
//
//  Created by Aleksandr Molchagin on 8/14/21.
//

import SwiftUI

import NavigationStack

struct CommentView: View {
    
    var post: Post
    
    var numberOfCommentsToLoad = 6
    
    @State var comment = ""
    
    
    var apis: APIs

    
    //@ObservedObject var loader = CommentLoader()

    
    var comments = [
        Comment(id: 1, author: "@Lazy_snake_9", message: "Hello brother!", ban: false),
        Comment(id: 1, author: "@Black_and_white_snake_23", message: "I totally agree, but why this or not this?", ban: false),
        Comment(id: 1, author: "@Cozy_snake_85", message: "Aliqua in laboris commodo nisi aute tempor dolor nulla. Laboris deserunt deserunt occaecat cupidatat. Deserunt velit ullamco nisi deserunt sint reprehenderit ea. Proident deserunt irure culpa ea ad dolor magna aute aliquip ullamco.", ban: false),
        Comment(id: 1, author: "author", message: "message", ban: false),
        Comment(id: 1, author: "author", message: "message", ban: false),
    ]
    
    @State var nextIndex: Int
    
    var username: Username
    
    init(_apis: APIs, _username: Username, _post: Post ){
        apis = _apis
        username = _username
        post = _post
        nextIndex = 1
        //loader.getComments(index: 0, apis: _apis, postId: _post.id, currentId: -1, getComments: numberOfCommentsToLoad)
    }
    
    var body: some View {
        
        ZStack{
            Color("BlackColor")
                .ignoresSafeArea()
            
            VStack {
                ZStack{
                    
                    Color("WhiteColor")
                    
                    VStack{
                                
                        CommentPost(_post: post)

                        Divider()
                        
                        ScrollView {
                            LazyVStack{
                                ForEach(comments.indices, id: \.self) { index in
                                    let comment = comments[index]
                                    //CardRow(eachComment: comment)
                                    CommentItem(_comment: comment)
                                        .onAppear{
                                            print("Index \(index), nTl \(numberOfCommentsToLoad)")
                                            if index == (numberOfCommentsToLoad*nextIndex) - 2{
                                            //loader.getComments(index: index, apis: apis, postId: post.id, currentId: comment.id, getComments: numberOfCommentsToLoad)
                                            }
                                        }
                                }
                                .padding([.bottom], 10)
                            }
                        }
                        
                        Spacer()
                        
                        Divider()
                        
                        HStack{
                            
                            VStack{
                               
                                TextField("Comment as \(username.getUsernameString())", text: $comment)
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
                                    .foregroundColor(Color("BlackColor"))
                                    .padding(.trailing, 5)
                                    .padding(.top, 15)
                                    .frame(alignment: .trailing)
                                    .font(.custom("Montserrat-Bold", size: 20))
                            }
                        }
                    }
                }
                .padding(.bottom, 30)
                .padding(.top, 30)
                .padding(.horizontal, 20)
                .background(RoundedCorners(tl: 20, tr: 20, bl: 20, br: 20).fill(Color("WhiteColor")))
            }
            .padding(.bottom, 40)
            .padding(.top, 40)
            .padding(.horizontal, 10)
            
        }
    }
    
    struct CommentPost: View {
        
        var post: Post
        
        init(_post: Post){
            post = _post
        }
        
        var body: some View {
            
            VStack{
                
                ZStack{
                    HStack{
                        Image("@avatar_snake")
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
                    
                    Button(action: {
                        
                    })
                    {
                        Image("fi-rr-thumbs-up")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20)
                            .padding([.leading], 0)
                    }
                    .frame(alignment: .leading)
                    .padding([.bottom], 20)
                    
                    Text(String(post.upVotes))
                        .font(.custom("Montserrat-Bold", size: 14))
                        .frame( alignment: .leading)
                        .padding([.bottom ], 20)
                    
                    Button(action: {
                        
                    })
                    {
                        Image("fi-rr-thumbs-down")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20)
                            .padding([.leading], 5)
                    }
                    .frame(alignment: .leading)
                    .padding([.bottom ], 20)
                    
                    
                    Text(String(post.downVotes))
                        .font(.custom("Montserrat-Bold", size: 14))
                        .frame( alignment: .leading)
                        .padding([.bottom ], 20)
                    
                    Button(action: {
                        
                    })
                    {
                        Image("fi-rr-comment")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20)
                            .padding([.leading], 5)
                    }
                    
                    .frame(alignment: .leading)
                    .padding([.bottom], 20)
                    
                    Text(String(post.commentsNumber))
                        .font(.custom("Montserrat-Bold", size: 14))
                        .frame( alignment: .leading)
                        .padding([.bottom ], 20)
                    
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
        
        init(_comment: Comment){
            comment = _comment
        }
        
        var body: some View {
            
            VStack{
                
                HStack{
                    VStack{
                        Image("@avatar_snake")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30)
                            .padding(.top, 5)
                            .padding(.trailing, 5)
                            
                        Spacer()
                    }
                    
                    VStack{
                 
                        HStack{
                            
                            Text(comment.author)
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
            CommentView(_apis: APIs(), _username: Username(), _post: Post(id: 1, title: "This is the title", author: "@Lazy_snake_1", message: "Ullamco nulla reprehenderit fugiat pariatur. Aliqua in laboris commodo nisi aute tempor dolor nulla. Laboris deserunt deserunt occaecat cupidatat. Deserunt velit ullamco nisi deserunt sint reprehenderit ea. Proident deserunt irure culpa ea ad dolor magna aute aliquip ullamco. Laboris deserunt nisi amet elit velit dolor laboris aute. Adipisicing do velit cillum fugiat nostrud et veniam laboris laboris velit ut dolor ad.", hastag: "#physicstalk", upVotes: 10, downVotes: 4, commentsNumber: 7, ban: false))
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
            Timer.scheduledTimer(withTimeInterval: 0, repeats: true) { timer in
                let add = apis.retriveKey(for: "ContractAddress") ?? "error"
                let inf = apis.retriveKey(for: "InfuraURL") ?? "error"
                let cre = apis.retriveKey(for: "Credentials") ?? "error"
                
                if (add != "error" && inf != "error" && cre != "error") {
                    let contract = SmartContract(credentials: cre, infura: inf, address: add)
                    
                    contract.addComment(postID: postID, author: username.getUsernameString(), message: comment)
    
                    comment = ""
                    
                    timer.invalidate()
                }
            }
        }
    }
    
}

