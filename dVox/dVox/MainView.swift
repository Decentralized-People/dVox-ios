//
//  Chat.swift
//  dVox
// https://trailingclosure.com/custom-tabbar/
//  Created by Fatima Ortega on 7/7/21.
//

import Foundation
import SwiftUI
import UIKit
import MessageUI

import NavigationStack

//var contract = SmartContract();




struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}


struct MainView: View {
    
    let apis = APIs()
    
    let username = Username()
    
    let codeDM = PersistenceController()
        
    let votesDictionary = VotesContainer()
    
    @StateObject var loader: PostLoader2 = PostLoader2(_contract: SmartContract())
    
    @StateObject var commentsLoader: CommentLoader = CommentLoader(_contract: SmartContract())
        
    init(){
        //apis.resetAPIs()
        //apis.getAPIs()
        username.retriveUsername(firstRun: true)
    }
    
    @State var selection: Int = 0
    
    
    var body: some View {
        
        ZStack{
            
            Color("BlackColor")
                .ignoresSafeArea()
            
            
            NavigationStackView(transitionType: .default){
                ZStack{
                    
                    Color("BlackColor")
                        .ignoresSafeArea()
                    
                    VStack{
                        Color("BlackColor")
                            .edgesIgnoringSafeArea(.vertical)
                            .frame(height: 0)
                        
                        TabView(selection: $selection) {
                            HomeView2(_apis: apis, _username: username, _loader: loader, _commentsLoader: commentsLoader)
                                .preferredColorScheme(.light)
                                .background(Color("BlackColor"))
                                .tag(0)

                            
                            ComposeView(_apis: apis, _username: username)
                                .tag(1)
                                .padding(.horizontal, 10)
                                .padding(.bottom, 20)
                                .preferredColorScheme(.light)
                                .background(Color("BlackColor"))
                            
                            ProfileView(_apis: apis, _username: username)
                                .tag(2)
                                .padding(.horizontal, 10)
                                .padding(.bottom, 20)
                                .preferredColorScheme(.light)
                                .background(Color("BlackColor"))

                        }
                        
                    }
                    .overlay( // Overlay the custom TabView component here
                        Color("WhiteColor") // Base color for Tab Bar
                            .edgesIgnoringSafeArea(.vertical)
                            .frame(height: 50) // Match Height of native bar
                            .overlay(EdgeBorder(width: 1  , edges: [.top]).foregroundColor(Color("BlackColor")))
                            .overlay(HStack {
                        Spacer()
                        
                        // First Tab Button
                        Button(action: {
                            self.selection = 0
                        }, label: {
                            Image("fi-rr-home")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25, alignment: .center)
                                .foregroundColor(Color(red: 32/255, green: 43/255, blue: 63/255))
                                .opacity(selection == 0 ? 1 : 0.4)
                        })
                        Spacer()
                        
                        // Second Tab Button
                        Button(action: {
                            self.selection = 1
                        }, label: {
                            Image("fi-rr-add")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25, alignment: .center)
                                .foregroundColor(Color(red: 32/255, green: 43/255, blue: 63/255))
                                .opacity(selection == 1 ? 1 : 0.4)
                        })
                        
                        Spacer()
                        
                        // Third Tab Button
                        Button(action: {
                            self.selection = 2
                        }, label: {
                            Image("fi-rr-user")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25, alignment: .center)
                                .foregroundColor(Color(red: 32/255, green: 43/255, blue: 63/255))
                                .opacity(selection == 2 ? 1 : 0.4)
                        })
                        Spacer()
                    }) ,alignment: .bottom)
                    
                    
                }
                
            }
        }
    }
        
}

struct EdgeBorder: Shape {
    
    var width: CGFloat
    var edges: [Edge]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }
            
            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }
            
            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return self.width
                }
            }
            
            var h: CGFloat {
                switch edge {
                case .top, .bottom: return self.width
                case .leading, .trailing: return rect.height
                }
            }
            path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
        }
        return path
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
//    func randomNameGenerator() -> String {
//
//        let randomAdjective = Int.random(in: 0..<adjectives.count)
//        let randomAnimal = Int.random(in: 0..<animals.count)
//
//        let randomName = adjectives[randomAdjective] + " " + animals[randomAnimal]
//
//        return randomName
//    }


