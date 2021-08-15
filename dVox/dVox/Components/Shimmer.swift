//
//  ProfileView.swift
//  dVox
//
//  Created by Aleksandr Molchagin on 8/14/21.
//
import SwiftUI
import UIKit



struct Shimmer: View {
    
    
    var body: some View {
        NavigationView {
        VStack(spacing: 25){
TextShimmer(text: "Shimmer")
            
        }
        //.preferredColorScheme(.dark)
       
       }
    }
}

struct Shimmer_Previews: PreviewProvider {
    static var previews: some View {
    
        Shimmer()
   }
}

struct TextShimmer: View {
    var text: String
    @State var animation = false
    
    var body: some View{
        ZStack{
            Text(text)
                .font(.system(size: 75, weight: .bold))
                .foregroundColor(Color.white.opacity(0.25))
            
            // Multicolor
            
            HStack(spacing: 0){
                ForEach(0..<text.count,id: \.self){index in
                    Text(String(text[text.index(text.startIndex, offsetBy: index)]))
                        .font(.system(size: 75, weight: .bold))
                       
                }
            }
            // Masking shimmer effect
            .mask(
            Rectangle()
                .fill(LinearGradient(gradient: .init(colors: [Color.white.opacity(0.5),Color.white,Color.white.opacity(0.5)]), startPoint: .top, endPoint: .bottom))
                .rotationEffect(.init(degrees: 70))
                .padding(20)
            //Moves the view to create shimmer effect
                .offset(x: -250)
                .offset(x: animation ? 500 : 0)
            )
            .onAppear(perform: {
                
                withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)){
                    animation.toggle()
                }
            })
        }
    }
 
}
