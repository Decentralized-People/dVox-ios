//
//  SceneDelegate.swift
//  dVox
//
//  Created by Aleksandr Molchagin on 7/7/21.
//
//  Modified by Aleksandr Molchagin on 7/14/21:
//      Add support for authentification dynamic links.
//

import UIKit
import SwiftUI
import NavigationStack
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    @Published var view = LoginView(_error: false)

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Create the SwiftUI view that provides the window contents.
        
        // ** NEED TO CHECK IF THE USER CREATED ACCOUNT: TRUE -> SWITCH TO MAINVIEW, FALSE -> KEEP LOGINVIEW ** //
        
        if FirebaseApp.app() == nil {
               FirebaseApp.configure()
           }
        
        
        if (Auth.auth().currentUser == nil) {
            
            let loginView = LoginView(_error: false) //LoginView()

            // Use a UIHostingController as window root view controller.
            if let windowScene = scene as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
                window.rootViewController = UIHostingController(rootView: loginView)
                self.window = window
                window.makeKeyAndVisible()
                UserDefaults.standard.set( false, forKey: "userAuthed")

            }
            
            //print("User exists!: \(Auth.auth().currentUser)")
            
        } else {
        
            let mainView = MainView()
                .environmentObject(NavigationStack())//LoginView()

            // Use a UIHostingController as window root view controller.
            if let windowScene = scene as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
                window.rootViewController = UIHostingController(rootView: mainView)
                self.window = window
                window.makeKeyAndVisible()
            }
        }

    
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
       

    // Handling incoming universal links
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
            
            // Checking the universal link
            guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
                let url = userActivity.webpageURL,
                let host = url.host else {
                    return
            }
            
            // Getting the deep link from the universal link
            DynamicLinks.dynamicLinks().dynamicLink(fromUniversalLink: url) { dynamicLink, error in
                guard error == nil,
                    let dynamicLink = dynamicLink,
                    let urlString = dynamicLink.url?.absoluteString else {
                        return
                }
                
                //Debugging
                print("Dynamic link host: ", host)
                print("Dyanmic link url: ", urlString)
                

                // Handle deep links
                self.handleDeepLink(urlString)
            }
    }
    
    //Handling deep links from universal links
    func handleDeepLink(_ link: String){
        
        // Check if firebase is configured
        if FirebaseApp.app() == nil {
               FirebaseApp.configure()
           }
        // Get the saved email
        let email = UserDefaults.standard.object(forKey: "Email")
        
        if email == nil {
            showErrorLoginView()
            return
        }
        
        self.getSchoolFeed(email: email! as! String)
        UserDefaults.standard.set( true, forKey: "userAuthed")
        
        // Check the email and the deep link
        if email != nil {
            if Auth.auth().isSignIn(withEmailLink: link) {
                Auth.auth().signIn(withEmail: email as! String, link: link, completion: { [self] auth, error in
                    
                    // Debugging
                    print("Auth: ", auth as Any);
                    print("Error: ", error as Any);
                    print ("Link: ", link)
                    print("Email: ", email as Any)
                    
                    if error == nil {
                        print("SUCCESS!")
                        
                        
                        let mainview = MainView()
                            .environmentObject(NavigationStack())//LoginView()

                        // Use a UIHostingController as window root view controller.
                        window!.rootViewController = UIHostingController(rootView: mainview)
                        window!.makeKeyAndVisible()
                        
                    } else{
                        //error
                        showErrorLoginView()
                    }})
            } else {
                //error
                showErrorLoginView()
            }
        } else {
            //error
            showErrorLoginView()
        }
    }
    
    func showErrorLoginView(){
        let loginViewError = LoginView(_error: true)
        // Use a UIHostingController as window root view controller.
        window!.rootViewController = UIHostingController(rootView: loginViewError)
        window!.makeKeyAndVisible()
    }
    
    func getSchoolFeed(email: String){

        DispatchQueue.global(qos: .userInitiated).async { [] in
            
            let ref = Firestore.firestore().collection("Locations").document("#locations_dictionary")
            
            ref.getDocument{ (document, error) in
                
                if let document = document, document.exists {
                    
                    print("Getting a new location for: \(self.emailEnding(email: email))")
                    
                    var schoolLocation = String(document.get(self.emailEnding(email: email)) as? String ?? "error")
                    
                    print("Add new Location: \(schoolLocation)")
                    
                    if schoolLocation == "error"{
                        schoolLocation = "publicOnly"
                    } else{
                        UserDefaults.standard.set(true, forKey: "SCHOOL_ENABLE")
                    }
                    
                    UserDefaults.standard.set(schoolLocation, forKey: "SCHOOL_LOCATION")
                    
                    let notifications = Notifications()
                    notifications.subscribeTo(topic: schoolLocation)
                    
                }
            }
        }
    }
    
    func emailEnding(email: String) -> String{
        let idx = email.firstIndex(of: "@")
        let emailEnding = String(email[idx!...])
        return emailEnding.replacingOccurrences(of: ".", with: "_")

    }
    
}
