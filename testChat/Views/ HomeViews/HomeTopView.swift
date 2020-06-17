//
//  HomeTopView.swift
//  testChat
//
//  Created by Israel Berezin on 6/4/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI

struct HomeTopView: View {
    
    @State var search = ""
    @State var showingDetail: Bool = false
    @Binding var expand : Bool
    @Binding var showLogoutView: Bool
    @ObservedObject var currUserVM :CurrUserVM
    @ObservedObject var feedVM: FeedVM

    var bgViewLinearGradient : LinearGradient{
        return  LinearGradient(gradient: .init(colors: [Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)),Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)),Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    
    var body : some View{
        
        VStack(spacing: 16){
            
            if self.expand{
                
                HStack{
                    HStack (alignment: .center){
                        VStack{
                            Button(action: {
                                self.showLogoutView.toggle()
                            }) {
                                
                                self.currUserVM.userImage
                                    .renderingMode(.original)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 30, height: 30)
                                    .clipShape(Circle())
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
                
                TextField("Search", text: self.$search)
                
            }.padding()
                .background(Color.white)
                .cornerRadius(8)
                .padding(.bottom, 10)
            
        }
        
    }
}

struct HomeTopView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTopView(expand: .constant(true), showLogoutView: .constant(false), currUserVM: CurrUserVM(), feedVM: FeedVM())
    }
}
