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
    
    func setBan(postId: Int, ban: Bool) {
        let apis = APIs()
        let location = apis.retriveKey(for: "ContractAddress") ?? "error"
        let id = String(postId) + location
        banDictionary[id] = ban
        UserDefaults.standard.set(banDictionary, forKey: "BanAuthorContainer")
    }
    
    func getBan(postId: Int) -> Bool{
        let apis = APIs()
        let location = apis.retriveKey(for: "ContractAddress")  ?? "error"
        let id = String(postId) + location
        return banDictionary[id] ?? false
    }
    
    func resetContainer(){
        banDictionary = UserDefaults.standard.object(forKey: "BanAuthorContainer") as? [String:Bool] ?? [:]
        banDictionary.removeAll()
        UserDefaults.standard.set(banDictionary, forKey: "BanAuthorContainer")
    }
    
}
