//
//  TopAllGroupsView.swift
//  testChat
//
//  Created by israel.berezin on 28/06/2020.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI

struct TopAllGroupsView: View {

    @ObservedObject var feedVM: FeedVM
    @State var showingDetail: Bool = false
    
    var body: some View {

        ZStack (alignment: .topTrailing){
            HStack(spacing: 15){
                Spacer()
                Text("Group")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            
            Button(action: {
                self.showingDetail.toggle()
            }) {
                
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                    .padding(18)
                
            }.background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)).opacity(0.5))
                .clipShape(Circle())
                .offset(y:-20)
                .sheet(isPresented: $showingDetail) {
                    AddNewGruopView(feedVM: self.feedVM)
            }
            
        }.frame(height: 120)
            .padding()
            .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top)! + 20)
            .background(bgViewLinearGradient)
            .clipShape(HomeCorenerShape())
    }
}

struct TopAllGroupsView_Previews: PreviewProvider {
    static var previews: some View {
        TopAllGroupsView(feedVM: FeedVM())
    }
}
