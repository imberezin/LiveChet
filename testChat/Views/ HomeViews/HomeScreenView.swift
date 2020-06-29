//
//  HomeScreenView.swift
//  testChat
//
//  Created by Israel Berezin on 6/2/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI
import Firebase

struct HomeScreenView: View {
    
    @ObservedObject var currUserVM: CurrUserVM = CurrUserVM()
    @ObservedObject var feedVM = FeedVM()
    @ObservedObject var loginVM = LoginVM()

    @State var expand = true
    @State var showLogoutView: Bool = false

    
    var body: some View{
        ZStack{

            VStack{
                HomeTopView(currUserVM: self.currUserVM, feedVM: self.feedVM, expand: self.$expand, showLogoutView: self.$showLogoutView)
                    .frame(height: 120)
                    .padding()
                    .padding(.top, 20)
                    .background(bgViewLinearGradient)
                
                    .clipShape(HomeCorenerShape())
                    
                HomeCenterView(expand: self.$expand, feedVM: self.feedVM)
                    .clipShape(TopHomeCorenerShape())

            }.onAppear{
                print("================================")
                print(self.currUserVM.email)
                print(self.currUserVM.userName)
                print("================================")
                self.feedVM.getAllFeedes()
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
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}







//            Text("Logged successfully")
//                .font(.title)
//                .fontWeight(.bold)
//                .foregroundColor(Color.black.opacity(0.7))
//
//            Button(action: {
//
//                try! Auth.auth().signOut()
//                UserDefaults.standard.set(false, forKey: "status")
//                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
//
//            }) {
//
//                Text("Log out")
//                    .foregroundColor(.white)
//                    .padding(.vertical)
//                    .frame(width: UIScreen.main.bounds.width - 50)
//            }
//            .background(Color(.black))
//            .cornerRadius(10)
//            .padding(.top, 25)

