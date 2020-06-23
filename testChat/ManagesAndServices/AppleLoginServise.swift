//
//  AppleLoginServise.swift
//  testChat
//
//  Created by israel.berezin on 21/06/2020.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI
import UIKit
import AuthenticationServices
import Firebase

class AppleLoginServise: NSObject,ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding  {
    
    fileprivate var currentNonce: String?

    var loginCompletion: ((Bool) -> Void)?

    func handleSignInWithApple(_ completion: @escaping ((Bool) -> Void)){
        
        self.loginCompletion = completion
        let nonce = String.randomNonceString()
        currentNonce = nonce
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = nonce.sha256
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows[0]
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            print("AppleLoginServise")
            // Initialize a Firebase credential.
            let credentials = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            

            Auth.auth().signIn(with: credentials) { (authResult, error) in
                if error != nil{
                    print(error!)

                    self.loginCompletion!(false)

                }else{
                    AuthService.instance.addProviderUserIfNeeded(){ status, error in

                        self.loginCompletion!(status)
                    }
                }
            }
//            // Sign in with Firebase.
//            Auth.auth().signIn(with: credential, completion: handleAuthResultCompletion)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple error: \(error)")
//        self.isAuthenticating = false
//        self.error = error as NSError
    }

    
    
}

