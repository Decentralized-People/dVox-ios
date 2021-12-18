//
//  VotesContainer.swift
//  VotesContainer
//
//  Created by Aleksandr Molchagin on 8/19/21.
//

import Foundation

class VotesContainer{
    
    var votesDictionary: [String:String]

    init(){
        votesDictionary = UserDefaults.standard.object(forKey: "VotesContainer") as? [String:String] ?? [:]
        print("Votes container: \(votesDictionary)")
    }
    
    func addVote(postId: Int, vote: Int) {
        let apis = APIs()
        let location = apis.retriveKey(for: "ContractAddress") ?? "error"
        let id = String(postId) + location
        votesDictionary[id] = String(vote)
        UserDefaults.standard.set(votesDictionary, forKey: "VotesContainer")
    }
    
    func getVote(postId: Int) -> String{
        let apis = APIs()
        let location = apis.retriveKey(for: "ContractAddress")  ?? "error"
        let id = String(postId) + location
        return votesDictionary[id] ?? "no data"
    }
    
}
