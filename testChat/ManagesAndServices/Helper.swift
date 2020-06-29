//
//  Helper.swift
//  testChat
//
//  Created by israel.berezin on 29/06/2020.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI



var bgViewLinearGradient : LinearGradient{
    return  LinearGradient(gradient: .init(colors: [Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)),Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)),Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
}

var bgButtonVLinaerGradient: LinearGradient{
    return LinearGradient(gradient: .init(colors: [Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)),Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)),Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
}

class Helper: NSObject {
    
    static let instance = Helper()

    
    func dissmisKeyborad(){
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        keyWindow!.endEditing(true)
    }

    
}
