//
//  GroupChetCell.swift
//  testChat
//
//  Created by Israel Berezin on 6/10/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI

struct GroupChetCell: View {
    
//    @ObservedObject var feedVM: FeedVM
    let data: Message
    let user: User
    
    var body: some View {
                
                HStack{
                    
                    if data.myMsg{
                        
                        Spacer()
                        Text(data.content)
                            .font(.headline)
                            .padding()
                            .background(Color(#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 0.8992627641)))
                            .clipShape(MsgTail(mymsg: data.myMsg))
                            .foregroundColor(.white)
                        
                    }
                    else{
                        
                        VStack(alignment: .leading, spacing: 5.0) {
                            Text(self.user.name)
                                .font(.footnote)
                                .foregroundColor(Color.gray)
                            Text(data.content)
                                .font(.headline)
                            
                            
                        }.padding().background(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.09619828345)))
                            .clipShape(MsgTail(mymsg: data.myMsg))
                        
                        Spacer()
                    }
                    
                }.padding(data.myMsg ? .leading : .trailing, 55)
                    .padding(.vertical, 5)
            }
}

//struct GroupChetCell_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupChetCell(feedVM: FeedVM())
//    }
//}


