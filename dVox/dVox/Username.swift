
//
//  Username.swift
//  Comment
//
//

import Foundation
import SwiftUI
import Firebase

class Username {
    var animal: String
    var adjective: String
    var number: Int
    
    init(animal: String, adjective: String, number: Int) {
        self.animal = animal
        self.adjective = adjective
        self.number = number
    }

    func randomNameGenerator() -> Username {
        
        let animals: [String] =
        ["Boar", "Koala", "Snake", "Frog", "Parrot", "Lion", "Pig", "Rhino", "Sloth", "Horse", "Sheep", "Chameleon", "Giraffe", "Yak", "Cat", "Dog", "Penguin", "Elephant", "Fox", "Otter", "Gorilla", "Rabbit", "Raccoon", "Wolf", "Panda", "Goat", "Chicken", "Duck", "Cow", "Ray", "Catfish", "Ladybug", "Dragonfly", "Owl", "Beaver", "Alpaca", "Mouse", "Walrus", "Kangaroo", "Butterfly", "Jellyfish", "Deer", "Beetle", "Tiger", "Pigeon", "Bearded_Dragon", "Bat", "Hippo", "Crocodile", "Monkey"]
        
        let adjectives: [String] = [ "Sturdy", "Loud", "Delicious", "Decorous", "Pricey", "Knowing", "Scientific", "Lazy", "Fair", "Loutish", "Wonderful", "Strict", "Gaudy", "Innocent", "Horrible", "Puzzled", "Happy", "Grandiose", "Observant", "Pumped", "Pale", "Royal", "Flawless", "Actual", "Realistic", "Cynical", "Clean", "Strict", "Super", "Powerful", "Mixed", "Slim", "Ubiquitous", "Faithful", "Amusing", "Emotional", "Staking", "Former", "Scarce", "Tense", "Black-and-white", "Tangy", "Wrong", "Sloppy", "Regular", "Deafening", "Savory", "Classy", "First", "Second", "Third", "Valuable", "Outgoing", "Free", "Terrific", "Sleepy", "Adorable", "Cozy"]
        
        
        let randomAdjective = Int.random(in: 0..<adjectives.count)
        let randomAnimal = Int.random(in: 0..<animals.count)
        let randomNumber = Int.random(in: 1..<100)
        
        let randomName = "@" + adjectives[randomAdjective] + "_" + animals[randomAnimal] + "_" + String(randomNumber)
        
        
        return Username(animal: animals[randomAnimal], adjective: adjectives[randomAdjective], number: randomNumber)
    }
    
    func regenerate() -> Username {
            
        var username: Username = Username(animal: "none", adjective: "none", number: 0)
        
        username = username.randomNameGenerator()
                
        let group = DispatchGroup()
        
        group.enter()
        
        DispatchQueue.main.async {
            
            let Doc = Firestore.firestore().collection("Nicknames").document(username.animal)
            
            Doc.getDocument{ [self] (document, error) in
                
                if let document = document, document.exists{
                    
                    let field = username.adjective + "_" + String(username.number)
                    
                    
                    //randomNumber = Int.random(in: 1..<10)
                    
                    
                    let animalExist = document.get(String(field))
                    
                    if animalExist == nil{
                        print("we can create it!")
                        Doc.updateData([
                            field: true
                        ])
                    }
                    else {
                        print("name exists! trying again...")
                        username = regenerate()
                        
                    }
                    group.leave()
                } else {
                    print("The document doesn't exist.")
                    username = Username(animal: "Try", adjective: "Again", number: 404)
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) {
           print("Username is here!")
        }
        
        return username
    }
    
}
