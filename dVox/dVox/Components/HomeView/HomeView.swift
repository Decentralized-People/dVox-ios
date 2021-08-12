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
    
    @ObservedObject var sot = SourceOfTruth()
    @State var nextIndex = 1
    
    
    @State var allPosts = [
        Post(id: 1, title: "Why why why", author: "Aleksandr", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag1", votes: 1),
        
        Post(id: 2, title: "Hello world", author: "Revaz", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag2", votes: 0),
        
        Post(id: 3, title: "Hello there", author: "David", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag3", votes: -10),
        
        Post(id: 4, title: "hello w o r l d", author: "Fatima", message: "Welcome to the app! I believe everyone should have an opportunity to share their own thoughts privately. This is why me and my friends developed this platform.", hastag: "#hashtag4", votes: 4)
    ]
    
    init(_apis: APIs){
        apis = _apis
        sot.getPosts(index: 0)
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
                            ForEach(sot.allPosts_.indices, id: \.self) { index in
                                let post = sot.allPosts_[index]
                                CardRow(eachPost: post)
                                    .onAppear{
                                        if index == sot.allPosts_.count - 2{
                                            sot.getPosts(index: nextIndex)
                                            nextIndex += 1
                                        }
                                    }
                            }
                            .padding(10)
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
                            .frame(width: 60)
                            .padding([.top, .leading, .trailing], 10)
                        VStack{
                            Text(eachPost.title)
                                .font(.custom("Montserrat", size: 16))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(eachPost.author)
                                .font(.custom("Montserrat", size: 14))
                                .padding(.top, 1)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(10)
                    HStack{
                        Text(eachPost.message)
                            .font(.custom("Montserrat", size: 16))
                    }
                    .padding(10)
                    HStack{
                        
                        Text(eachPost.hastag)
                            .font(.custom("Montserrat", size: 14))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding([.bottom, .trailing], 10)
                    }
                    .padding(10)
                }
                
                    .background(RoundedCorners(tl: 20, tr: 20, bl: 20, br: 20).fill(Color("WhiteColor")))

                    .foregroundColor(Color("BlackColor"))
                    .padding(.horizontal, 10)
                
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

    
    func que() {
         Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { timer in
            let add = apis.retriveKey(for: "ContractAddress") ?? "error"
            let inf = apis.retriveKey(for: "InfuraURL") ?? "error"
            let cre = apis.retriveKey(for: "Credentials") ?? "error"
             
             if (add != "error" && inf != "error" && cre != "error") {
                 let contract = SmartContract(credentials: cre, infura: inf, address: add)
                 
                 let postCount = contract.getPostCount()
                 
                 for i in stride(from: postCount, to: postCount - 5, by: -1) {
                     let Post = contract.getPost(id: i)
                     allPosts.append(Post)
                     print("Post \(i)")
                 }
                
                 timer.invalidate()
             }
         }
    }
}
