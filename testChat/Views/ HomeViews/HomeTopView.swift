//
//  HomeTopView.swift
//  testChat
//
//  Created by Israel Berezin on 6/4/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI
import URLImage

struct HomeTopView: View {
    
    @ObservedObject var currUserVM :CurrUserVM
    @ObservedObject var feedVM: FeedVM

    @State var search = ""
    @State var showingDetail: Bool = false
    
    @Binding var expand : Bool
    @Binding var showLogoutView: Bool
    
    var body : some View{
        
        VStack(spacing: 16) {
            
            if self.expand {
                
                HStack{
                    HStack (alignment: .center){
                        VStack{
                            Button(action: {
                                self.showLogoutView.toggle()
                            }) {
                                if self.currUserVM.userImageUrl != nil{
                                    
                                    URLImage(self.currUserVM.userImageUrl!) { proxy in
                                        proxy.image
                                            .staticCircelImageViewModifier(imageSize: CGSize(width: 30, height: 30), shadowRadius: 1, shadowSize: 1)
                                    }
                                }else{
                                    self.currUserVM.userImage
                                        .staticCircelImageViewModifier(imageSize: CGSize(width: 30, height: 30), shadowRadius: 1, shadowSize: 1)
                                }
                            }
                        }
                        Text("Feed")
                            .fontWeight(.bold)
                            .font(.title)
                            .foregroundColor(Color.black.opacity(0.7))
                        
                    }
                    Spacer()
                    Button(action: {
                        self.showingDetail.toggle()
                    }) {
                        
                        Image(systemName: "pencil.and.ellipsis.rectangle")
                            .imageScale(.medium)
                            .font(Font.system(size: 30, weight: .bold))
                            .foregroundColor(.black)
                    }.sheet(isPresented: $showingDetail) {
                        AddNewComment(feedVM: self.feedVM)
                    }
                }
            }
            
            HStack(spacing: 15){
                
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundColor(Color.black.opacity(0.3))
                
                TextField("Search", text: self.$feedVM.searchTerm)
                
            }.padding()
                .background(Color.white)
                .cornerRadius(8)
                .padding(.bottom, 10)
            
        }
        
    }
}

struct HomeTopView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTopView(currUserVM: CurrUserVM(), feedVM: FeedVM(), expand: .constant(false), showLogoutView: .constant(false))
    }
}
//         HomeTopView(expand: .constant(true), showLogoutView: .constant(false), currUserVM: CurrUserVM(), feedVM: FeedVM())

