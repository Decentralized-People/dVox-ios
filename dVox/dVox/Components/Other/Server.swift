//
//  Server.swift
//  dVox
//
//  Created by Aleksandr Molchagin on 12/18/21.
//

import Foundation


class Server{
    
    var apis: APIs
    
    init(_apis: APIs){
        apis = _apis;
    }
    
    func switchToSchool(){
        if UserDefaults.standard.string(forKey: "SCHOOL_LOCATION") == "publicOnly"{
            return
        } else {
            UserDefaults.standard.set(true, forKey: "SCHOOL_ENABLE")
            apis.setOnError()
            apis.getAPIs()
        }
    }
    
    func switchToPublic(){
        if UserDefaults.standard.string(forKey: "SCHOOL_LOCATION") == "publicOnly"{
            UserDefaults.standard.set(false, forKey: "SCHOOL_ENABLE")
        } else {
            UserDefaults.standard.set(false, forKey: "SCHOOL_ENABLE")
            apis.setOnError()
            apis.getAPIs()
        }
    }
    
}
