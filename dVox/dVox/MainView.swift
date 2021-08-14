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


//var contract = SmartContract();

var adjectives = [String](arrayLiteral: "Sturdy",
                    "Loud",
                    "Delicious",
                    "Decorous",
                    "Pricey",
                    "Knowing",
                    "Scientific",
                    "Lazy",
                    "Fair",
                    "Loutish",
                    "Wonderful",
                    "Strict",
                    "Gaudy",
                    "Innocent",
                    "Horrible",
                    "Puzzled",
                    "Homeless",
                    "Happy",
                    "Grandiose",
                    "Observant",
                    "Pumped",
                    "Pale",
                    "Royal",
                    "Flawless",
                    "Actual",
                    "Realistic",
                    "Cynical",
                    "Clean",
                    "Strict",
                    "Super",
                    "Powerful",
                    "Mixed",
                    "Slim",
                    "Ubiquitous",
                    "Faithful",
                    "Amusing",
                    "Emotional",
                    "Staking",
                    "Former",
                    "Scarce",
                    "Tense",
                    "Black-and-white",
                    "Tangy",
                    "Wrong",
                    "Sloppy",
                    "Regular",
                    "Deafening",
                    "Savory",
                    "Sturdy",
                    "Classy",
                    "Third",
                    "Valuable",
                    "Outgoing",
                    "Free",
                    "Terrific",
                    "Sleepy",
                    "Adorable",
                    "Cozy")

var animals = [String](arrayLiteral: "Boar",
                   "Koala",
                   "Snake",
                   "Frog",
                   "Parrot",
                   "Lion",
                   "Pig",
                   "Rhino",
                   "Sloth",
                   "Horse",
                   "Sheep",
                   "Chameleon",
                   "Giraffe",
                   "Yak",
                   "Cat",
                   "Dog",
                   "Penguin",
                   "Elephant",
                   "Fox",
                   "Otter",
                   "Gorilla",
                   "Rabbit",
                   "Raccoon",
                   "Wolf",
                   "Panda",
                   "Goat",
                   "Chicken",
                   "Duck",
                   "Cow",
                   "Ray",
                   "Catfish",
                   "Ladybug",
                   "Dragonfly",
                   "Owl",
                   "Beaver",
                   "Alpaca",
                   "Mouse",
                   "Walrus",
                   "Kangaroo",
                   "Butterfly",
                   "Jellyfish",
                   "Deer",
                   "Beetle",
                   "Tiger",
                   "Pigeon",
                   "Bearded dragon",
                   "Bat",
                   "Hippo",
                   "Crocodile",
                   "Monkey")


struct MainView_Previews: PreviewProvider {
            static var previews: some View {
                MainView()
            }
        }


struct MainView: View {
    
    let apis = APIs()

    init(){
        apis.resetAPIs()
        apis.getAPIs()
    }
    
    @State var selection: Int = 0
    
    var body: some View {
            
            ZStack{
                       Color("BlackColor")
                           .ignoresSafeArea()
                       
                       VStack{
                           Color("BlackColor")
                               .edgesIgnoringSafeArea(.vertical)
                               .frame(height: 0)
                       
                           TabView(selection: $selection) {
                               HomeView(_apis: apis)
                                   .tag(0)
                                  
                               ComposeView(_apis: apis)
                                   .tag(1)
                                   .padding(.horizontal, 10)
                                   .padding(.bottom, 20)
                                   .background(Color("BlackColor"))
                                   
                               ProfileView()
                                   .tag(2)
                           }}
                           .overlay( // Overlay the custom TabView component here
                                       Color("WhiteColor") // Base color for Tab Bar
                                           .edgesIgnoringSafeArea(.vertical)
                                           .frame(height: 50) // Match Height of native bar
                                           .overlay(EdgeBorder(width: 1  , edges: [.top]).foregroundColor(Color("BlackColor")))                         .overlay(HStack {
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
                                    
                                })
                        ,alignment: .bottom) // Align the overlay to bottom to
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
    
    func randomNameGenerator() -> String {
        
        let randomAdjective = Int.random(in: 0..<adjectives.count)
        let randomAnimal = Int.random(in: 0..<animals.count)
        
        let randomName = adjectives[randomAdjective] + " " + animals[randomAnimal]
        
        return randomName
    }


