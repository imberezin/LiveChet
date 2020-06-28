//
//  HomeCorenerShape.swift
//  testChat
//
//  Created by Israel Berezin on 6/10/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI

struct HomeCorenerShape : Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.bottomLeft,.bottomRight], cornerRadii: CGSize(width: 30, height: 30))
        
        return Path(path.cgPath)
    }
}


struct TopHomeCorenerShape : Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 50, height: 50))
        
        return Path(path.cgPath)
    }
}

