//
//  Chat.swift
//  dVox
//
//  Created by Fatima Ortega on 7/7/21.
//

import Foundation
import SwiftUI
import UIKit
import MessageUI


var contract = SmartContract();

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
    
    var body: some View {
        
        TabView {
            
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            ComposeView()
                .tabItem {
                    Image(systemName: "plus.circle")
                    Text("Compose")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
            
        }
    }
    
    
    struct HomeView: View {
        var body: some View {
            NavigationView {
                ZStack {
                    Form {
                        Button(action: {
                            //Getting post by ID
                            contract.getPost(id: contract.getPostCount())
                            
                            
                        }, label: {
                            Text("Get The Last Post")
                                .frame(width: 250, height: 50, alignment: .center)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        })
                        
                    Button(action: {
                        //Getting post by ID
                        contract.getPost(id: 11)
                        
                        
                    }, label: {
                        Text("Get Post")
                            .frame(width: 250, height: 50, alignment: .center)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    })
                    
                    Button(action: {
                        //Up vote
                            contract.addVote(id: 11, vote: 1)
                        
                    }, label: {
                        Text("Upvote")
                            .frame(width: 250, height: 50, alignment: .center)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    })
                    
                    Button(action: {
                        //Down vote
                            contract.addVote(id: 11, vote: -1)
                        
                    }, label: {
                        Text("Downvote")
                            .frame(width: 250, height: 50, alignment: .center)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    })
                    }

                }
                .navigationTitle("Home")
                
//                Text("Welcome " + randomNameGenerator())  //Cannot use RNG here >:-(
            }
        }
    }
    
    
    
    struct ComposeView: View {
        
        @State var title = ""
        @State var hashtag = ""
        @State var message = ""
        
        
        var body: some View {
            NavigationView {
                VStack {
                    Form{
                        Section{
                            TextField("Title", text: $title)
                            TextField("Hashtag", text: $hashtag)
                            TextField("Message", text: $message)
                            
                        }
                    }
                        
                            Button(action: {
                                //Create Post
                                
                                contract.createPost(title: title, author: "Revaz", message: message, hashtag: hashtag)
                    
                                
                                
                            }, label: {
                                Text("Create Post")
                                    .frame(width: 250, height: 50, alignment: .center)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            })
                        
                    
                }
                .navigationTitle("Compose")
            }
        }
    }
    
    
    
    struct ProfileView: View {
        var body: some View {
            NavigationView {
                ZStack {
                    Color.blue
                }
                .navigationTitle("Profile")
            }
        }
    }
    
    
    func randomNameGenerator() -> String {
        
        let randomAdjective = Int.random(in: 0..<adjectives.count)
        let randomAnimal = Int.random(in: 0..<animals.count)
        
        let randomName = adjectives[randomAdjective] + " " + animals[randomAnimal]
        
        return randomName
    }
    
    
}
