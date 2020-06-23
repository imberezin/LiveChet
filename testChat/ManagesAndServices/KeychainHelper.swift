//
//  TouchIdLoginHelper.swift
//  IBBreakpoint
//
//  Created by Israel Berezin on 11/22/18.
//  Copyright © 2018 Israel Berezin. All rights reserved.
//

import UIKit
import LocalAuthentication

// Keychain Configuration
struct KeychainConfiguration {
    static let serviceName = "TouchMeIn"
    static let accessGroup: String? = nil
}


class KeychainHelper{
    static let instance = KeychainHelper()
    
    var passwordItems: [KeychainPasswordItem] = []
    
    func saveUserDataInKeychain(userName: String, password: String){
        if userName.count > 0 && password.count > 0{
            UserDefaults.standard.setValue(userName, forKey: "username")
            // 5
            do {
                // This is a new account, create a new keychain item with the account name.
                let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                        account: userName,
                                                        accessGroup: KeychainConfiguration.accessGroup)
                
                // Save the password for the new item.
                try passwordItem.savePassword(password)
            } catch {
                fatalError("Error updating keychain - \(error)")
            }
        }
    }
    
    func checkIfUserHaveBiometricID() -> Bool {
        guard let username = UserDefaults.standard.value(forKey: "username") as? String else {
            return (false)
        }
        
        let newUserName = "\(username),BiometricID"

        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: newUserName,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            let keychainPassword = try passwordItem.readPassword()
            if keychainPassword.count > 0{
                return true
            }
            return false
        } catch {
            return false
        }
    }
    
    
    func getUserDataFromKeychain() -> (username: String?, password: String?) {
        guard let username = UserDefaults.standard.value(forKey: "username") as? String else {
            return (nil,nil)
        }
        let newUserName = "\(username),BiometricID"
        
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: newUserName,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            let keychainPassword = try passwordItem.readPassword()
            return(newUserName,keychainPassword)
            
           // return password == keychainPassword
        } catch {
            return (nil,nil)
            //fatalError("Error reading password from keychain - \(error)")
        }
    }

    
    
    func deleteUserDataFromKeychain(){
        guard let username = UserDefaults.standard.value(forKey: "username") as? String else {
            return
        }
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: username,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            
            try passwordItem.deleteItem()
            UserDefaults.standard.setValue(nil, forKey: "username")
            
        } catch {
            fatalError("Error reading password from keychain - \(error)")
        }
    }
    
    func updateUserBiometricIDInKeychain(){
        guard let username = UserDefaults.standard.value(forKey: "username") as? String else {
            return
        }
        let newUserName = "\(username),BiometricID"

        do {
            var passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: username,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            try passwordItem.renameAccount(newUserName)
        } catch {
            do{
                var passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: newUserName,
                                                    accessGroup: KeychainConfiguration.accessGroup)
                try passwordItem.renameAccount(newUserName)
            }catch{
                fatalError("Error reading password from keychain - \(error)")
            }
        }
        
    }
    
}
