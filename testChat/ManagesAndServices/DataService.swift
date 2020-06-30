//
//  DataService.swift

import Foundation
import Firebase

let DB_BASE = Database.database().reference()
typealias FullDBUser =  (name: String, provider: String, userImage: String?, userImageUrl: String?, key: String)
typealias BasicDBUser =  (key: String, name: String)


class DataService {
    
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_USERS_IDS = DB_BASE.child("usersIds")
    private var _REF_USERS_TYPING_NOW = DB_BASE.child("uypingNow")
    
    private var _REF_GROUPS = DB_BASE.child("groups")
    private var _REF_FEED = DB_BASE.child("feed")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS_TYPING_NOW: DatabaseReference {
        return _REF_USERS_TYPING_NOW
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_USERS_IDS: DatabaseReference {
        return _REF_USERS_IDS
    }
    
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
    }
    
    var REF_FEED: DatabaseReference {
        return _REF_FEED
    }
    
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
        
        REF_USERS_IDS.child(uid).updateChildValues(["email":userData["email"]!])
    }
    
    func addTypingUser(group: Group ,uid: String, email: String){
        
        REF_USERS_TYPING_NOW.child(group.key).child(uid).updateChildValues(["email": email, "senderId": uid])
    }
    
    func removeTypingUser(group: Group, uid:String){
        
        REF_USERS_TYPING_NOW.child(group.key).child(uid).setValue(nil)
        // REF_USERS_TYPING_NOW.child(uid).removeValue()
    }
    
    func getTypingNow(group: Group, _ handler: @escaping (_ allUsers : [BasicDBUser]) -> ()) {
        
        var allUsers : [BasicDBUser] = []
        
        REF_USERS_TYPING_NOW.child(group.key).observeSingleEvent(of: .value) { (userSnapshot) in
            //REF_USERS_TYPING_NOW.child(group.key).observeSingleEvent(of: .value) { (userSnapshot) in
            
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {
                return
                
            }
            for user in userSnapshot { // provider
                
                let user: BasicDBUser = (key: user.key, name: user.childSnapshot(forPath: "email").value as! String)
                
                allUsers.append(user)
            }
            handler(allUsers)
            
        }
    }
    
    func updateUserImage(image: String) {
        
        let currUser = Auth.auth().currentUser!
        
        var userData = ["provider": currUser.providerID, "email": currUser.email!,"userImage": image] as [String : Any]
        if let provider = currUser.providerData.first?.providerID{
            userData = ["provider": provider, "email": currUser.email!,"userImage": image] as [String : Any]
        }
        
        DataService.instance.createDBUser(uid: currUser.uid, userData: userData)
    }
    
    func getUsername(forUID uid: String, handler: @escaping (_ username: String) -> ()) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (userSnapshot) in
            
            if userSnapshot.key == uid, let email = userSnapshot.childSnapshot(forPath: "email").value as? String {
                handler(email)
            } else {
                return
            }
        }
    }
    
    func getUser(forUID uid: String, handler: @escaping (_ fullDBUser: FullDBUser?) -> ()) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (userSnapshot) in
            
            if userSnapshot.key == uid, let email = userSnapshot.childSnapshot(forPath: "email").value as? String {
                handler((name: email, provider: userSnapshot.childSnapshot(forPath: "provider").value as! String, userImage: userSnapshot.childSnapshot(forPath: "userImage").value as? String, userImageUrl :userSnapshot.childSnapshot(forPath: "userImageUrl").value as? String, key: userSnapshot.key))
                
            } else {
                return
            }
        }
    }
    
    
    func getAllBasicUsersData(_ handler: @escaping (_ allUsers : [BasicDBUser]) -> ()) {
        
        var allUsers : [BasicDBUser] = []
        
        REF_USERS_IDS.observeSingleEvent(of: .value) { (userSnapshot) in
            
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {
                return
                
            }
            for user in userSnapshot { // provider
                
                let user: BasicDBUser = (key: user.key, name: user.childSnapshot(forPath: "email").value as! String)
                
                allUsers.append(user)
            }
            handler(allUsers)
            
        }
    }
    
    func getUsers(forUID uids: [String], handler: @escaping (_ allUsers : [FullDBUser]) -> ()) {
        var allUsers : [FullDBUser] = []
        
        
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                if uids.firstIndex(where: {$0 == user.key}) != nil{
                    
                    allUsers.append((name: user.childSnapshot(forPath: "email").value as! String,provider: user.childSnapshot(forPath: "provider").value as! String, userImage: user.childSnapshot(forPath: "userImage").value as? String, userImageUrl :user.childSnapshot(forPath: "userImageUrl").value as? String, key: user.key))
                }
            }
            handler(allUsers)
            
        }
    }
        
    func getUsersFor(group: Group, handler: @escaping (_ usersGroupArray: [FullDBUser]) -> ()) {
        
        self.getUsers(forUID: group.members) { (theUserNameAndImage) in
            handler(theUserNameAndImage)
        }
    }
    
    func getUserImage(forUID uid: String, handler: @escaping (_ userImage: String?) -> ()) {
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (userSnapshot) in
            
            if userSnapshot.key == uid{
                handler(userSnapshot.childSnapshot(forPath: "userImage").value as? String)
            } else {
                return
            }
        }
    }
    
    func uploadPost(withMessage message: String, forUID uid: String, withGroupKey groupKey: String?, sendComplete: @escaping (_ status: Bool) -> ()) {
        if groupKey != nil {
            REF_GROUPS.child(groupKey!).child("messages").childByAutoId().updateChildValues(["content": message, "senderId": uid])
            sendComplete(true)
        } else {
            REF_FEED.childByAutoId().updateChildValues(["content": message, "senderId": uid])
            sendComplete(true)
        }
    }
    
    func getAllFeedMessages(handler: @escaping (_ messages: [Message]) -> ()) {
        var messageArray = [Message]()
        REF_FEED.observeSingleEvent(of: .value) { (feedMessageSnapshot) in
            guard let feedMessageSnapshot = feedMessageSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for message in feedMessageSnapshot {
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderId").value as! String
                let message = Message(content: content, senderId: senderId, msgId: message.key)
                messageArray.append(message)
            }
            
            handler(messageArray)
        }
    }
    
    func getAllMessagesFor(desiredGroup: Group, handler: @escaping (_ messagesArray: [Message]) -> ()) {
        var groupMessageArray = [Message]()
        REF_GROUPS.child(desiredGroup.key).child("messages").observeSingleEvent(of: .value) { (groupMessageSnapshot) in
            guard let groupMessageSnapshot = groupMessageSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for groupMessage in groupMessageSnapshot {
                let content = groupMessage.childSnapshot(forPath: "content").value as! String
                let senderId = groupMessage.childSnapshot(forPath: "senderId").value as! String
                
                let groupMessage = Message(content: content, senderId: senderId, msgId: groupMessage.key)
                groupMessageArray.append(groupMessage)
            }
            handler(groupMessageArray)
        }
    }
    
    func getEmail(forSearchQuery query: String, handler: @escaping (_ emailArray: [String]) -> ()) {
        var emailArray = [String]()
        REF_USERS_IDS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                
                if email.uppercased().contains(query.uppercased()) == true && email != Auth.auth().currentUser?.email {
                    emailArray.append(email)
                } else if query == "" {
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    //REF_USERS_IDS
    func getIds(forUsernames usernames: [String], handler: @escaping (_ uidArray: [String]) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            var idArray = [String]()
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                
                if usernames.contains(email) {
                    idArray.append(user.key)
                }
            }
            handler(idArray)
        }
    }
    
    //REF_USERS_IDS
    func getEmailsFor(group: Group, handler: @escaping (_ emailArray: [String]) -> ()) {
        var emailArray = [String]()
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                if group.members.contains(user.key) {
                    let email = user.childSnapshot(forPath: "email").value as! String
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    func createGroup(withTitle title: String, andDescription description: String, forUserIds ids: [String], handler: @escaping (_ groupCreated: Bool) -> ()) {
        REF_GROUPS.childByAutoId().updateChildValues(["title": title, "description": description, "members": ids])
        handler(true)
    }
    
    func getAllGroups(handler: @escaping (_ groupsArray: [Group]) -> ()) {
        var groupsArray = [Group]()
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapshot) in
            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for group in groupSnapshot {
                let memberArray = group.childSnapshot(forPath: "members").value as? [String]
                if (memberArray != nil){
                    if memberArray!.contains((Auth.auth().currentUser?.uid)!) {
                        let title = group.childSnapshot(forPath: "title").value as! String
                        let description = group.childSnapshot(forPath: "description").value as! String
                        let group = Group(title: title, description: description, key: group.key, members: memberArray!, memberCount: memberArray!.count)
                        groupsArray.append(group)
                    }
                }
            }
            handler(groupsArray)
        }
    }
}















/*
 func getUsername(forUID uid: String, handler: @escaping (_ username: String) -> ()) {
 REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
 guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
 for user in userSnapshot {
 if user.key == uid {
 handler(user.childSnapshot(forPath: "email").value as! String)
 }
 }
 }
 }
 
 func getUser(forUID uid: String, handler: @escaping (_ fullDBUser: FullDBUser?) -> ()) {
 REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
 guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
 for user in userSnapshot {
 if user.key == uid {
 handler((name: user.childSnapshot(forPath: "email").value as! String,provider: user.childSnapshot(forPath: "provider").value as! String, userImage: user.childSnapshot(forPath: "userImage").value as? String, userImageUrl :user.childSnapshot(forPath: "userImageUrl").value as? String, key: user.key))
 
 }
 }
 }
 }
 
 
 func getUserImage(forUID uid: String, handler: @escaping (_ userImage: String?) -> ()) {
 REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
 guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
 for user in userSnapshot {
 if user.key == uid {
 handler(user.childSnapshot(forPath: "userImage").value as? String)
 }
 }
 }
 }
 
 */
