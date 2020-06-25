//
//  AddNewGroupFormView.swift
//  testChat
//
//  Created by israel.berezin on 25/06/2020.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI

struct AddNewGroupFormView: View {
    
    @ObservedObject var preferedUsers: PreferedUsers
    
    @Binding var tilte: String
    @Binding var description: String
    @Binding var peoples: String
    @Binding var selectPeopleViewOpen: Bool
    
    
    var body: some View {
        Form {
            Section(header: Text("Group Tittle")) {
                TextField("Tittle", text: $tilte)
            }
            
            Section(header: Text("Group Description")) {
                TextField("Description", text: $description)
            }
            
            
            Section(header: HStack {
                Text("Add people to your group")
                Spacer()
                Button(action: {
                    self.selectPeopleViewOpen.toggle()
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                }
            }) {
                
                if self.preferedUsers.selectedUsersString.count > 0{
                    ScrollView(.vertical, showsIndicators: true){
                        Text(self.preferedUsers.selectedUsersString)
                            .font(.caption)
                            .fontWeight(.light)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                        
                    }.frame(minHeight: 15, maxHeight: 45)
                }else{
                    HStack(alignment: .center) {
                        Spacer()
                        Text("You han't added any member to your group yet\nTap on ➕ to add memberes")
                            .font(.subheadline)
                            .fontWeight(.light)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .lineSpacing(8)
                        Spacer()
                    }
                    
                }
            }
        }
        .frame(minHeight: 250, maxHeight: 300)
        .onTapGesture {
            print("dissmisKeyborad")
            self.dissmisKeyborad()
        }
    }
    
    func dissmisKeyborad(){
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        keyWindow!.endEditing(true)
    }
}

struct AddNewGroupFormView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewGroupFormView(preferedUsers: PreferedUsers(), tilte: .constant("new tilte"), description:  .constant("new description"), peoples: .constant("aaa@aaa.com"), selectPeopleViewOpen: .constant(false))
    }
}
