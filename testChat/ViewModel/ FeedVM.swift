//
//   FeedVM.swift
//  testChat
//
//  Created by Israel Berezin on 6/3/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import Foundation
import Combine
import Firebase
import SwiftUI

class FeedVM: ObservableObject {
    
    @Published var messageArray = [Message]()

    @Published var searchTerm: String = ""

    @Published var userArray = [User]()
    var oldUserArray = [User]()
    @Published var updateView: Bool = false
    
    @Published var updateGView: Bool = false

    @Published var groupsArray = [Group]()
    @Published var groupUsersArray = [User]()
    
    var refHandle: UInt?
    
    func getAllFeedes(){
        
        print("getAllFeedes")
        self.oldUserArray = self.userArray.map { $0 } // copy arrey to reuse users
        self.messageArray.removeAll()
        DataService.instance.REF_FEED.observe(.value) { (snapshot) in
            
            print("REF_FEED.observe")
            
            DataService.instance.getAllFeedMessages { (returnMessagesArray) in
                print("getAllFeedMessages")
                
                self.messageArray = returnMessagesArray
                
                if self.messageArray.count > 0{
                    
                    let usersKeys: [String] = self.messageArray.map({$0.senderId})
                    self.userArray = Array(repeating: User(), count: usersKeys.count)

                    
                    DataService.instance.getUsers(forUID: usersKeys) { users in
                        let tempUsers = self.createUsersArray(usersFromDB: users)
                        for message: Message in self.messageArray{
                            if let row = tempUsers.firstIndex(where: {$0.senderId == message.senderId}){
                                let user = tempUsers[row]
                                self.userArray[row] = user
                            }
                        }
                        self.updateView.toggle()
                    }
                }
            }
        }
    }
    
    func getMessageUser(message: Message, isGroup:Bool = false) -> User{
        var users = self.userArray
        if isGroup{
            users = self.groupUsersArray
        }
        if let row = users.firstIndex(where: {$0.senderId == message.senderId}){
            let user = users[row]
//            print(user)
            return user
        
        }
        return User()
        
    }
    
    func uploadNewPost(withMessage message: String, forUID uid: String, withGroupKey groupKey: String? = nil, sendComplete: @escaping (_ status: Bool) -> ()) {
        DataService.instance.uploadPost(withMessage: message, forUID: uid, withGroupKey: groupKey) { (isCopmlete) in
            sendComplete(isCopmlete)
        }
        
    }
    
    func loadAllGroups(){
        self.refHandle = DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
            DataService.instance.getAllGroups { (returnedGroupsArray) in
//                print(returnedGroupsArray)
                if returnedGroupsArray.count == 0{
                     let group = Group(title: "", description: "", key: "000", members: [], memberCount: 0)
                    self.groupsArray = [group]
                }else{
                    self.groupsArray = returnedGroupsArray
                }
            }
        }
        
    }
    
    func removeAllGroupsObserver(){
        if self.refHandle != nil {
            DataService.instance.REF_GROUPS.removeObserver(withHandle: self.refHandle!)
        }
    }
    
    func loadGroupData(group: Group){
        
        self.groupUsersArray.removeAll()
        self.messageArray.removeAll()
        
        DataService.instance.getUsersFor(group: group) { users in
            
            let temp = self.createUsersArray(usersFromDB: users)
            self.groupUsersArray.removeAll()
            self.groupUsersArray = temp
            self.updateGView.toggle()

        }
        
        DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
            DataService.instance.getAllMessagesFor(desiredGroup: group){ returnedGroupMessages in
                
                if returnedGroupMessages.count > 0{
                    self.messageArray = returnedGroupMessages
                }else{
                    let msg = Message(content: "hey! no mssages yet in this chat,\nplease start chat", senderId: "Chat Admin", msgId: "000")
                    self.messageArray = [msg]
                }
                self.updateGView.toggle()
            }
        }
    }
    
    
    func createUsersArray(usersFromDB users: [FullDBUser]) -> [User]{
        var temp = [User]()
        for user in users{
            let image = #imageLiteral(resourceName: "defaultProfileImage")
            var decodedimage = image
            var decodedimage1:Image = Image("defaultProfileImage")
            
            if user.userImage != nil{
                let dataDecoded : Data = Data(base64Encoded: user.userImage!, options: .ignoreUnknownCharacters)!
                decodedimage = UIImage(data: dataDecoded)!
                decodedimage1 = Image(uiImage: decodedimage)
                
            }
            
            let newUser = User(name: user.name, image: decodedimage, image1: decodedimage1, userImageUrl: user.userImageUrl, senderId: user.key)
            temp.append(newUser)
        }
        return temp
    }
    
    
    
    
    
    
    
    
    
    
    
    func loadUserDataToMessage(_ message: Message, completion: @escaping (_ user: User?, _ message: Message) -> Void){
        
        
        //                for message: Message in self.messageArray{
        //
        //                    self.loadUserDataToMessage(message){ user, msg in
        //                        if user != nil{
        //                            if let row = self.messageArray.firstIndex(where: {$0.msgId == msg.msgId}){
        //
        //                                self.userArray[row] = user!
        //                                self.updateView.toggle()
        //                            }
        //                        }
        //                    }
        //                }

        
        
//        print("message.s = \(message.senderId)")
        if self.oldUserArray.count > 0{
            //            for item in self.oldUserArray {
            //                print("oldUserArray item = \(item.senderId)")
            //            }
            
            if let row = self.oldUserArray.firstIndex(where: {$0.senderId == message.senderId}){
                let user = self.oldUserArray[row]
                completion(user, message)
                return
            }
            
        }
        weak var weakMsg:Message? = message
        
        
        DataService.instance.getUser(forUID: weakMsg!.senderId) { fullDBUser in
            
            if let fullDBUser = fullDBUser {
            let image = #imageLiteral(resourceName: "defaultProfileImage")
            var decodedimage = image
            var decodedimage1:Image = Image("defaultProfileImage")
            
            if fullDBUser.userImage != nil{
                let dataDecoded : Data = Data(base64Encoded: fullDBUser.userImage!, options: .ignoreUnknownCharacters)!
                decodedimage = UIImage(data: dataDecoded)!
                decodedimage1 = Image(uiImage: decodedimage)
                
            }
            let user = User(name: fullDBUser.name, image: decodedimage, image1: decodedimage1, userImageUrl: fullDBUser.userImageUrl, senderId: weakMsg!.senderId)
            print(user.name)
            print(weakMsg!.senderId)
            
            completion(user, weakMsg!)
            }else{
                completion(nil, weakMsg!)

            }
            
        }
    }
    
    func loadTempUsersData(numberOfUsers num:Int) -> [User] {
        var usersArray = [User]()
        let decodedimage1: Image = Image("defaultProfileImage")
        let image = #imageLiteral(resourceName: "defaultProfileImage")

        for _ in 0...num {
            let user = User(name: "", image: image, image1: decodedimage1, userImageUrl: nil, senderId: "String", isLoad: false)
            usersArray.append(user)
            
        }
        return usersArray
    }
    
    
    func createGroup(withTitle title: String, andDescription description: String, forUserEmails emails: [String], handler: @escaping (_ groupCreated: Bool) -> ()) {
        
        DataService.instance.getIds(forUsernames: emails){ idsArray in
            var userIds = idsArray
            userIds.append((Auth.auth().currentUser?.uid)!)

            DataService.instance.createGroup(withTitle: title, andDescription: description, forUserIds: idsArray) { (status) in
                print("groupCreated = \(status)")
                handler(status)
            }
        }
    }
}


extension Collection where Element: Equatable {

    func indexes(_ value :  Element) -> [Index] {
        return self.indices.filter {self[$0] == value}
    }

}
