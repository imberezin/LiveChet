//
//  TopGroupView.swift
//  testChat
//
//  Created by Israel Berezin on 6/10/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI



struct TopGroupView: View {
    
    
    @ObservedObject var currUserVM: CurrUserVM
    @ObservedObject var feedVM: FeedVM
    let selectedGroup: Group
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack (alignment: .topLeading) {
            VStack(alignment: .center, spacing: 8){
                
                Text(self.selectedGroup.groupTitle)
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                Text(self.selectedGroup.groupDesc)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                
                
                VStack {
                    if self.feedVM.groupUsersArray.count > 0{
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            HStack(spacing: 18){
                                
                                ForEach(0 ..< self.feedVM.groupUsersArray.count ,id: \.self){i in
                                    
                                    VStack{
                                        
                                        Button(action: {
                                            
                                        }) {
                                            
                                            self.feedVM.groupUsersArray[i].image1
                                                .staticCircelImageViewModifier(imageSize: CGSize(width: 30, height: 30), shadowRadius: 1, shadowSize: 1)
                                                .padding(.all, self.currUserVM.isMyUser(user: self.feedVM.groupUsersArray[i]) ? 2 : 0)
                                                .overlay(self.currUserVM.isMyUser(user: self.feedVM.groupUsersArray[i]) ? Circle().stroke(lineWidth: 1).foregroundColor(Color(#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 0.8992627641))).padding(.all, 1) : nil)
                                        }
                                        
                                        Text(self.feedVM.groupUsersArray[i].name)
                                            .font(.footnote)
                                            .fontWeight(.medium)
                                            .foregroundColor(Color.black)
                                            .lineLimit(1)
                                        
                                    }.frame(width: 40)
                                }
                            }
                        }
                    }else{
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            HStack(alignment: .center, spacing: 18){
                                
                                ForEach(0 ..< selectedGroup.members.count ,id: \.self){i in
                                    UserShimmer()
                                }
                            }
                        }
                    }
                }.frame(height: 45)
            }
            
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                
                Image(systemName: "chevron.left")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                    .padding(18)
                
            }.background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)).opacity(0.5))
                .clipShape(Circle())
        }
    }
}

struct TopGroupView_Previews: PreviewProvider {
    static var previews: some View {
        TopGroupView(currUserVM: CurrUserVM(), feedVM: FeedVM(), selectedGroup: Group(title: "String", description: "String", key: "-M9KDBHQylBtApPRF1SL", members: ["IU8Ns25HckVA8ke4XdUHRbrB4Hb2","KT5692rmtxgzlRUzCoEmwhhr9sr2","LZv6I4ywLzgBfwzGuLifAJVxzKl2","Lv7R3W9LlBNmuW58ksBYJwlNQok2","Qq7tYQGbQffboRq4OptdPWCIJVi2","YEh7C9JxwMSwVghKPe01dWgZgR13","d6fSFRdEXwQaDcmI1a1zgqIlNBG3","Gahfm0AM2RUUi82BZrhcWnLHd6J3"], memberCount: 8))
    }
}





