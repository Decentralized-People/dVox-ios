//
//  HomeView.swift
//  HomeView
//
//  Created by Revaz Bakuradze on 03.08.21.
//

import Foundation
import SwiftUI

//let numberOfPostss = contract.getPostCount()
      

struct HomeView: View {
    
    var apis: APIs
    
    var posts = [
        Post(id: 1, title: "This is the title", author: "@Lazy_snake_1", message: "Ullamco nulla reprehenderit fugiat pariatur. Aliqua in laboris commodo nisi aute tempor dolor nulla. Laboris deserunt deserunt occaecat cupidatat. Deserunt velit ullamco nisi deserunt sint reprehenderit ea. Proident deserunt irure culpa ea ad dolor magna aute aliquip ullamco. Laboris deserunt nisi amet elit velit dolor laboris aute. Adipisicing do velit cillum fugiat nostrud et veniam laboris laboris velit ut dolor ad.", hastag: "#physicstalk", votes: -1),
        Post(id: 2, title: "It's time for physics!", author: "@Crazy_snake_95", message: " Aliqua in laboris commodo nisi aute tempor dolor nulla. Laboris deserunt deserunt occaecat cupidatat.Adipisicing do velit cillum fugiat nostrud et veniam laboris laboris velit ut dolor ad.", hastag: "#letsgopeople", votes: -1),
    ]
    
    @ObservedObject var loader = PostLoader()
    @State var nextIndex: Int
    
    var numberOfPostsToLoad = 6
    
    init(_apis: APIs){
        nextIndex = 1
        apis = _apis
        loader.getPosts(index: 0, apis: apis, currentId: -1, getPosts: numberOfPostsToLoad)
    }

    var body: some View {
        
            ZStack {
                Color("BlackColor")
                    .ignoresSafeArea()
                
                ZStack{
                    Color("BlackColor")
                        .ignoresSafeArea()
                    
                    ScrollView {
                        LazyVStack{
                            ForEach(loader.allPosts_.indices, id: \.self) { index in
                                let post = loader.allPosts_[index]
                                CardRow(eachPost: post)
                                    .onAppear{
                                        print("Index \(index), nTl \(numberOfPostsToLoad)")
                                        if index == (numberOfPostsToLoad*nextIndex) - 2{

                                            loader.getPosts(index: nextIndex, apis: apis, currentId: post.id, getPosts: numberOfPostsToLoad)
                                            nextIndex += 1
                                        }
                                    }
                            }
                            .padding([.bottom], 10)
                        }
                    }
                }
            }
    }

    struct CardRow: View {
        var eachPost: Post
        var body: some View {
            ZStack{
                
                VStack{
                    HStack{
                        Image("003-snake")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 45)
                            .padding([.trailing], 5)
                            
                        VStack{
                            Text(eachPost.title)
                                .font(.custom("Montserrat-Bold", size: 20))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(eachPost.author)
                                .font(.custom("Montserrat", size: 14))

                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding([.top, .leading, .trailing], 20)
                    HStack{
                        Text(eachPost.message)
                            .font(.custom("Montserrat", size: 15))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 20.0)
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
                        .padding([.leading, .bottom], 20)
                         
                        Text(String(eachPost.upVotes))
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

                        
                        Text(String(eachPost.downVotes))
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
                        
                        Text(String(eachPost.commentsNumber))
                            .font(.custom("Montserrat-Bold", size: 14))
                            .frame( alignment: .leading)
                            .padding([.bottom ], 20)
                        
                        Text(eachPost.hastag)
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
        
    struct HomeView_Previews: PreviewProvider {
            static var previews: some View {
                var apis = APIs()
                HomeView(_apis: apis)
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
    }
}
