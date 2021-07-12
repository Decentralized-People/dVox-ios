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

struct MainView: View {
    
    var body: some View {
        
    Text("Welcome " + randomNameGenerator())
            
    }
    


struct MainView_Previews: PreviewProvider {
            static var previews: some View {
                MainView()
                    
            }
        }
    
    func randomNameGenerator() -> String {
        
        let randomAdjective = Int.random(in: 0..<adjectives.count)
        let randomAnimal = Int.random(in: 0..<animals.count)
        
        let randomName = adjectives[randomAdjective] + " " + animals[randomAnimal]
        
        return randomName
    }
}
