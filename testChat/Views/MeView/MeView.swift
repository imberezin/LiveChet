//
//  MeView.swift
//  testChat
//
//  Created by Israel Berezin on 6/15/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI
import UIKit
import URLImage

struct MeView: View {
    
    @ObservedObject var currUserVM: CurrUserVM = CurrUserVM()
    @ObservedObject var loginVM = LoginVM()
    
    @State var showLogoutView: Bool = false
    @State var image: Image? = nil
    @State var showCaptureImageView: Bool = false
    
    private let biometricIDAuth = BiometricIDAuth()
    
    
    var body: some View {
        
        ZStack (alignment: .center){
            
            VStack(alignment: .center)
            {
                
                HStack(spacing: 15){
                    Spacer()
                    VStack(spacing: 15){
                        Text("Me")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(Color.black)
                            .multilineTextAlignment(.center)
                        Text(self.currUserVM.email)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.black)
                            .multilineTextAlignment(.center)
                        
                    }
                    Spacer()
                    
                }.frame(height: 100)
                    .padding()
                    .padding(.top, 20)
                    .background(bgViewLinearGradient)
                    .clipShape(HomeCorenerShape())
                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)) , radius: 4, x: 4, y: 4)
                
                GeometryReader{ geometry in
                    
                    VStack(alignment: .center, spacing: 25) {
                        if self.currUserVM.userImageUrl != nil {
                            
                            URLImage(self.currUserVM.userImageUrl!) { proxy in
                                proxy.image
                                    .staticCircelImageViewModifier(imageSize: CGSize(width: 120, height: 120))
                                
                            }.padding(.bottom, 25)
                            
                        } else {
                            
                            Button(action: {
                                self.showCaptureImageView.toggle()
                            }) {
                                if self.image != nil{
                                    self.image!
                                        .staticCircelImageViewModifier(imageSize: CGSize(width: 120, height: 120))
                                }else{
                                    self.currUserVM.userImage
                                        .staticCircelImageViewModifier(imageSize: CGSize(width: 120, height: 120))
                                }
                            }.padding(.bottom, 25)
                        }
                        
                        Button(action: {
                            self.biometricIDAuthSetupLogin()
                        }){
                            Text("Setup Biometrics Login")
                        }.buttonStyle(BackgroundNeumorphicWhiteBlackStyle(size: CGSize(width: geometry.size.width - 100, height: 40)))
                        
                        MeOrView(geometry: geometry)
                            .frame(width: geometry.size.width - 100, height: 40, alignment: .center)
                        
                        Button(action: {
                            self.showLogoutView.toggle()
                        }){
                            Text("Logout")
                        }.buttonStyle(BackgroundNeumorphicWhiteBlackStyle(size: CGSize(width: geometry.size.width - 100, height: 40)))
                        
                        
                    }.frame(width: geometry.size.width , height: geometry.size.height - 70 , alignment: .center)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        .modifier(StaticNeumorphicWhiteBlackViewModifier(radius: 4, size: 4))
                        .padding(.top, -35)
                    
                }
                .padding(.horizontal, 35)
                
                Spacer()
            }
            // xcode 12...
            //        .onChange(of: image) { [self.image] newImage in
            //                print("image update")
            //            }
            
            if self.showLogoutView {
                ErrorView(bodyText: "Are you sure?", messageViewType: .logout, action: {
                    self.loginVM.logout()
                }) {
                    self.showLogoutView.toggle()
                }
            }
            
            if showCaptureImageView {
                CaptureImageView(isShown: $showCaptureImageView, image: $image)
            }
            
        }
    }
    
    
    func biometricIDAuthSetupLogin() {
        
        self.biometricIDAuth.authenticateUser { (resualtCode) in
            if resualtCode != nil{
                print("touchID successfully - \(resualtCode!)")
            }
            else{
                print("touchID successfully")
                KeychainHelper.instance.updateUserBiometricIDInKeychain()
            }
        }
        
    }
    
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}


