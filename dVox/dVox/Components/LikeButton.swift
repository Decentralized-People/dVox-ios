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
        HeartButton(filled: "filled", unfilled: "unfilled")
    }
}

struct HeartButton : View {
    @State var isLiked = false
    @State var scale : CGFloat = 1
    @State var opacity = 0.0
    let filled: String
    let unfilled: String
    
    
    var body: some View {
        VStack {
            ZStack {
                Image(filled)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                    .opacity(isLiked ? 1 : 0)
                    .animation(.linear)
                    
                Image(unfilled)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                
                CirclesView(isLiked: isLiked, radius: 10, speed: 0.1, scale: 0.7)
                            .opacity(self.opacity)
                  
                CirclesView(isLiked: isLiked, radius: 20, speed: 0.2, scale: 0.5)
                            .opacity(self.opacity)
                            .rotationEffect(Angle(degrees: 20))
            }.onTapGesture {
                self.isLiked.toggle()
                withAnimation (.linear(duration: 0.2)) {
                     self.opacity = self.opacity == 0 ? 1 : 0
                 }
                 withAnimation {
                     self.opacity = self.opacity == 0 ? 1 : 0
                 }
        }
       .scaleEffect(self.scale)
        
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
                     .frame(width: 10)
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
