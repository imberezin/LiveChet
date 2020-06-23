//
//  Message.swift
//  IBBreakpoint
//
//  Created by Israel Berezin on 11/8/18.
//  Copyright © 2018 Israel Berezin. All rights reserved.
//

import Foundation
import Firebase

class Message : Identifiable{
    
    let id = UUID()
    
    private var _content: String
    private var _senderId: String
    private var _msgId: String
    
    private var _myMsg: Bool

    var msgId: String{
        return _msgId
    }

    var content: String{
        return _content
    }
    var senderId: String{
        return _senderId
    }

    
    var myMsg:Bool{
        
        let user = Auth.auth().currentUser
        if let user = user{
            if user.uid == self.senderId{
                return true
            }else{
                return false
            }
        }
        return _myMsg
    }
    
    var adminMsg:Bool{
        if self._msgId == "000"{
            return true
        }
        return false
    }

    init (content: String, senderId: String, msgId:String ){
        self._content = content
        self._senderId = senderId
        self._msgId = msgId
        self._myMsg = false
    }
}

extension Message: CustomStringConvertible {
    var description: String {
        return "msgId = \(_msgId) , senderId = \(_senderId), content = \(_content)"
    }
}
