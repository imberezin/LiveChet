//
//  LoginVM.swift
//  testChat
//
//  Created by Israel Berezin on 6/2/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI
import Combine
import Firebase


class LoginVM: ObservableObject {
    
    @Published var alert: Bool = false
    var error: String = ""

    private let biometricIDAuth = BiometricIDAuth()

    private let googleServise: GoogleLoginServise = GoogleLoginServise()
    
    private let appleLoginServise: AppleLoginServise = AppleLoginServise()
    
    func biometricImage() -> Image {
        return self.biometricIDAuth.biometricUIImage()
    }
    
    func toggleAlert(){
        self.alert.toggle()
    }
    
    func updateError(errorText: String?){
        print(errorText ?? "")
        self.error = errorText ?? ""
        self.alert = true
    }
    
    
    func biometricLogin()
    {
        self.biometricIDAuth.authenticateUser { (resualtCode) in
            if resualtCode != nil{
                print("touchID successfully - \(resualtCode!)")
            }
            else{
                print("touchID successfully")
                let userData = KeychainHelper.instance.getUserDataFromKeychain()
                if userData.username != nil{
                    let items = userData.username!.components(separatedBy: ",")
                    print(items)
                    let email = items.first
                    self.login(mail: email!, password: userData.password!)
//                    AuthService.instance.loginUser(withEmail: email!, andPassword: userData.password!) { (success, loginErorr) in
//                        if (success){
//                            print("Successfully login user")
//                            self.dismiss(animated: true, completion: nil)
//                            return
//                        }else{
//                            print(String(describing: loginErorr?.localizedDescription))
//                        }
//                    }
                }
            }
        }
    }

    
    
    func login(mail: String, password:String){
        self.alert = false
        Auth.auth().signIn(withEmail: mail, password: password) { (res, err) in
            
            if err != nil{
                
                self.updateError(errorText: err!.localizedDescription)
                return
            }
                        
            print("success")
            
            KeychainHelper.instance.saveUserDataInKeychain(userName: mail, password: password)

            UserDefaults.standard.set(true, forKey: "status")
            NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
            
        }

    }
    
    
    func loginWIthGoogle(){
        self.googleServise.login { isLogin in
            print("isLogin = \(isLogin)")
            UserDefaults.standard.set(isLogin, forKey: "status")
            NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
        }
    }
    
    func loginWithApple(){
        self.appleLoginServise.handleSignInWithApple(){ isLogin in
            print("isLogin = \(isLogin)")
            UserDefaults.standard.set(isLogin, forKey: "status")
            NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
        }
    }
    
    func logout(){
        try! Auth.auth().signOut()
        UserDefaults.standard.set(false, forKey: "status")
        NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)

    }
    
    func register(email:String, password:String){
        AuthService.instance.regsterUser(withEmail: email, andPassword: password) { (success, registrationErorr) in
            if (success){
                AuthService.instance.loginUser(withEmail: email, andPassword: password) { (success, loginErorr) in
                    print("Successfully registered & login user")
                    KeychainHelper.instance.saveUserDataInKeychain(userName: email, password: password)
                    UserDefaults.standard.set(true, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                    self.alert = false

                }
            }
            else{
                if registrationErorr != nil{

                    self.updateError(errorText: registrationErorr!.localizedDescription)
                }

            }
        }
    }
    
//    func register(mail: String, password:String){
//        self.alert = false
//        Auth.auth().createUser(withEmail: mail, password: password) { (res, err) in
//            
//            if err != nil{
//                
//                self.updateError(errorText: err!.localizedDescription)
//                return
//            }
//            
//            print("success")
//            
//            UserDefaults.standard.set(true, forKey: "status")
//            NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
//            self.alert = false
//        }
//    }
    
    func reset(email: String){
                 
         Auth.auth().sendPasswordReset(withEmail: email) { (err) in
             
             if err != nil{
                 
                 self.updateError(errorText: err!.localizedDescription)
                 return
             }
             
            self.updateError(errorText: "RESET")
         }
        
     }
    
    
    func test(){
        AuthService.instance.addProviderUserIfNeeded(){ status, error in
            
                print("aaa")
            
        }

    }
}

