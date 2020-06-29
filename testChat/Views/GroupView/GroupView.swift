//
//  GroupView.swift
//  testChat
//
//  Created by Israel Berezin on 6/8/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI
import TextView
import Combine

struct GroupView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var currUserVM: CurrUserVM = CurrUserVM()
    @ObservedObject var feedVM: FeedVM = FeedVM()
    @State var text = ""
    @State var isEditing = false
    
    @State var height : CGFloat = 0 //168
    
    let selectedGroup: Group
    
//    @State var scrollDirection: Int? = 0
    @State var indexPathToSetVisible: IndexPath?

    var body: some View {
        
        //scroll to end of list to first time and each update.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.indexPathToSetVisible = IndexPath(row: self.feedVM.messageArray.count - 1, section: 0)
        }

        return GeometryReader{ geometry in
            VStack{
                if self.feedVM.updateGView{
                    EmptyView()
                }

                TopGroupView(currUserVM: self.currUserVM, feedVM: self.feedVM, selectedGroup: self.selectedGroup)
                    .frame(width: UIScreen.main.bounds.width-32, height: 120) // width: UIScreen.main.bounds.width
                    .padding()
                    .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top)! + 20)
                    .background(bgViewLinearGradient)
                    .clipShape(HomeCorenerShape())

                if self.feedVM.messageArray.count > 0 {

                    VStack {
                        List(self.feedVM.messageArray, id: \.id) {data in
                            GroupChetCell(data: data, user: self.feedVM.getMessageUser(message: data, isGroup: true))

                        }
                        .overlay(
                            
                            ListScrollManagerView(indexPathToSetVisible: self.$indexPathToSetVisible)
                                    .allowsHitTesting(false).frame(width: 0, height: 0)
                        )
                        .background(Color.white)
                        .clipShape(RoundedShape())
                        .onTapGesture {
                            Helper.instance.dissmisKeyborad()
                        }.onAppear {
                            UITableView.appearance().separatorStyle = .none
                        }
                        .onDisappear {
                            UITableView.appearance().separatorStyle = .singleLine
                        }
                    }

                    VStack(spacing: 0.0){
                        HStack(alignment: .bottom){
                            TextView(
                                text: self.$text,
                                isEditing: self.$isEditing,
                                placeholder: "Enter text here"
                            ).frame(height: 50, alignment: .top)
                                .foregroundColor(Color.primary)
                            Button(action: {
                                withAnimation{
                                    self.postToGroup()
                                    Helper.instance.dissmisKeyborad()
                                }
                            }) {
                                Text("Post")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)

                            } .frame(height: 50)
                                .padding([.leading, .trailing],16)
                                .background(bgButtonVLinaerGradient)
                                .cornerRadius(10)
                            

                        }.frame(width: UIScreen.main.bounds.width, height:50)

                            .padding(.bottom, self.height)
                            .onReceive(Publishers.keyboardHeight) { keyboardHeight in
                                
                                withAnimation{

                                    self.updateScreenBykeyboardHeight(keyboardHeight: keyboardHeight, geometry: geometry)

                                }
                            }
                            .animation(.easeOut(duration: self.height > 0 ? 0.16 : 0.16))
                    }
                    .background(Rectangle().fill(Color.white).shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2043904049)), radius: 4))

                } else {
                    VStack{
                        TextShimmer().frame(height: 150).padding().padding(.top, 48)
                        Spacer()
                    }
                }
            }.onAppear{
                self.feedVM.loadGroupData(group: self.selectedGroup)
            }
        }.edgesIgnoringSafeArea(.top)
    }
    
    
    func updateScreenBykeyboardHeight(keyboardHeight: CGFloat, geometry: GeometryProxy){
        
        withAnimation{

            let safeAreaInsetsBottom = geometry.safeAreaInsets.bottom  == 0 ? 28 : geometry.safeAreaInsets.bottom
            let keyboardTop = geometry.frame(in: .local).height - keyboardHeight
            let focusedTextInputBottom = UIResponder.currentFirstResponder?.globalFrame?.maxY ?? 0
            let bottomPadding = max(0, focusedTextInputBottom - keyboardTop - safeAreaInsetsBottom)
            self.height = bottomPadding
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.indexPathToSetVisible = IndexPath(row: self.feedVM.messageArray.count - 1, section: 0)
            }

        }
    }
    
//    func dissmisKeyborad(){
//        let keyWindow = UIApplication.shared.connectedScenes
//            .filter({$0.activationState == .foregroundActive})
//            .map({$0 as? UIWindowScene})
//            .compactMap({$0})
//            .first?.windows
//            .filter({$0.isKeyWindow}).first
//        keyWindow!.endEditing(true)
//    }
    
    func postToGroup(){
        if self.text.count > 0 {
            
            self.feedVM.uploadNewPost(withMessage: self.text, forUID: self.currUserVM.userUid!, withGroupKey: self.selectedGroup.key){ isCopmlete in
                self.text = ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                   self.indexPathToSetVisible = IndexPath(row: self.feedVM.messageArray.count - 1, section: 0)
               }
            }
            
        }
    }
    
}

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        GroupView(feedVM: FeedVM(), selectedGroup: Group(title: "String", description: "String", key: "-M9KDBHQylBtApPRF1SL", members: ["IU8Ns25HckVA8ke4XdUHRbrB4Hb2","KT5692rmtxgzlRUzCoEmwhhr9sr2","LZv6I4ywLzgBfwzGuLifAJVxzKl2","Lv7R3W9LlBNmuW58ksBYJwlNQok2","Qq7tYQGbQffboRq4OptdPWCIJVi2","YEh7C9JxwMSwVghKPe01dWgZgR13","d6fSFRdEXwQaDcmI1a1zgqIlNBG3","Gahfm0AM2RUUi82BZrhcWnLHd6J3"], memberCount: 8))
    }
}




//                        ScrollView(.vertical, showsIndicators: false) {
//
//                            VStack{
//
//                                ForEach(self.feedVM.messageArray, id: \.id){data in
//                                    GroupChetCell(data: data, user: self.feedVM.getMessageUser(message: data, isGroup: true))
//                                }
//                            }
//                        }
//
//                        .padding(.horizontal, 15)
//                        .background(Color.white)
//                        .clipShape(RoundedShape())
//                        .onTapGesture {
//                            self.dissmisKeyborad()
//                        }
                        
