//
//  LoginView.swift
//  testChat
//
//  Created by Israel Berezin on 6/2/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI
import Firebase
//import FIRAuth


struct LoginView: View {
    
    @State var mail = ""
    @State var pass = ""
    
    @State var visible = false
    @ObservedObject var loginVM: LoginVM
    
    var body : some View{
        
        VStack{
            
            VStack{
                
                HStack(spacing: 15){
                    
                    Image(systemName: "envelope")
                        .foregroundColor(.black)
                    
                    TextField("Enter Email Address", text: self.$mail)
                        .font(.headline)

                    
                }.padding(.vertical, 20)
                
                Divider()
                
                HStack(spacing: 15){
                    
                    Image(systemName: "lock")
                        .resizable()
                        .frame(width: 15, height: 18)
                        .foregroundColor(.black)
                    
                    if self.visible{
                        TextField("Password", text: self.$pass)
                            .font(.headline)
                    }else{
                        SecureField("Password", text: self.$pass)
                            .font(.headline)
                    }
                    
                    Button(action: {
                        self.visible.toggle()
                    }) {
                        
                        Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.black)
                    }
                    
                }.padding(.vertical, 20)
                
            }
            .padding(.vertical)
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .modifier(StaticNeumorphicWhiteBlackViewModifier(radius: 4, size: 4))
            .padding(.top, 25)
            
            Button(action: {
                self.verify()
            }) {
                
                Text("LOGIN")

            }
            .buttonStyle(BackgroundNeumorphicBackgroundColorStyle(frame: CGSize(width: UIScreen.main.bounds.width - 100, height: 60), backgroundSelectedColor: bgButtonVLinaerGradient, backgroundColor: bgButtonVLinaerGradient))
            .offset(y: -40)
            .padding(.bottom, -40)

            }
            .padding(.horizontal)

    }
    
    func verify(){
        
        if self.mail != "" && self.pass != ""{
            
            self.loginVM.login(mail: self.mail, password: self.pass)
            
        }else{
            
            self.loginVM.updateError(errorText: "Please fill all the contents properly")
            
        }
    }

}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loginVM: LoginVM())
    }
}
