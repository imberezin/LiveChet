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
                    
                    //                    .padding(.top, 20)
                    .background(bgViewLinearGradient)
                    .clipShape(HomeCorenerShape())

                
                if feedVM.groupsArray.count > 0 {
                    
                    List(feedVM.groupsArray){ group in
                        if group.key == "000"{
                            HStack(alignment: .center, spacing: 12){
                                VStack(alignment: .center, spacing: 12) {
                                    
                                    Text("You are not meember in any Group yet\n")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.center)
                                    
                                    Text("Tap on ➕ to create youe group")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.center)

                                    
                                }
                                
                                Spacer(minLength: 0)
                                
                            }.padding(.vertical)

                        } else{
                            NavigationLink(destination: GroupView(selectedGroup: group)){
                                HStack(alignment: .top, spacing: 12){
    //                                if self.feedVM.updateView{
    //                                    EmptyView()
    //                                }
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
                self.feedVM.removeAllGroupsObserver()
            }
                
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.top)
            
        }
        //        .navigationBarHidden(true)
        //       // .navigationBarTitle(Text("Home"))
        //        .edgesIgnoringSafeArea([.top, .bottom])
    }
}

struct AllGroupsView_Previews: PreviewProvider {
    static var previews: some View {
        AllGroupsView()
    }
}
