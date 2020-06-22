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
                    
                        
                        
                    VStack(alignment: .center, spacing: 25){
                        if self.currUserVM.userImageUrl != nil{
                            
                            URLImage(self.currUserVM.userImageUrl!) { proxy in
                                proxy.image
                                    .renderingMode(.original)
                                    .resizable()                     // Make image resizable
                                    .aspectRatio(contentMode: .fill) // Fill the frame
                                    .clipShape(Circle())
                                    .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5036586708)) , radius: 4, x: 4, y: 4)
                                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)), radius: 4, x: -4, y: -4)
                            }
                            .frame(width: 120, height: 120)
                            .padding(.bottom, 25)// Set frame to 100x100.

                        } else {
                            Button(action: {
                                print("Update User Image")
                            }) {
                                self.currUserVM.userImage
                                    .renderingMode(.original)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5036586708)) , radius: 4, x: 4, y: 4)
                                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)), radius: 4, x: -4, y: -4)
                            }.padding(.bottom, 25)
                        }

                        Button(action: {
                            print("Update User Passowrd")
                            self.biometricIDAuth.authenticateUser { (resualtCode) in
                                if resualtCode != nil{
                                    print("touchID successfully - \(resualtCode!)")
                                }
                                else{
                                    print("touchID successfully")
                                    KeychainHelper.instance.updateUserBiometricIDInKeychain()
                                }
                            }

                        }) {
                            Text("Setup Biometrics Login")
                                .font(.headline)
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .frame(width: geometry.size.width - 100, height: 40, alignment: .center)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5036586708)) , radius: 4, x: 4, y: 4)
                                .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)), radius: 4, x: -4, y: -4)
                        }
                        
                        HStack{
                            Rectangle().fill(Color.white)
                                .frame(width: (geometry.size.width - 100)/2 - 20, height: 2, alignment: .center)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5036586708)) , radius: 2, x: 2, y: 2)
                                .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)), radius: 2, x: -2, y: -2)
                            Spacer()
                            Text("Or")
                               .font(.headline)
                               .fontWeight(.semibold)
                               .foregroundColor(Color.black)
                            Spacer()

                            Rectangle().fill(Color.white)
                                .frame(width: (geometry.size.width - 100)/2 - 20, height: 2, alignment: .center)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5036586708)) , radius: 2, x: 2, y: 2)
                                .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)), radius: 2, x: -2, y: -2)

                        }.frame(width: geometry.size.width - 100, height: 40, alignment: .center)

                        
                        Button(action: {
                            print("Logout")
                            self.showLogoutView.toggle()
                        }) {
                            Text("Logout")
                                .font(.headline)
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .frame(width: geometry.size.width - 100, height: 40, alignment: .center)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5036586708)) , radius: 4, x: 4, y: 4)
                                .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)), radius: 4, x: -4, y: -4)
                               // .padding(.top ,50)
                        }
                        
                    }.frame(width: geometry.size.width , height: geometry.size.height - 70 , alignment: .center)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5036586708)) , radius: 4, x: 4, y: 4)
                        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)), radius: 4, x: -4, y: -4)
                        .padding(.top, -35)
                    
                }
                .padding(.horizontal, 35)
                
                
                
                Spacer()
            }
            if self.showLogoutView{
                ErrorView(bodyText: "Are you sure?", messageViewType: .logout, action: {
                    self.loginVM.logout()
                }) {
                    self.showLogoutView.toggle()
                }
            }

        }
        
    }
    
    func aaa(G: GeometryProxy){
        
    }
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}
