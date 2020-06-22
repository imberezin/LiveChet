//
//  UserVM.swift
//  testChat
//
//  Created by Israel Berezin on 6/2/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import Foundation
import Combine
import Firebase
import SwiftUI

class CurrUserVM: ObservableObject {
    
    var user: Firebase.User? = Auth.auth().currentUser
    
    @Published var fullUser: User = User()
    
    @Published var isUserUpdate: Bool = false
    

    init(){
       
        if Auth.auth().currentUser != nil {
            DataService.instance.getUser(forUID: Auth.auth().currentUser!.uid) { fullDBUser in
                if Auth.auth().currentUser != nil, let fullDBUser = fullDBUser{
                    let image = #imageLiteral(resourceName: "defaultProfileImage")
                    var decodedimage = image
                    var decodedimage1:Image = Image("defaultProfileImage")
                    
                    if fullDBUser.userImage != nil{
                        let dataDecoded : Data = Data(base64Encoded: fullDBUser.userImage!, options: .ignoreUnknownCharacters)!
                        decodedimage = UIImage(data: dataDecoded)!
                        decodedimage1 = Image(uiImage: decodedimage)
                        
                    }
                    self.fullUser = User(name: fullDBUser.name, image: decodedimage, image1: decodedimage1, userImageUrl: fullDBUser.userImageUrl, senderId: Auth.auth().currentUser!.uid)

//                    self.fullUser = User(name: username, image: decodedimage, image1: decodedimage1, senderId:  Auth.auth().currentUser!.uid)
                    self.user = Auth.auth().currentUser
                }else{
                    self.userLogout()
                }
                self.isUserUpdate.toggle()
            }
        }else{
            self.userLogout()
        }
    }
    
    var email : String {
        if user != nil{
            return user!.email!
        }
        return ""
    }
    
    var userName: String{
        
        if fullUser.name != "" {
            return fullUser.name
        }
        if user != nil{
            if let name = user?.providerData.first?.displayName{
                return name
            }
            let fullEmailArr = self.email.components(separatedBy:"@")
            if fullEmailArr.count > 0{
                return fullEmailArr.first!
            }
            return ""
        }
        return ""
    }
    
    var userImage: Image{
        return fullUser.image1
    }
    
    var userUid: String?{
        if self.user != nil{
            return user!.uid
        }
        return nil
    }
    
    var userImageUrl: URL?{
        if self.user != nil && self.fullUser.userImageUrl != nil{
            print("self.fullUser.userImageUrl!")
            return URL(string: self.fullUser.userImageUrl!) //self.fullUser.userImageUrl

        }
        return nil

    }


    
    func isMyUser(user testUser: User) -> Bool{
        var isUser = false
        if self.user != nil{
            if testUser.senderId == self.user!.uid{
                isUser = true
            }
        }
        return isUser
    }
    
    func userLogout(){
        self.user = nil
        self.fullUser = User()
    }
}
