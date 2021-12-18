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
        Messaging.messaging().subscribe(toTopic: topic) { error in
            print("Subscribed to \(topic)!")
        }
    }
}
