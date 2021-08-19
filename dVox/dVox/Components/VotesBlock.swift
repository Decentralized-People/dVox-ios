//
//  LikeButton.swift
//  LikeButton
//
//  Created by Fatima Ortega on 8/17/21.
//

import Foundation
import SwiftUI

struct Preview : View {
    
    var body : some View {
        VotesBlock()
    }
}

struct VotesBlock : View {
    @State var isUpVoted = false
    @State var isDownVoted = false
    
    @State var scaleUp : CGFloat = 1
    @State var opacityUp = 0.0
    
    @State var scaleDown : CGFloat = 1
    @State var opacityDown = 0.0
    
    @State var upVote = 0;
    @State var downVote = 0;

    
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
                    } else {
                        self.upVote = 0
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
            
            Text(String(upVote))
                .font(.custom("Montserrat-Bold", size: 14))
                .frame( alignment: .leading)
                .padding([.bottom ], 20)
            
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
                    } else {
                        self.downVote = 0
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
            
            Text(String(downVote))
                .font(.custom("Montserrat-Bold", size: 14))
                .frame( alignment: .leading)
                .padding([.bottom ], 20)
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
