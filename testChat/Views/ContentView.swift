//
//  ContentView.swift
//  testChat
//
//  Created by Israel Berezin on 6/1/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var index = 0
    
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    
    var body: some View {
        VStack(spacing: 0){
            
            ZStack{
                
                if self.index == 0{
                    
                    if self.status == false{
                        MainLoginView()
                    }else{
                        HomeScreenView()
                    }
                }
                else if self.index == 1{
                    if self.status == false{
                        MainLoginView()
                    }else{
                        AllGroupsView()
                    }
                }
                else if self.index == 2{
                    if self.status == false{
                        MainLoginView()
                    }else{
                        MeView()
                    }
                    
                }
            }
            
            CircleTab(index: self.$index)//.background(bgViewLinearGradient).edgesIgnoringSafeArea(.bottom)
            
        }
        .edgesIgnoringSafeArea([.top, .bottom])
        .onAppear {
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                
                self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



struct CircleTab : View {
    
    @Binding var index : Int
    
    var body : some View{
        
        
        HStack{
            
            Button(action: {
                
                self.index = 0
                
            }) {
                
                VStack{
                    
                    if self.index != 0{
                        
                        Image("feed-tabIcon").foregroundColor(Color.black.opacity(0.2)).padding(.top, 20)
                    }
                    else{
                        
                        Image("feed-tabIcon")
                            .resizable()
                            .frame(width: 25, height: 23)
                            .foregroundColor(.white)
                            .padding(.all, 12)
                            .background(bgButtonVLinaerGradient)
                            .clipShape(Circle())
                            .offset(y: -20)
                            .padding(.bottom, -20)
                        
                        Text("Feed").foregroundColor(Color.black.opacity(0.7))
                    }
                }
            }
            
            Spacer(minLength: 15)
            
            Button(action: {
                
                self.index = 1
                
            }) {
                
                VStack{
                    
                    if self.index != 1{
                        
                        Image("groups-tabIcon").foregroundColor(Color.black.opacity(0.2)).padding(.top, 20)
                    }
                    else{
                        
                        Image("groups-tabIcon")
                            .resizable()
                            .frame(width: 23, height: 23)
                            .foregroundColor(.white)
                            .padding(.all, 12)
                            .background(bgViewLinearGradient)
                            .clipShape(Circle())
                            .offset(y: -20)
                            .padding(.bottom, -20)
                        
                        Text("Groups").foregroundColor(Color.black.opacity(0.7))
                    }
                }
            }
            
            Spacer(minLength: 15)
            
            Button(action: {
                
                self.index = 2
                
            }) {
                
                VStack{
                    
                    if self.index != 2{
                        
                        Image("me-tabIcon").foregroundColor(Color.black.opacity(0.2)).padding(.top, 20)
                    }
                    else{
                        
                        Image("me-tabIcon")
                            .resizable()
                            .frame(width: 24, height: 22)
                            .foregroundColor(.white)
                            .padding(.all, 12)
                            .background(bgViewLinearGradient)
                            .clipShape(Circle())
                            .offset(y: -20)
                            .padding(.bottom, -20)
                        
                        Text("Me").foregroundColor(Color.black.opacity(0.7))
                    }
                }
            }
            
        }.padding(.vertical,-10)
            .padding(.horizontal, 25)
            .padding(.bottom, 40)
            .background(bgViewLinearGradient)
            .animation(.spring())
    }
}




//     @State private var selection = 0
//        TabView(selection: $selection){
//            MainView()
//                .font(.title)
//                .tabItem {
//                    VStack {
//                        Image("feed-tabIcon").renderingMode(.template)
//                        Text("Feed")
//                    }
//            }
//            .tag(0)
//            AllGroupsView()
//                .font(.title)
//                .tabItem {
//                    VStack {
//                        Image("groups-tabIcon").renderingMode(.template)
//                        Text("Groups")
//                    }
//            }
//            .tag(1)
//            SettingsView()
//                .font(.title)
//                .tabItem {
//                    VStack {
//                        Image("me-tabIcon").renderingMode(.template)
//                        Text("Me")
//                    }
//            }
//            .tag(2)
//
//        }
