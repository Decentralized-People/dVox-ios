//
//  ProfileView.swift
//  dVox
//
//  Created by Aleksandr Molchagin on 8/14/21.
//
import SwiftUI
import UIKit



struct ShimmerComment: View {
    
    @State var animation = false

    var body: some View {
        
        VStack{
            ZStack{
                ShimmerCommentItem()
                    .opacity(0.9)

                ShimmerCommentItem()
                    .opacity(1)
             
                .mask(
                    Rectangle()
                        .fill(LinearGradient(gradient: .init(colors: [Color.white.opacity(0.5),Color.black,Color.black.opacity(0.75)]), startPoint: .top, endPoint: .bottom))
                        .rotationEffect(.init(degrees: 130))
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
        .background(RoundedCorners(tl: 0, tr: 0, bl: 0, br: 0).fill(Color("WhiteColor")))
        .foregroundColor(Color("BlackColor"))
        .padding(.horizontal, 10)
    }
    
    
    struct ShimmerComment_Previews: PreviewProvider {
            
        static var previews: some View {
            ShimmerComment()
        }
    }
        
    struct ShimmerCommentItem: View{
        
        var body: some View {
            ZStack{
                VStack{
                    HStack{
                        Image("black-square")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30)
                            .padding(.top, 5)
                            .padding(.trailing, 5)
                            .opacity(0.07)
                        
                        VStack{
                            Text("█████████")
                                .font(.custom("Montserrat-Bold", size: 9))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .opacity(0.07)
                                .padding(.bottom, 1)
                                .padding(.top, 5)

                            
                         
                            
                            
                            Text("████████████████████████████████████")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .opacity(0.07)
                                .font(.custom("Montserrat", size: 20))
                                .minimumScaleFactor(0.01)
                                .lineLimit(1)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.bottom, 3)



                            
                        }
                    }
                    .padding(20)
            
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

}
