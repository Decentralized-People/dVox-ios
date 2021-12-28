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

    func resubscribe(){
        let schoolLocation = UserDefaults.standard.string(forKey: "SCHOOL_LOCATION")
        let schoolEnabled = UserDefaults.standard.bool(forKey: "SCHOOL_ENABLE")
        if schoolEnabled{
            subscribeTo(topic: schoolLocation ?? "error")
        } else {
            subscribeTo(topic: "Public")
        }
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
        UserDefaults.standard.set(true, forKey: "NOTIFICATIONS_ON")
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
        
        subscriptionDictionary.removeValue(forKey: givenTopic);
        UserDefaults.standard.set(subscriptionDictionary, forKey: "SubscriptionsContainer")
    }
    
    func tempUnsubscribe(){
       
        unSubscribeFrom(topic: subscriptionDictionary["School"] ?? "error");
        unSubscribeFrom(topic: subscriptionDictionary["Public"] ?? "error");
        

    }
    
    func unSubscribeFromAll(){
       
        unSubscribeFrom(topic: subscriptionDictionary["School"] ?? "error");
        unSubscribeFrom(topic: subscriptionDictionary["Public"] ?? "error");
        
        UserDefaults.standard.set(false, forKey: "NOTIFICATIONS_ON")

    }
    
    func notificationsOff(){
        unSubscribeFrom(topic: subscriptionDictionary["School"] ?? "error");
        unSubscribeFrom(topic: subscriptionDictionary["Public"] ?? "error");

        subscriptionDictionary = UserDefaults.standard.object(forKey: "SubscriptionsContainer") as? [String:String] ?? [:]
        UserDefaults.standard.set(subscriptionDictionary, forKey: "SubscriptionsContainer")
    }
    
    
    func sendNotification(title: String, author: String){
    
        DispatchQueue.global(qos: .userInitiated).async { [] in
            
                let schoolEnabled = UserDefaults.standard.bool(forKey: "SCHOOL_ENABLE")
                let schoolLocation = UserDefaults.standard.string(forKey: "SCHOOL_LOCATION")

                let notificationTitle = title
                let notificationContent = "A new message from \(author)"
                
                if (schoolEnabled){
                    let ref = Firestore.firestore().collection("Notifications").document(schoolLocation ?? "error")

                    ref.updateData([
                        "title": notificationTitle,
                        "content": notificationContent
                    ])
                } else {
                    let ref = Firestore.firestore().collection("Notifications").document("PublicLocation")

                    ref.updateData([
                        "title": notificationTitle,
                        "content": notificationContent
                    ])
                }
            
        }
        /// Update UI at the main thread
        DispatchQueue.main.async {
                            
            
        }
    }
}
