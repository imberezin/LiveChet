//
//  File.swift
//  testChat
//
//  Created by israel.berezin on 25/06/2020.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI




//NeumorphicImageButton
struct BackgroundNeumorphicWhiteBlackStyle: ButtonStyle {
    
    var frame: CGSize
    
    
    init (size: CGSize){
        print("Init")
        self.frame = size
    }

    
    func makeBody(configuration: Self.Configuration) -> some View {
        print("BackgroundStyle -> makeBody ")
        return configuration.label
            .frame(width: frame.width , height: frame.height, alignment: .center)
            .font(Font.system(size: 17, weight: .bold))
            .foregroundColor(configuration.isPressed ? Color.white : Color.black)
            .background(configuration.isPressed ? Color.black : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .scaleEffect(configuration.isPressed ? 1.1 : 1)
            .shadow(color: configuration.isPressed ? Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)) : Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5036586708)), radius: 4, x: configuration.isPressed ? -4 : 4, y: configuration.isPressed ? -4 : 4)
            .shadow(color: configuration.isPressed ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5036586708)) : Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)), radius: 4, x: configuration.isPressed ? 4 : -4, y: configuration.isPressed ? 4 : -4)
    }
    
}


struct CircleImageBackgroundNeumorphicColorStyle: ButtonStyle {
    
    var frame: CGSize
    
    var backgroundColor: Color = Color.black
    var backgroundSelectedColor: Color = Color.white

    init (size: CGSize, backgroundColor:Color, backgroundSelectedColor: Color){
        print("Init")
        self.frame = size
        self.backgroundColor = backgroundColor
        self.backgroundSelectedColor = backgroundSelectedColor
    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        print("isPressed -> \(configuration.isPressed)")

        return configuration.label
            .frame(width: frame.width , height: frame.height, alignment: .center)
            .padding(.all,5)
            .background(configuration.isPressed ? backgroundSelectedColor : backgroundColor)
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 1.1 : 1)
            .shadow(color: configuration.isPressed ? Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)) : Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5036586708)), radius: 4, x: configuration.isPressed ? -4 : 4, y: configuration.isPressed ? -4 : 4)
            .shadow(color: configuration.isPressed ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5036586708)) : Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)), radius: 4, x: configuration.isPressed ? 4 : -4, y: configuration.isPressed ? 4 : -4)
    }
}


struct BackgroundNeumorphicBackgroundColorStyle<Background: View>: ButtonStyle {
  
    var frame: CGSize
    var backgroundSelectedColor: Background
    var backgroundColor: Background

    func makeBody(configuration: Self.Configuration) -> some View {
        print("BackgroundStyle -> makeBody ")
        return configuration.label
            .frame(width: frame.width , height: frame.height, alignment: .center)
            .font(Font.system(size: 17, weight: .bold))
            .foregroundColor(configuration.isPressed ? Color.white : Color.black)
            .background(configuration.isPressed ? self.backgroundColor : self.backgroundSelectedColor)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .scaleEffect(configuration.isPressed ? 1.1 : 1)
            .shadow(color: configuration.isPressed ? Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)) : Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5036586708)), radius: 2, x: configuration.isPressed ? -4 : 4, y: configuration.isPressed ? -4 : 4)
            .shadow(color: configuration.isPressed ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5036586708)) : Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)), radius: 2, x: configuration.isPressed ? 4 : -4, y: configuration.isPressed ? 4 : -4)
    }
}

