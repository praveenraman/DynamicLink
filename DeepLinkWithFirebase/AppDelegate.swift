//
//  AppDelegate.swift
//  DeepLinkWithFirebase
//
//  Created by Praveen Raman on 10/22/20.
//

import UIKit
import Firebase
import FirebaseDynamicLinks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func handelIncomingDynamicLink(_dynamicLink: DynamicLink) {
        guard let url = _dynamicLink.url else {
            print("That is weird. my dynamic link object has no url")
            return
        }
        print("AppDelegate Your incoming link perameter is \(url.absoluteString)")
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false), let queryItems = components.queryItems else {
            return
        }
        for queryItem in queryItems {
            print("Parameter:- \(queryItem.name) has a value:-  \(queryItem.value ?? "") ")
        }
        _dynamicLink.matchType
    }

    func application(_application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool{
        if let incomingURL = userActivity.webpageURL{
            print("Incoming URL is \(incomingURL)")
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { (dynamicLink, error) in
                guard error == nil else{
                    print("Found an error \(error!.localizedDescription)")
                    return
                }
                if dynamicLink != nil{
                    self.handelIncomingDynamicLink(_dynamicLink: dynamicLink!)
                }
            }
            if linkHandled{
                return true
            } else{
                ///
                return false
            }
        }
        return false
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("I have recive a URL through a custom scheme! \(url.absoluteString)")
       if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url){
            self.handelIncomingDynamicLink(_dynamicLink: dynamicLink)
            return true
       } else{
        // maybe handel Google and firebase
        return false
       }
    }
}

