//
//  ProfileView.swift
//  dVox
//
//  Created by Aleksandr Molchagin on 8/15/21.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ZStack{
            Color("BlackColor")
                .ignoresSafeArea()
            
            VStack {
                ZStack{
                    
                    Color("WhiteColor")
                    
                    VStack{
                        HStack{
                            Text("Your Profile")
                                .font(.custom("Montserrat-Bold", size: 30))
                            Spacer()
                        }
                        HStack{
                            Image("003-snake")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80)
                                .padding([.trailing], 10)
                            VStack{
                                
                
                                
                            Text("@Lazy_snake_1") .font(.custom("Montserrat-Bold", size: 25))
                                .frame(alignment: .bottom)
                          
                            }
                            Spacer()
                        }
                        .padding([.top, .bottom], 10)
                        
                        Divider()
                        
                        HStack{
                            Text("Statistics")
                                .font(.custom("Montserrat-Bold", size: 30))
                                .padding(.top, 10)
                            Spacer()
                        }
                        
                        HStack{
                            Text("Posts created: 0")
                                .font(.custom("Montserrat", size: 20))
                                .padding(.top, 10)
                            Spacer()
                        }
                        
                        HStack{
                            Text("Posts upvoted: 0")
                                .font(.custom("Montserrat", size: 20))
                                .padding(.top, 10)
                            Spacer()
                        }
                        
                        HStack{
                            Text("Posts downvoted: 0")
                                .font(.custom("Montserrat", size: 20))
                                .padding(.top, 10)
                            Spacer()
                        }
                        
                        HStack{
                            Text("Comments created: 0")
                                .font(.custom("Montserrat", size: 20))
                                .padding(.top, 10)
                            Spacer()
                        }
                        
                        Spacer()
                        
                        Button(action: {
                        })
                        {
                            (Text("Regenerate Profile")
                                .padding([.leading, .bottom, .trailing], 20))
                                .foregroundColor(Color("BlackColor"))
                                .font(.custom("Montserrat-Bold", size: 20))
                                .minimumScaleFactor(0.01)
                                .lineLimit(3)
                                .padding(.top, 20)
                        }
                    }
                    
                }
            }
            .padding(20)
            .background(RoundedCorners(tl: 20, tr: 20, bl: 20, br: 20).fill(Color("WhiteColor")))
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
