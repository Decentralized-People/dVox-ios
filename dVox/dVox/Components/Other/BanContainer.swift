//
//  BanContainer.swift
//  BanContainer
//
//  Created by Aleksandr Molchagin on 8/19/21.
//

import Foundation

class BanContainer{
    
    var banDictionary: [String:Bool]

    init(){
        banDictionary = UserDefaults.standard.object(forKey: "BanContainer") as? [String:Bool] ?? [:]
        print("Ban container: \(banDictionary)")
    }
    
    func setBan(postId: Int, ban: Bool) {
        let apis = APIs()
        let location = apis.retriveKey(for: "ContractAddress") ?? "error"
        let id = String(postId) + location
        banDictionary[id] = ban
        UserDefaults.standard.set(banDictionary, forKey: "BanContainer")
    }
    
    func getBan(postId: Int) -> Bool{
        let apis = APIs()
        let location = apis.retriveKey(for: "ContractAddress")  ?? "error"
        let id = String(postId) + location
        return banDictionary[id] ?? false
    }
    
}
