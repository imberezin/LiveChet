//
//  AddNewGruopView.swift
//  testChat
//
//  Created by Israel Berezin on 6/11/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI


struct AddNewGruopView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var feedVM: FeedVM
    @ObservedObject var preferedUsers: PreferedUsers = PreferedUsers()
    
    @State var tilte: String = ""
    @State var description: String = ""
    @State var peoples: String = ""
    
    @State var errerMgs: String = ""
    
    //    @State var choosenUserArray = [String]()
    @State var selectPeopleViewOpen: Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack(spacing: 15){
                Spacer()
                Text("New Group")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                Spacer()
                
            }.frame(height: 100)
                .padding()
                .padding(.top, 20)
                .background(bgViewLinearGradient)
                .clipShape(HomeCorenerShape())
            
            ZStack(alignment: .top){
                
                if self.selectPeopleViewOpen {
                    SettingsUsersPickerView(preferedUsers: self.preferedUsers, isSelectPeopleViewOpen: self.$selectPeopleViewOpen)
                        .padding(.top, -5)
                    
                } else {
                    
                    VStack(spacing: 0.0) {
                        AddNewGroupFormView(preferedUsers: self.preferedUsers, tilte: self.$tilte, description: self.$description, peoples: self.$peoples, selectPeopleViewOpen: self.$selectPeopleViewOpen)
                        HStack{
                            Spacer()
                            Button(action: {
                                print("createNewGroup")
                                self.createNewGroup()
                            }) {
                                Text("Create")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                            .background(bgButtonVLinaerGradient)
                            .cornerRadius(8)
                            .padding()
                            Spacer()
                        }
                        Spacer()
                        
                    }
                    .padding(.top, -5)
                }
                
                if self.errerMgs.count > 0 {
                    ErrorView(bodyText: self.errerMgs, closeAction: {self.errerMgs = ""})

                }

            }.padding(.top, -10)
            //show errorMgs if needed
        }
    }
    
    
    func createNewGroup(){
        if self.tilte.count > 0{
            if self.description.count > 0{
                if self.preferedUsers.selectedUsersString.count > 0{
                    
                    self.feedVM.createGroup(withTitle: self.tilte, andDescription: self.description, forUserEmails: self.preferedUsers.selectedUsersArray){ status in
                        if status{
                            // show good message
                            self.presentationMode.wrappedValue.dismiss()
                            
                        }else{
                            self.errerMgs = "Group creation failed, please try again later"
                        }
                    }
                    
                }else{
                    self.errerMgs = "Please add people to your group"
                }
            }else{
                self.errerMgs = "Please add description to your group"
            }
        }else{
            self.errerMgs = "Please add title to your group"
        }
    }
    
    
}

struct AddNewGruopView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewGruopView(feedVM: FeedVM())
    }
}

