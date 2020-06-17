//
//  User.swift
//  IBBreakpoint
//
//  Created by Israel Berezin on 11/15/18.
//  Copyright © 2018 Israel Berezin. All rights reserved.
//

import UIKit
import SwiftUI
class User : Identifiable {
    
    let id = UUID()
    private var _name: String = ""
    private var _image: UIImage = #imageLiteral(resourceName: "defaultProfileImage")
    private var _isLoad:Bool = false
    private var _image1: Image = Image("defaultProfileImage")
    private var _senderId: String

    var name: String{
        return _name
    }
    var image: UIImage{
        return _image
    }
    
    var image1: Image{
        return _image1
    }

    var isLoad:Bool{
        return _isLoad
    }
    
    init (){
        self._isLoad = false
        self._senderId = ""
    }
    
    var senderId: String{
        return _senderId
    }

    init (name: String, image: UIImage, image1: Image, senderId: String, isLoad: Bool){
        self._name = name
        self._image = image
        self._image1 = image1
        self._isLoad = isLoad
        self._senderId = senderId
    }

    init (name: String, image: UIImage, image1: Image, senderId: String){
        self._name = name
        self._image = image
        self._image1 = image1
        self._isLoad = true
        self._senderId = senderId
    }
    
    init (name: String, image: UIImage, image1: Image){
        self._name = name
        self._image = image
        self._image1 = image1
        self._isLoad = false
        self._senderId = ""
    }

    
    func toggleUserIsLoad(){
        self._isLoad = !_isLoad

    }
    func updateUser(name: String, image: UIImage){
        self._name = name
        self._image = image
        self._isLoad = true
    }
    
}

extension User: CustomStringConvertible {
    var description: String {
        return "name = \(_name) , isLoad = \(_isLoad), _senderId = \(_senderId)"
    }
}
