//
//  MainView.swift
//  testChat
//
//  Created by Israel Berezin on 6/1/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false

    var body: some View {
        ZStack{
            if self.status == false{
                MainLoginView()
            }else{
//                GroupView(feedVM: FeedVM(), selectedGroup: Group(title: "Berezin F.", description: "My lovely famely group", key: "-M9KDBHQylBtApPRF1SL", members: ["IU8Ns25HckVA8ke4XdUHRbrB4Hb2","KT5692rmtxgzlRUzCoEmwhhr9sr2","LZv6I4ywLzgBfwzGuLifAJVxzKl2","Lv7R3W9LlBNmuW58ksBYJwlNQok2","Qq7tYQGbQffboRq4OptdPWCIJVi2","YEh7C9JxwMSwVghKPe01dWgZgR13","d6fSFRdEXwQaDcmI1a1zgqIlNBG3","Gahfm0AM2RUUi82BZrhcWnLHd6J3"], memberCount: 8))
//                MainLoginView()
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




