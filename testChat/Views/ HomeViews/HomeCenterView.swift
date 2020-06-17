//
//  HomeCenterView.swift
//  testChat
//
//  Created by Israel Berezin on 6/4/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI

struct HomeCenterView: View {
    
    @Binding var expand : Bool
    
    @ObservedObject var feedVM: FeedVM
    var body : some View{
        
        VStack{
            if feedVM.messageArray.count > 0 {
                List(feedVM.messageArray){ message in
                    
                    HStack(alignment: .top, spacing: 12){
                        if self.feedVM.updateView{
                            EmptyView()
                        }
                        self.feedVM.getMessageUser(message: message).image1
                            .resizable()
                            .frame(width: 55, height: 55)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 12) {
                            
                            Text(self.feedVM.getMessageUser(message: message).name)
                                .font(.subheadline)
                            
                            Text(message.content).font(.footnote)
                        }
                        
                        Spacer(minLength: 0)
                        
                    }.padding(.vertical)
                    
                    
                }
//                .padding(.top, 20)
//                    .background(Color.white)
//                    .clipShape(HomeCorenerShape())
            }else{
                List{
                    ForEach(0..<6 ,id: \.self){_ in

                        HomeCellShimmer()
                        
                    }
                }
//                .padding(.top, 20)
//                    .background(Color.white)
//                    .clipShape(HomeCorenerShape())
            }
        }.padding(.top, 10)
            .background(Rectangle().fill(Color.white))
    }
}

struct HomeCenterView_Previews: PreviewProvider {
    static var previews: some View {
        HomeCenterView(expand: .constant(true), feedVM: FeedVM())
    }
}
