//
//  ForgetPasswordView.swift
//  testChat
//
//  Created by Israel Berezin on 6/2/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI

struct ForgetPasswordView: View {
    
    @State var color = Color.black.opacity(0.7)
    
    @ObservedObject var loginVM: LoginVM
    @State var mail = ""
    @Binding var showForgetPassView: Bool
    
    var body: some View{
        
        GeometryReader{_ in
            
            VStack{
                
                Text("Please enter you registration mail")
                    .font(.headline)
                    .foregroundColor(self.color)
                
                HStack(spacing: 15){
                    
                    Image(systemName: "envelope")
                        .foregroundColor(.black)
                    
                    TextField("Enter Email Address", text: self.$mail)
                        .font(.headline)
                    
                    
                }.padding(.horizontal,26)
                    .padding(.vertical, 10)
                
                Button(action: {
                    withAnimation{
                        self.showForgetPassView.toggle()
                    }
                    
                }) {
                    
                    Text("Send")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 120)
                }
                .background(Color(.black))
                .cornerRadius(10)
                
            }
            .padding(.vertical, 25)
            .frame(width: UIScreen.main.bounds.width - 70)
            .background(Color.white)
            .cornerRadius(15)
        }
        .background(Color.black.opacity(0.35).edgesIgnoringSafeArea(.all))
    }
}

struct ForgetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgetPasswordView(loginVM: LoginVM(), showForgetPassView: .constant(true))
    }
}
