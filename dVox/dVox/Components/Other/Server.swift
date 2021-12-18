//
//  Server.swift
//  dVox
//
//  Created by Aleksandr Molchagin on 12/18/21.
//

import Foundation


class Server{
    
    var apis: APIs!
    var loader: PostLoader2!
    
    init(_apis: APIs, _loader: PostLoader2){
        apis = _apis;
        loader = _loader
    }
    
    func setCurrentLocation(_loc: String){
        UserDefaults.standard.set(_loc, forKey: "ContractAddress")
    }
    
    func getCurrnetLocation() -> String {
        let location = UserDefaults.standard.string(forKey: "ContractAddress") ?? "error"
        return location
    }
    
    func switchToSchool(){
        if UserDefaults.standard.string(forKey: "SCHOOL_LOCATION") == "publicOnly"{
            return
        } else {
            UserDefaults.standard.set(true, forKey: "SCHOOL_ENABLE")
            apis.setOnError()
            apis.getAPIs()
            UserDefaults.standard.set(true, forKey: "RELOAD_NEEDED")
            loader.reloadIfNeeded()
            loader.items = []
            loader.getPosts(index: 0, currentId: -1, getPosts:12)
            loader.noMorePosts = false
        }
    }
    
    func switchToPublic(){
        if UserDefaults.standard.string(forKey: "SCHOOL_LOCATION") == "publicOnly"{
            UserDefaults.standard.set(false, forKey: "SCHOOL_ENABLE")
        } else {
            UserDefaults.standard.set(false, forKey: "SCHOOL_ENABLE")
            apis.setOnError()
            apis.getAPIs()
            UserDefaults.standard.set(true, forKey: "RELOAD_NEEDED")
            loader.reloadIfNeeded()
            loader.items = []
            loader.getPosts(index: 0, currentId: -1, getPosts:12)
            loader.noMorePosts = false
        }
    }
    
}
