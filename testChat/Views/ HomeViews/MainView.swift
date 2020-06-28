//
//  MainView.swift
//  testChat
//
//  Created by Israel Berezin on 6/1/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//
//         .background(Color.black.opacity(0.05).edgesIgnoringSafeArea(.all))

import SwiftUI

struct MainView: View {
    
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false

    var body: some View {
        ZStack{
            
            if self.status == false{
                MainLoginView()
            }else{
                HomeScreenView()
                
            }

        }.onAppear {
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                
                self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
            }
        }
    }

    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}




