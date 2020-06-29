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
        
        let filteredMsg = self.feedVM.searchTerm.isEmpty ? self.feedVM.messageArray : self.feedVM.messageArray.filter { $0.content.lowercased().contains(self.feedVM.searchTerm.lowercased()) }

        return VStack{
            if feedVM.messageArray.count > 0 {
                List(filteredMsg){ message in
                    
                    HStack(alignment: .top, spacing: 12){
                        if self.feedVM.updateView{
                            EmptyView()
                        }
                        self.feedVM.getMessageUser(message: message).image1
                            .staticCircelImageViewModifier(imageSize: CGSize(width: 55, height: 55), shadowRadius: 1, shadowSize: 1)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            
                            Text(self.feedVM.getMessageUser(message: message).name)
                                .font(.subheadline)
                            
                            Text(message.content).font(.footnote)
                        }
                        
                        Spacer(minLength: 0)
                        
                    }.padding(.vertical)
                    
                    
                }
                .animation(nil) // reomve default list animation
                .animation(.linear(duration: 0.3)) // set custom list animation

            }else{
                List{
                    ForEach(0..<6 ,id: \.self){_ in

                        HomeCellShimmer()
                        
                    }
                }
            }
        }.padding(.top, 10)
            //.background(Rectangle().fill(Color.black.opacity(0.15)))
    }
}

struct HomeCenterView_Previews: PreviewProvider {
    static var previews: some View {
        HomeCenterView(expand: .constant(true), feedVM: FeedVM())
    }
}
