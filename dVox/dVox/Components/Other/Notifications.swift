//
//  Notifications.swift
//  dVox
//
//  Created by Aleksandr Molchagin on 12/17/21.
//

import Foundation

import FirebaseMessaging


class Notifications{
    
    init(){
        
    }

    func subscribeTo(topic: String){
        var givenTopic = topic
        if givenTopic == "publicOnly"{
            givenTopic = "Public"
        }
        Messaging.messaging().subscribe(toTopic: givenTopic) { error in
            print("Subscribed to \(givenTopic)!")
        }
    }
}
