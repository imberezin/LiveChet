//
//  AuthService.swift
//  IBBreakpoint
//
//  Created by Israel Berezin on 11/8/18.
//  Copyright © 2018 Israel Berezin. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn

class AuthService {
    static let instance = AuthService()
    
    func regsterUser(withEmail email:String, andPassword password:String, userCreationComplete: @escaping (_ status: Bool, _ error:Error?) ->()){
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard let currUser = authResult?.user  else{
                userCreationComplete(false, error)
                return;
            }
            
            var userData = ["provider": currUser.providerID, "email": currUser.email]

            if let provider = currUser.providerData.first?.providerID{
                userData = ["provider": provider, "email": currUser.email]

            }
            DataService.instance.createDBUser(uid: currUser.uid, userData: userData as Dictionary<String, Any>)
            userCreationComplete(true, nil)
        }
    }
    
    func loginUser(withEmail email:String, andPassword password:String, loginComplete: @escaping (_ status: Bool, _ error:Error?) ->()){
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            
            
            if error != nil {
                loginComplete(false, error)
                return;
            }
            loginComplete(true, nil)
        }
    }
    
    func addProviderUserIfNeeded(_ userCreationComplete: @escaping (_ status: Bool, _ error:Error?) ->()){
        
        DataService.instance.getAllBasicUsersData(){ fullDBUsers in
            if fullDBUsers.count > 0 {
                
                if let currUser: Firebase.User = Auth.auth().currentUser {
                    
                    var isUserExist = false
                    for user in fullDBUsers{
                        if user.key == currUser.uid{
                            isUserExist = true
                            break
                        }
                    }
                    if isUserExist {
                        
                        userCreationComplete(true, nil)
                        
                    } else {
                        
                        self.addNewUserToDB()
                        userCreationComplete(true, nil)
                        
                    }
                }else{
                    //user not login
                    userCreationComplete(false, nil)

                }
            } else {
                // it first user!
                self.addNewUserToDB()
                userCreationComplete(true, nil)
            }
        }
    }
    
    func addNewUserToDB(){
        
        if let currUser: Firebase.User = Auth.auth().currentUser, let provider = currUser.providerData.first?.providerID {

            
            var userData = ["provider": provider, "email": currUser.email]
            if let userImageUrl = currUser.providerData.first?.photoURL{
                let urlString: String = userImageUrl.absoluteString
                 userData = ["provider": provider, "email": currUser.email!, "userImageUrl": urlString]
            }
            DataService.instance.createDBUser(uid: currUser.uid, userData: userData as Dictionary<String, Any>)
        
        }
    }
    
}
