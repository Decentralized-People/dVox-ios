//
//  Notifications.swift
//  dVox
//
//  Created by Aleksandr Molchagin on 12/17/21.
//

import Foundation
import Firebase
import FirebaseMessaging


class Notifications{
    
    var subscriptionDictionary: [String:String]
    
    init(){
        subscriptionDictionary = UserDefaults.standard.object(forKey: "SubscriptionsContainer") as? [String:String] ?? [:]
    }

    
    func subscribeTo(topic: String){
        var givenTopic = topic
        if givenTopic == "publicOnly"{
            givenTopic = "PublicLocation"
            subscriptionDictionary["Public"] = "PublicLocation"
        } else if (givenTopic == "Public"){
            subscriptionDictionary["Public"] = "PublicLocation"
            givenTopic = "PublicLocation"
        } else {
            subscriptionDictionary["School"] = givenTopic
        }
        Messaging.messaging().subscribe(toTopic: givenTopic) { error in
            print("Subscribed to \(givenTopic)!")
        }
        UserDefaults.standard.set(subscriptionDictionary, forKey: "SubscriptionsContainer")
    }
    
    func unSubscribeFrom(topic: String){
        
        subscriptionDictionary = UserDefaults.standard.object(forKey: "SubscriptionsContainer") as? [String:String] ?? [:]


        if topic == "error"{
            return
        }
        var givenTopic = topic
        if givenTopic == "publicOnly"{
            givenTopic = "Public"
        }
        
        Messaging.messaging().unsubscribe(fromTopic: givenTopic) { error in
            print("UNSubscribed from \(givenTopic)!")
        }
    }
    
    func unSubscribeFromAll(){
       
        unSubscribeFrom(topic: subscriptionDictionary["School"] ?? "error");
        unSubscribeFrom(topic: subscriptionDictionary["Public"] ?? "error");

        subscriptionDictionary = UserDefaults.standard.object(forKey: "SubscriptionsContainer") as? [String:String] ?? [:]
        UserDefaults.standard.set(subscriptionDictionary, forKey: "SubscriptionsContainer")

     
    }
    
    func notificationsOff(){
        
    }
    
    func sendNotification(title: String, author: String){
        
        DispatchQueue.global(qos: .userInitiated).async { [] in

                let ref = Firestore.firestore().collection("Notifications").document("KalamazooCollege")

                ref.updateData([
                    "title": title,
                    "content": author
                ])
            
        }
        /// Update UI at the main thread
        DispatchQueue.main.async {
                            
            
        }
    }
}
