//
//  ComposeView.swift
//  ComposeView
//
//  Created by Revaz Bakuradze on 03.08.21.
//

import Foundation
import SwiftUI

struct ComposeView: View {
    
    @State var title = ""
    @State var hashtag = ""
    @State var message = ""
    
    var apis: APIs
    
    init(_apis: APIs){
        apis = _apis
    }
    
    var body: some View {
        ZStack{
            Color("BlackColor")
                .ignoresSafeArea()
            
            VStack {
                ZStack{
                
                    Color("WhiteColor")

                    VStack{
                    
                        TextField("Title", text: $title)
                        TextField("Hashtag", text: $hashtag)
                        TextField("Message", text: $message)
                        
                        Spacer()
                        
                        Button(action: {
                            //Create Post
                            createPost();
                            
                            
                        })
                        {
                            Text("Create Post")
                                .frame(width: 250, height: 50, alignment: .center)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                }
                .padding([.top, .leading, .trailing], 20)
                .background(RoundedCorners(tl: 20, tr: 20, bl: 20, br: 20).fill(Color("WhiteColor")))
              

            }
        }
    }
    
    struct ComposeView_Previews: PreviewProvider {
            static var previews: some View {
                var apis = APIs()
                ComposeView(_apis: apis)
            }
    }
         
    
    
    func createPost() {
         Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { timer in
            let add = apis.retriveKey(for: "ContractAddress") ?? "error"
            let inf = apis.retriveKey(for: "InfuraURL") ?? "error"
            let cre = apis.retriveKey(for: "Credentials") ?? "error"
             
             if (add != "error" && inf != "error" && cre != "error") {
                 let contract = SmartContract(credentials: cre, infura: inf, address: add)
                 contract.createPost(title: title, author: "Aleksandr", message: message, hashtag: hashtag)
                 timer.invalidate()
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
