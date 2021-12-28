//
//  BanAuthorContainer.swift
//  dVox
//
//  Created by Aleksandr Molchagin on 12/23/21.
//
import Foundation

class BanAuthorContainer{
    
    var banDictionary: [String:Bool]

    init(){
        banDictionary = UserDefaults.standard.object(forKey: "BanAuthorContainer") as? [String:Bool] ?? [:]
    }
    
    func setBan(author: String, ban: Bool) {
        let apis = APIs()
        let location = apis.retriveKey(for: "ContractAddress") ?? "error"
        let id = author + location
        banDictionary[id] = ban
        UserDefaults.standard.set(banDictionary, forKey: "BanAuthorContainer")
    }
    
    func getBan(author: String) -> Bool{
        let apis = APIs()
        let location = apis.retriveKey(for: "ContractAddress")  ?? "error"
        let id = author + location
        return banDictionary[id] ?? false
    }
    
    func resetContainer(){
        banDictionary = UserDefaults.standard.object(forKey: "BanAuthorContainer") as? [String:Bool] ?? [:]
        banDictionary.removeAll()
        UserDefaults.standard.set(banDictionary, forKey: "BanAuthorContainer")
    }
    
}
