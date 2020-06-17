//
//  AppDelegate.swift
//  testChat
//
//  Created by Israel Berezin on 6/1/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import GoogleSignIn
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       // UserDefaults.standard.set(false, forKey: "status")

        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID//"246529891635-c0efbithme6iuk3julhvfps1am888i0l.apps.googleusercontent.com"

        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        let consumerKey = Bundle.main.object(forInfoDictionaryKey: "consumerKey")
        let consumerSecret = Bundle.main.object(forInfoDictionaryKey: "consumerSecret")

        if let key = consumerKey as? String, let secret = consumerSecret as? String{
            TWTRTwitter.sharedInstance().start(withConsumerKey: key, consumerSecret: secret)
        }

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


}

