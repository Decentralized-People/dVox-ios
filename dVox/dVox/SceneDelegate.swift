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

import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Create the SwiftUI view that provides the window contents.
        
        // ** NEED TO CHECK IF THE USER CREATED ACCOUNT: TRUE -> SWITCH TO MAINVIEW, FALSE -> KEEP LOGINVIEW ** //
        
        let loginView = LoginView() //LoginView()

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: loginView)
            self.window = window
            window.makeKeyAndVisible()
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
                        
                        // ** SWITCH TO THE MAIN VIEW ** //
                        
                        let loginView = MainView() //LoginView()

                
         
                        
                    }})
            }
        }
    }
    
}

