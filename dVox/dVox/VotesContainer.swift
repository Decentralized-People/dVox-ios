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
        votesDictionary[String(postId)] = String(vote)
        UserDefaults.standard.set(votesDictionary, forKey: "VotesContainer")
    }
    
    func getVote(postId: Int) -> String{
        return votesDictionary[String(postId)] ?? "no data"
    }
    
}
