//
//  GroupView.swift
//  testChat
//
//  Created by Israel Berezin on 6/8/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI

struct AllGroupsView: View {
    
    @ObservedObject var currUserVM: CurrUserVM = CurrUserVM()
    @ObservedObject var feedVM = FeedVM()
    
    @State var showingDetail: Bool = false
    
    var body: some View {
        NavigationView {
            VStack{
                
                TopAllGroupsView(feedVM: self.feedVM)                
                
                if feedVM.groupsArray.count > 0 {
                    
                    List(feedVM.groupsArray){ group in
                        if group.key == "000"{
                            HStack(alignment: .center, spacing: 12){
                                VStack(alignment: .center, spacing: 12) {
                                    
                                    Text("You are not meember in any Group yet\n")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.center)
                                    
                                    Text("Tap on ➕ to create your's groups")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.center)
                                }
                                
                                Spacer(minLength: 0)
                                
                            }.padding(.vertical)
                            
                        } else{
                            NavigationLink(destination: GroupView(selectedGroup: group)){
                                HStack(alignment: .top, spacing: 12) {
                                    VStack(alignment: .leading, spacing: 12) {
                                        
                                        Text(group.groupTitle.uppercased())
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                        
                                        Text(group.groupDesc).font(.footnote)
                                        
                                        Text("\(group.memberCount) Members").font(.footnote)
                                        
                                    }
                                    
                                    Spacer(minLength: 0)
                                    
                                }.padding(.vertical)
                            }
                        }
                    }.padding(.top,16)
                        .onAppear {
                            UITableView.appearance().separatorStyle = .none
                    }
                    .onDisappear {
                        UITableView.appearance().separatorStyle = .singleLine
                    }
                }else{
                    List{
                        
                        ForEach(0 ..< 6 ,id: \.self){_ in
                            
                            AllGroupsCellShimmer()
                            
                        }
                    }.padding(.top,16)
                }
                Spacer()
                
            }.onAppear{
                self.feedVM.loadAllGroups()
            }.onDisappear{
                if self.showingDetail == false {
                    self.feedVM.removeAllGroupsObserver()
                }
            }
                
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.top)
            
        }
    }
}

struct AllGroupsView_Previews: PreviewProvider {
    static var previews: some View {
        AllGroupsView()
    }
}


