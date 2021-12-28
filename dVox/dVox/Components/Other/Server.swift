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
    
    func switchToSchool(){
        if UserDefaults.standard.string(forKey: "SCHOOL_LOCATION") == "publicOnly"{
            return
        } else {
            
            
            UserDefaults.standard.set(true, forKey: "SCHOOL_ENABLE")
            UserDefaults.standard.set(true, forKey: "SERVER_CHANGING")
            apis.setOnError()
            apis.getAPIs()
            UserDefaults.standard.set(true, forKey: "RELOAD_NEEDED")
            loader.reloadIfNeeded()
            UserDefaults.standard.set(true, forKey: "SERVER_CHANGED")
            
            let not = Notifications()
            not.tempUnsubscribe()
            if UserDefaults.standard.bool(forKey: "NOTIFICATIONS_ON"){
                not.resubscribe()
            }
            
        }
    }
    
    func reloadRequired(){
        UserDefaults.standard.set(true, forKey: "SERVER_CHANGED")
    }
    
    func switchToPublic(){
        if UserDefaults.standard.string(forKey: "SCHOOL_LOCATION") == "publicOnly"{
            UserDefaults.standard.set(false, forKey: "SCHOOL_ENABLE")
        } else {
            UserDefaults.standard.set(false, forKey: "SCHOOL_ENABLE")
            UserDefaults.standard.set(true, forKey: "SERVER_CHANGING")
            apis.setOnError()
            apis.getAPIs()
            UserDefaults.standard.set(true, forKey: "RELOAD_NEEDED")
            loader.reloadIfNeeded()
            UserDefaults.standard.set(true, forKey: "SERVER_CHANGED")
            
            let not = Notifications()
            not.tempUnsubscribe()
            if UserDefaults.standard.bool(forKey: "NOTIFICATIONS_ON"){
                not.resubscribe()
            } 
        }
    }
    
}
