//
//  AuthService.swift
//  IBBreakpoint
//
//  Created by Israel Berezin on 11/8/18.
//  Copyright © 2018 Israel Berezin. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    static let instance = AuthService()
    
    func regsterUser(withEmail email:String, andPassword password:String, userCreationComplete: @escaping (_ status: Bool, _ error:Error?) ->()){
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard let currUser = authResult?.user  else{
                userCreationComplete(false, error)
                return;
            }
            
            let userData = ["provider": currUser.providerID, "email": currUser.email]
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
    
    
}
