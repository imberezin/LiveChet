//
//  StaticNeumorphicWhiteBlackViewModifier.swift
//  testChat
//
//  Created by israel.berezin on 25/06/2020.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI

struct StaticNeumorphicWhiteBlackViewModifier: ViewModifier {

    let radius: CGFloat
    
    let size: CGFloat

    func body(content: Content) -> some View {
        
        content
            .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5036586708)), radius: radius, x: size, y: size)
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)), radius: radius, x: -size, y: -size)

    }
}



extension Image {
    func staticCircelImageViewModifier(imageSize: CGSize, shadowRadius: CGFloat = 4, shadowSize: CGFloat = 4) -> some View {
        self
            .renderingMode(.original)
            .resizable()
            .scaledToFill()
            .frame(width: imageSize.width, height: imageSize.height)
            .clipShape(Circle())
            .modifier(StaticNeumorphicWhiteBlackViewModifier(radius: shadowRadius, size: shadowSize))
    }
}
