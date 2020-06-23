//
//  GoogleServise.swift
//  testChat
//
//  Created by israel.berezin on 21/06/2020.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI


import Firebase
import Foundation
import GoogleSignIn
import UIKit


class GoogleLoginServise: NSObject, GIDSignInDelegate {
    
    var loginCompletion: ((Bool) -> Void)?

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil{
            print(error!)
            self.loginCompletion!(false)
        }
        else{
            if user != nil{
                print("user = \(user!)")
                
                guard let authentication = user.authentication else {
                    self.loginCompletion!(false)
                    return
                }
                
                let credentials = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                                  accessToken: authentication.accessToken)

                
                Auth.auth().signIn(with: credentials) { (authResult, error) in
                    if error != nil{
                        self.loginCompletion!(false)

                    }else{
                        
                        AuthService.instance.addProviderUserIfNeeded(){ status, error in
                            
                            self.loginCompletion!(status)
                        }
                    }
                }
            }else{
                self.loginCompletion!(false)
            }
        }
    
    }
    
    func login(_ completion: @escaping ((Bool) -> Void)){
        self.loginCompletion = completion
        
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
        GIDSignIn.sharedInstance()?.delegate = self
        
        GIDSignIn.sharedInstance()?.signIn()
    }

}

/*
 let user: GIDGoogleUser = GIDSignIn.sharedInstance()!.currentUser
 let fullName = user.profile.name
 let email = user.profile.email
 if user.profile.hasImage {
 let userDP = user.profile.imageURL(withDimension: 150)
     print(fullName)
     print(email)
     print(userDP!)
 }

 */
