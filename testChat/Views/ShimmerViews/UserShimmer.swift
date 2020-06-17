//
//  UserShimmer.swift
//  testChat
//
//  Created by Israel Berezin on 6/11/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI


struct AllGroupsCellShimmer: View{
    
    
    @State var show = false
    var center = (UIScreen.main.bounds.width / 2) + 110
    
    var body: some View {
        ZStack{
            
            
            // Shimmer Card..
            
            HStack(spacing: 15){
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    Rectangle()
                        .fill(Color.black.opacity(0.09))
                        .frame(width: 175, height: 15)
                    
                    Rectangle()
                        .fill(Color.black.opacity(0.09))
                        .frame(width: 225, height: 10)
                    
                    Rectangle()
                        .fill(Color.black.opacity(0.09))
                        .frame(width: 275, height: 10)
                }.padding([.top, .bottom])
                
                Spacer(minLength: 0)
            }
            
            // Shimmer Animation...
            
            HStack(spacing: 15){
                
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    Rectangle()
                        .fill(Color.black.opacity(0.09))
                        .frame(width: 175, height: 15)
                    
                    Rectangle()
                        .fill(Color.black.opacity(0.09))
                        .frame(width: 225, height: 10)
                    
                    Rectangle()
                        .fill(Color.black.opacity(0.09))
                        .frame(width: 275, height: 10)
                    
                }.padding([.top, .bottom])
                
                Spacer(minLength: 0)
            }
                // Masking View...
                .mask(
                    
                    Rectangle()
                        .fill(Color.white.opacity(0.6))
                        .rotationEffect(.init(degrees: 70))
                        // Moving View....
                        .offset(x: self.show ? 1000 : -350)
            )
        }
        .onAppear {
            
            print("onAppear")
            withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)){
                
                self.show.toggle()
            }
        }
    }
    
}

struct HomeCellShimmer: View{
    
    @State var show = false
    var center = (UIScreen.main.bounds.width / 2) + 110
    
    var body: some View {
        ZStack{
            
            
            // Shimmer Card..
            
            HStack(spacing: 15){
                
                Circle()
                    .fill(Color.black.opacity(0.09))
                    .frame(width: 55, height: 55)
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    Rectangle()
                        .fill(Color.black.opacity(0.09))
                        .frame(width: 250, height: 15)
                    
                    Rectangle()
                        .fill(Color.black.opacity(0.09))
                        .frame(width: 100, height: 15)
                }
                
                Spacer(minLength: 0)
            }
            
            // Shimmer Animation...
            
            HStack(spacing: 15){
                
                Circle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 75, height: 75)
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    Rectangle()
                        .fill(Color.white.opacity(0.6))
                        .frame(width: 250, height: 15)
                    
                    Rectangle()
                        .fill(Color.white.opacity(0.6))
                        .frame(width: 100, height: 15)
                }
                
                Spacer(minLength: 0)
            }
                // Masking View...
                .mask(
                    
                    Rectangle()
                        .fill(Color.white.opacity(0.6))
                        .rotationEffect(.init(degrees: 70))
                        // Moving View....
                        .offset(x: self.show ? 1000 : -350)
            )
        }
        .onAppear {
            
            print("onAppear")
            withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)){
                
                self.show.toggle()
            }
        }
    }
    
}


struct UserShimmer: View {
    
    @State var show = false
    var center = (UIScreen.main.bounds.width / 2) + 110
    
    var body : some View{
        
        ZStack{
            
            HStack(spacing: 15){
                
                Circle()
                    .fill(Color.black.opacity(0.09))
                    .frame(width: 45, height: 45)
                
                
            }
            
            // Shimmer Animation...
            
            HStack(spacing: 15){
                
                Circle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 45, height: 45)
                
                
            }
                // Masking View...
                .mask(
                    
                    Rectangle()
                        .fill(Color.white.opacity(0.6))
                        .rotationEffect(.init(degrees: 70))
                        // Moving View....
                        .offset(x: show ? 1000 : -350)
            )
        }
        .onAppear {
            
            print("onAppear")
            withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)){
                
                self.show.toggle()
            }
        }
        
    }
    
}

struct UserShimmer_Previews: PreviewProvider {
    static var previews: some View {
        UserShimmer()
    }
}
