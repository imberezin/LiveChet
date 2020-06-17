//
//  RegisterView.swift
//  testChat
//
//  Created by Israel Berezin on 6/2/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI
import Firebase

struct RegisterView: View {
    
    @State var mail = ""
    @State var pass = ""
    @State var repass = ""
    
    @State var visiblePass = false
    @State var visibleRePass = false

//    @Binding var alert: Bool
//    @Binding var error: String

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
                    if self.visiblePass{
                        TextField("Password", text: self.$pass)
                            .font(.headline)
                    }else{
                        SecureField("Password", text: self.$pass)
                            .font(.headline)
                    }
                    
                    Button(action: {
                        self.visiblePass.toggle()
                    }) {
                        
                        Image(systemName: self.visiblePass ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.black)
                    }
                    
                }.padding(.vertical, 20)
                
                Divider()
                
                HStack(spacing: 15){
                    
                    Image(systemName: "lock")
                        .resizable()
                        .frame(width: 15, height: 18)
                        .foregroundColor(.black)
                    if self.visibleRePass{
                        TextField("Re-Enter", text: self.$repass)                                .font(.headline)
                    }else{
                        SecureField("Re-Enter", text: self.$repass)                                .font(.headline)
                    }
                    
                    Button(action: {
                        self.visibleRePass.toggle()
                    }) {
                        
                        Image(systemName: self.visibleRePass ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.black)
                    }
                    
                }.padding(.vertical, 20)
                
            }
            .padding(.vertical)
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5036586708)) , radius: 4, x: 4, y: 4)
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)), radius: 4, x: -4, y: -4)
            .padding(.top, 25)
            
            
            Button(action: {
                self.register()
            }) {
                
                Text("SIGNUP")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 100)
                
            }.background(
                
                LinearGradient(gradient: .init(colors: [Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)),Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)),Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
            )
                .cornerRadius(8)
                .offset(y: -40)
                .padding(.bottom, -40)
                .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5036586708)) , radius: 2, x: 4, y: 4)
                .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)), radius: 2, x: -4, y: -4)

        }
        .padding(.horizontal)
    }
    
    func register(){
        
        if self.mail != ""{
            
            if self.pass == self.repass{
                
                self.loginVM.register(email: self.mail, password: self.pass)
                
            }
            else{
                self.loginVM.updateError(errorText: "Password mismatch")
            }
        }
        else{
            self.loginVM.updateError(errorText: "Please fill all the contents properly")
        }
    }

}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(loginVM: LoginVM())
    }
}
