
//
//  Username.swift
//  Comment
//

import Foundation
import SwiftUI
import Firebase

class Username: ObservableObject {
    
    @Published var animal: String
    @Published var adjective: String
    @Published var number: Int
    
    @Published var oldAnimal = ""
    @Published var oldAdjective = ""
    @Published var oldNumber = 0
    
    init() {
        animal = "Retrieving"
        adjective = "The username"
        number = 0
    }
    
    func getAvatarString() -> String {
        return "@avatar_" + self.animal.lowercased()
    }
    
    func getUsernameString() -> String {
        if (animal == "Hacker") { 
            return animal
        }
        else {
        return self.adjective + "_" + self.animal + "_" + String(self.number)
        }
    }
    
    func stringToUsername(usernameString: String){
        
        let ch = Character("_")
        let array = usernameString.split(separator: ch)
        
        if (array.count == 3) {
            
            self.adjective = String(array[0])
            self.animal = String(array[1])
            self.number = Int(array[2]) ?? 0
            
        } else if (array.count == 4) {
            
            self.adjective = String(array[0])
            self.animal = String(array[1]) + "_" + String(array[2])
            self.number = Int(array[3]) ?? 0
            
        } else {
            self.animal = "Hacker"
            self.adjective = ""
            self.number = 0
        }
    }
    
    func retriveUsername(firstRun: Bool){
                
        if (UserDefaults.standard.string(forKey: "dvoxUsername") == nil ||
            UserDefaults.standard.string(forKey: "dvoxUsernameAvatar") == nil) {
            
            let group = DispatchGroup()
            
            group.enter()
            
            DispatchQueue.main.async {
                
                self.generateUsername(firstRun: firstRun)
                                
                let usernameString = self.getUsernameString()
                let avatarString = self.getAvatarString()

                UserDefaults.standard.set(usernameString, forKey: "dvoxUsername")
                UserDefaults.standard.set(avatarString, forKey: "dvoxUsernameAvatar")
                
                self.stringToUsername(usernameString: usernameString)

                group.leave()
                
            }
            
            group.notify(queue: .main) {
                
                if (UserDefaults.standard.string(forKey: "dvoxUsername") != nil ||
                    UserDefaults.standard.string(forKey: "dvoxUsernameAvatar") != nil) {
                    
                    print("The username is generated succesfully.")
            
                    
                } else {
                    
                    print("Error while getting a username.")
                    
                }
                
            }
            
        } else {
            self.stringToUsername(usernameString: UserDefaults.standard.string(forKey: "dvoxUsername") ?? "Getting_Name_Error")
            
            print("The username is retrived succesfully. (no generation)")
        }
    }

    func getNewUsername() {
        let animals: [String] =
        ["Boar", "Koala", "Snake", "Frog", "Parrot", "Lion", "Pig", "Rhino", "Sloth", "Horse", "Sheep", "Chameleon", "Giraffe", "Yak", "Cat", "Dog", "Penguin", "Elephant", "Fox", "Otter", "Gorilla", "Rabbit", "Raccoon", "Wolf", "Panda", "Goat", "Chicken", "Duck", "Cow", "Ray", "Catfish", "Ladybug", "Dragonfly", "Owl", "Beaver", "Alpaca", "Mouse", "Walrus", "Kangaroo", "Butterfly", "Jellyfish", "Deer", "Beetle", "Tiger", "Pigeon", "Bearded_Dragon", "Bat", "Hippo", "Crocodile", "Monkey"]
        
        let adjectives: [String] = [ "Sturdy", "Loud", "Delicious", "Decorous", "Pricey", "Knowing", "Scientific", "Lazy", "Fair", "Loutish", "Wonderful", "Strict", "Gaudy", "Innocent", "Horrible", "Puzzled", "Happy", "Grandiose", "Observant", "Pumped", "Pale", "Royal", "Flawless", "Actual", "Realistic", "Cynical", "Clean", "Strict", "Super", "Powerful", "Mixed", "Slim", "Ubiquitous", "Faithful", "Amusing", "Emotional", "Staking", "Former", "Scarce", "Tense", "Black-and-white", "Tangy", "Wrong", "Sloppy", "Regular", "Deafening", "Savory", "Classy", "First", "Second", "Third", "Valuable", "Outgoing", "Free", "Terrific", "Sleepy", "Adorable", "Cozy"]
        
        let randomAdjective = Int.random(in: 0..<adjectives.count)
        let randomAnimal = Int.random(in: 0..<animals.count)
        let randomNumber = Int.random(in: 1..<100)
        
        self.animal = animals[randomAnimal]
        self.adjective = adjectives[randomAdjective]
        self.number = randomNumber
    }
    
    func generateUsername(firstRun: Bool) -> Username {
                            
        self.getNewUsername()
                
                
        let group = DispatchGroup()
        
        group.enter()
        
        DispatchQueue.main.async {
            
            let Doc = Firestore.firestore().collection("Nicknames").document(self.animal)
            
            Doc.getDocument{ [self] (document, error) in
                
                if let document = document, document.exists{
                    
                    let field = self.adjective + "_" + String(self.number)
                
                    let animalExist = document.get(String(field))
                    
                    if animalExist == nil{
                        print("we can create it!")
                        if (firstRun == true) {
                            Doc.updateData([
                                field: true
                            ])
                        } else {
                            Doc.updateData([
                                field: false
                            ])
                        }
                    }
                    else {
                        print("name exists! trying again...")
                        let username = self.generateUsername(firstRun: firstRun)
                            
                        self.animal = username.animal
                        self.adjective = username.adjective
                        self.number = username.number
                    }
                    group.leave()
                } else {
                    print("The document doesn't exist.")
                    self.animal = "Try"
                    self.adjective = "Again"
                    self.number = 404
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) {
           print("Username is here!")
        }
        return self
    }
    
    func saveOldUsername(){
        self.oldAnimal = self.animal
        self.oldAdjective = self.adjective
        self.oldNumber = self.number
    }
    
    func usernameAbort(){
        let group = DispatchGroup()
        
        group.enter()
        
        DispatchQueue.main.async {
            
            let Doc = Firestore.firestore().collection("Nicknames").document(self.animal)
            
            Doc.getDocument{ [self] (document, error) in
                
                if let document = document, document.exists{
                
                
                    let field = self.adjective + "_" + String(self.number)
                                    
                    Doc.updateData([
                        field: FieldValue.delete()
                    ])
            
                    group.leave()
                    
                } else {
                    print("The document doesn't exist.")
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) {
            print("Username creation is aborted! \(self.oldAnimal)")
        }
        self.animal = self.oldAnimal
        self.adjective = self.oldAdjective
        self.number = self.oldNumber
    }
    
    func usernameConfirm(){
        
        let group = DispatchGroup()
        
        group.enter()
        
        DispatchQueue.main.async {
            
            let Doc = Firestore.firestore().collection("Nicknames").document(self.animal)
            
            Doc.getDocument{ [self] (document, error) in
                
                if let document = document, document.exists{
                
                
                    let field = self.adjective + "_" + String(self.number)
                                    
                    Doc.updateData([
                        field: true
                    ])
            

                    
                    group.leave()
                    
                } else {
                    print("The document doesn't exist.")
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) {
           print("Username creation is confirmed!")
            let userString = self.getUsernameString()
            let userAvatar = self.getAvatarString()
            UserDefaults.standard.set(userString, forKey: "dvoxUsername")
            UserDefaults.standard.set(userAvatar, forKey: "dvoxUsernameAvatar")
            
        }
 
    }
}
