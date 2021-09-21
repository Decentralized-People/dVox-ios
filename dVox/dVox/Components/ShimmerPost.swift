//
//  ProfileView.swift
//  dVox
//
//  Created by Aleksandr Molchagin on 8/14/21.
//
import SwiftUI
import UIKit



struct ShimmerPost: View {
    
    @State var animation = false

    var body: some View {
        
        VStack{
            ZStack{
                ShimmerPostItem()
                    .opacity(0.9)

                ShimmerPostItem()
                    .opacity(1)
             
                .mask(
                    Rectangle()
                        .fill(LinearGradient(gradient: .init(colors: [Color.white.opacity(0.5),Color.black,Color.black.opacity(0.75)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .rotationEffect(.init(degrees: 130))
                        .padding(20)
                    //Moves the view to create shimmer effect
                        .offset(x: -250)
                        .offset(x: animation ? 600 : -100)
                )
                .onAppear(perform: {
                    
                    withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)){
                        animation.toggle()
                    }
                })
             
            }
        }
        .background(RoundedCorners(tl: 20, tr: 20, bl: 20, br: 20).fill(Color("WhiteColor")))
        .foregroundColor(Color("BlackColor"))
        .padding(.horizontal, 10)
    }
    
    
    struct Shimmer_Previews: PreviewProvider {
            
        static var previews: some View {
            ShimmerPost()
        }
    }
    
    struct TextShimmer: View {
        var text: String
        @State var animation = false
        
        var body: some View{
    
            ZStack{
                Text(text)
                    .font(.system(size: 75, weight: .bold))
                    .foregroundColor(Color.black.opacity(0.25))
                
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
                        .fill(LinearGradient(gradient: .init(colors: [Color.white.opacity(0.5),Color.black,Color.black.opacity(0.5)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .rotationEffect(.init(degrees: 120))
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
    
    struct ShimmerPostItem: View{
        
        var body: some View {
            ZStack{
                VStack{
                    HStack{
                        Image("black-square")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 45)
                            .padding([.trailing], 5)
                            .opacity(0.07)
                        
                        VStack{
                            Text("█████████")
                                .font(.custom("Montserrat-Bold", size: 12))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .opacity(0.07)
                                .padding(.bottom, 3)
                            
                            Text("█████████")
                                .font(.custom("Montserrat-Bold", size: 8))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .opacity(0.07)
                            
                        }
                    }
                    .padding([.top, .leading, .trailing], 20)
                    VStack{
                        Text("████████████████████████████████████")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .opacity(0.07)
                            .font(.custom("Montserrat", size: 20))
                            .minimumScaleFactor(0.01)
                            .lineLimit(1)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, 3)

                        
                        Text("████████████████████████████████████")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .opacity(0.07)
                            .font(.custom("Montserrat", size: 20))
                            .minimumScaleFactor(0.01)
                            .lineLimit(1)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, 3)
                        Text("████████████████████████████████████")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .opacity(0.07)
                            .font(.custom("Montserrat", size: 20))
                            .minimumScaleFactor(0.01)
                            .lineLimit(1)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, 3)

                        
                        Text("████████████████████████████████████")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .opacity(0.07)
                            .font(.custom("Montserrat", size: 20))
                            .minimumScaleFactor(0.01)
                            .lineLimit(1)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, 3)

                        
                    }
                    .padding(.horizontal, 20.0)
                    HStack{
                        Image("fi-rr-thumbs-up")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20)
                            .padding([.leading], 0)
                            .frame(alignment: .leading)
                            .padding([.leading, .bottom], 20)
                            .opacity(0.07)
                        Text(" ")
                            .font(.custom("Montserrat-Bold", size: 14))
                            .frame( alignment: .leading)
                            .padding([.bottom ], 20)
                        Image("fi-rr-thumbs-down")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20)
                            .padding([.leading], 5)
                            .frame(alignment: .leading)
                            .padding([.bottom ], 20)
                            .opacity(0.07)

                        Text(String(" "))
                            .font(.custom("Montserrat-Bold", size: 14))
                            .frame( alignment: .leading)
                            .padding([.bottom ], 20)
                        Image("fi-rr-comment")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20)
                            .padding([.leading], 5)
                            .frame(alignment: .leading)
                            .padding([.bottom], 20)
                            .opacity(0.07)

                        Text(" ")
                            .font(.custom("Montserrat-Bold", size: 14))
                            .frame( alignment: .leading)
                            .padding([.bottom ], 20)
                        
                        Text("██████")
                            .font(.custom("Montserrat-Bold", size: 12))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.bottom, 20)
                            .padding(.trailing, 20)
                            .opacity(0.07)
                            .lineLimit(1)

                    }
                }
            }
            
        }
           // .background(RoundedCorners(tl: 20, tr: 20, bl: 20, br: 20).fill(Color("WhiteColor")))
            //.foregroundColor(Color("BlackColor"))
            //.padding(.horizontal, 10)
        

    }
//    struct RoundedCorners: Shape {
//        var tl: CGFloat = 0.0
//        var tr: CGFloat = 0.0
//        var bl: CGFloat = 0.0
//        var br: CGFloat = 0.0
//        
//        func path(in rect: CGRect) -> Path {
//            var path = Path()
//            
//            let w = rect.size.width
//            let h = rect.size.height
//            
//            // Make sure we do not exceed the size of the rectangle
//            let tr = min(min(self.tr, h/2), w/2)
//            let tl = min(min(self.tl, h/2), w/2)
//            let bl = min(min(self.bl, h/2), w/2)
//            let br = min(min(self.br, h/2), w/2)
//            
//            path.move(to: CGPoint(x: w / 2.0, y: 0))
//            path.addLine(to: CGPoint(x: w - tr, y: 0))
//            path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr,
//                        startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
//            
//            path.addLine(to: CGPoint(x: w, y: h - br))
//            path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br,
//                        startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
//            
//            path.addLine(to: CGPoint(x: bl, y: h))
//            path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl,
//                        startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
//            
//            path.addLine(to: CGPoint(x: 0, y: tl))
//            path.addArc(center: CGPoint(x: tl, y: tl), radius: tl,
//                        startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
//            
//            return path
//        }
//    }

}
