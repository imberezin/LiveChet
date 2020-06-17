//
//  TextShimmer.swift
//  testChat
//
//  Created by Israel Berezin on 6/10/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI

struct TextShimmer: View {
    
    @State var show = false
    
    var body : some View{
        
        
        ZStack(alignment: .center){
            
            Text("Loading...")
                .foregroundColor(Color.black.opacity(0.4))
                .font(.system(size: 40))
            
            Text("Loading...")
                .foregroundColor(.black)
                .font(.system(size: 40))
                .mask(
                    Capsule()
                        .fill(LinearGradient(gradient: .init(colors: [.clear,.white,.clear]), startPoint: .top, endPoint: .bottom))
                        .rotationEffect(.init(degrees: 30))
                        .offset(x: self.show ? 180 : -130)
            )
        }
            
        .onAppear {
            
            withAnimation(Animation.default.speed(0.15).delay(0).repeatForever(autoreverses: false)){
                
                self.show.toggle()
            }
        }
    }
}

//struct TextShimmer_Previews: PreviewProvider {
//    static var previews: some View {
//        TextShimmer()
//    }
//}
