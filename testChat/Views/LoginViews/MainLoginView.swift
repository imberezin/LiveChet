//
//  LoginView.swift
//  testChat
//
//  Created by Israel Berezin on 6/1/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI
import Combine

var bgViewLinearGradient : LinearGradient{
    return  LinearGradient(gradient: .init(colors: [Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)),Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)),Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
}

var bgButtonVLinaerGradient: LinearGradient{
    return LinearGradient(gradient: .init(colors: [Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)),Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)),Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
}

struct MainLoginView: View {
    
    @State var index = 0
    @State var height : CGFloat = 0
    
    @ObservedObject var loginVM: LoginVM = LoginVM()
    
    @State var showForgetPassView: Bool = false
    
    var body: some View {
        
        ZStack{
            ZStack(alignment: .topTrailing){
                
                bgViewLinearGradient.edgesIgnoringSafeArea(.all)
                
                ScrollView(UIScreen.main.bounds.height < 750 ? .vertical : (self.height == 0 ? .init() : .vertical), showsIndicators: false) {
                    
                    VStack{
                        
                        Image("liveChet")
                            .resizable()
                            .frame(width: 180, height: 180)
                            .clipShape(Circle())
                        
                        HStack{
                            
                            Button(action: {
                                
                                withAnimation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5)){
                                    
                                    self.index = 0
                                }
                                
                            }) {
                                
                                Text("Existing")
                                    .font(.title)
                                    .foregroundColor(self.index == 0 ? .black : .white)
                                    .fontWeight(.bold)
                                    .padding(.vertical, 10)
                                    .frame(width: (UIScreen.main.bounds.width - 50) / 2)
                                
                            }.background(self.index == 0 ? Color.white : Color.clear)
                                .clipShape(Capsule())
                            
                            Button(action: {
                                
                                withAnimation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5)){
                                    
                                    self.index = 1
                                }
                                
                            }) {
                                
                                Text("New")
                                    .font(.title)
                                    .foregroundColor(self.index == 1 ? .black : .white)
                                    .fontWeight(.bold)
                                    .padding(.vertical, 10)
                                    .frame(width: (UIScreen.main.bounds.width - 50) / 2)
                                
                            }.background(self.index == 1 ? Color.white : Color.clear)
                                .clipShape(Capsule())
                            
                        }.background(Color.black.opacity(0.1))
                            .clipShape(Capsule())
                            .padding(.top, -15)
                        
                        if self.index == 0{
                            LoginView(loginVM: self.loginVM)
                                .padding(.top, -15)
                        }
                        else{
                            RegisterView(loginVM: self.loginVM)
                                .padding(.top, -15)
                        }
                        
                        if self.index == 0{
                            
                            Button(action: {
                                self.showForgetPassView.toggle()
                            }) {
                                
                                Text("Forget Password?")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                
                            }
                            .padding(.top, 20)
                        }
                                                
                        HStack{
                            Rectangle().fill(Color.white)
                                .frame(height: 2, alignment: .center)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                .modifier(StaticNeumorphicWhiteBlackViewModifier(radius: 2, size: 2))
                            Spacer()
                            Text("Or")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.white)
                            Spacer()
                            
                            Rectangle().fill(Color.white)
                                .frame(height: 2, alignment: .center)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                .modifier(StaticNeumorphicWhiteBlackViewModifier(radius: 2, size: 2))
                        }
                        .padding()
                        .padding(.top, -10)
                        
                        SocialLoginView(loginVM: self.loginVM)
                        
                        Spacer(minLength: self.height )
                        
                        
                    }
                    .padding(.top, 10)
                    
                }
            }.onAppear {
                self.keyboardNotifcations()
            }
            if self.loginVM.alert{
                
                ErrorView(bodyText: self.loginVM.error, closeAction: {self.loginVM.toggleAlert()})
            }
            if self.showForgetPassView{
                ForgetPasswordView(loginVM: self.loginVM, showForgetPassView: self.$showForgetPassView)
            }
            
        }
        
    }
    
    
    func keyboardNotifcations(){
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: .main) { (not) in
            
            let data = not.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
            
            let height = data.cgRectValue.height - (UIApplication.shared.windows.first?.safeAreaInsets.bottom)!
            
            self.height = height //+ 100
            
            // removing outside safeaera height...
            print(height)
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: .main) { (_) in
            
            print("hidden")
            
            self.height = 0
        }
        
    }
}

struct MainLoginView_Previews: PreviewProvider {
    static var previews: some View {
        MainLoginView()
    }
}

struct SocialLoginView: View {
    
    @ObservedObject var loginVM: LoginVM
    
    var body: some View {
        HStack(spacing: 30){
            Button(action: {
                self.loginVM.biometricLogin()
            }) {
                
                self.loginVM.biometricImage()
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFill()
                
            }.buttonStyle(CircleImageBackgroundNeumorphicColorStyle(size: CGSize(width: 40, height: 40), backgroundColor: Color(#colorLiteral(red: 0.101217337, green: 0.458863616, blue: 0.8176777363, alpha: 1)), backgroundSelectedColor: Color(#colorLiteral(red: 0.101217337, green: 0.458863616, blue: 0.8176777363, alpha: 1))))
            
            
            Button(action: {
                self.loginVM.loginWIthGoogle()
            }) {
                
                Image("google")
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFill()
                
            }.buttonStyle(CircleImageBackgroundNeumorphicColorStyle(size: CGSize(width: 40, height: 40), backgroundColor: Color(#colorLiteral(red: 0.101217337, green: 0.458863616, blue: 0.8176777363, alpha: 1)), backgroundSelectedColor: Color(#colorLiteral(red: 0.101217337, green: 0.458863616, blue: 0.8176777363, alpha: 1))))
            
            Button(action: {
                print("login witg FB")
            }) {
                
                Image("fb")
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFill()
            }.buttonStyle(CircleImageBackgroundNeumorphicColorStyle(size: CGSize(width: 40, height: 40), backgroundColor: Color(#colorLiteral(red: 0.101217337, green: 0.458863616, blue: 0.8176777363, alpha: 1)), backgroundSelectedColor: Color(#colorLiteral(red: 0.101217337, green: 0.458863616, blue: 0.8176777363, alpha: 1))))
            
            Button(action: {
                self.loginVM.loginWithApple()
            }) {
                
                Image("appleLogin")
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFill()
            }.buttonStyle(CircleImageBackgroundNeumorphicColorStyle(size: CGSize(width: 40, height: 40), backgroundColor: Color(#colorLiteral(red: 0.101217337, green: 0.458863616, blue: 0.8176777363, alpha: 1)), backgroundSelectedColor: Color(#colorLiteral(red: 0.101217337, green: 0.458863616, blue: 0.8176777363, alpha: 1))))
        }
    }

}
