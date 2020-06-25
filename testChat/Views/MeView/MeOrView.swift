//
//  MeOrView.swift
//  testChat
//
//  Created by israel.berezin on 25/06/2020.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI

struct MeOrView: View {
    
    var geometry : GeometryProxy
    
    var body: some View {
        HStack{
            Rectangle().fill(Color.white)
                .frame(width: (geometry.size.width - 100)/2 - 20, height: 2, alignment: .center)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .modifier(StaticNeumorphicWhiteBlackViewModifier(radius: 2, size: 2))
            Spacer()
            Text("Or")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color.black)
            Spacer()
            
            Rectangle().fill(Color.white)
                .frame(width: (geometry.size.width - 100)/2 - 20, height: 2, alignment: .center)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .modifier(StaticNeumorphicWhiteBlackViewModifier(radius: 2, size: 2))
            
        }
    }
}

struct MeOrView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            MeOrView(geometry: geometry)
        }
    }
}
