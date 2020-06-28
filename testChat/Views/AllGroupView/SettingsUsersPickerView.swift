//
//  SettingsUsersPickerView.swift
//  testChat
//
//  Created by israel.berezin on 25/06/2020.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI

struct SettingsUsersPickerView: View {
    
    @State private var selections = [String]()
    
    @State private var allEmails = [String]()
    
    @ObservedObject var preferedUsers: PreferedUsers
    
    @Binding var isSelectPeopleViewOpen: Bool
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                HStack{
                    
                    Button(action: {
                        withAnimation{
                            self.selections = self.allEmails.map{ $0 }
                        }
                
                    }) {
                        Text("Select all")
                    }.buttonStyle(BackgroundNeumorphicWhiteBlackStyle(size: CGSize(width: 150, height: 25)))
                    
                    Spacer()
                    
                    Button(action: {
                        print("Remove all")
                        withAnimation{
                            self.selections.removeAll()
                        }
                        
                    }) {
                        Text("Remove all")
                    }.buttonStyle(BackgroundNeumorphicWhiteBlackStyle(size: CGSize(width: 150, height: 25)))
                    
                }.padding([.top, .horizontal],16)
                
                List {
                    ForEach(self.allEmails ,id:\.self ) { item in
                        MultipleSelectionRow(title: item, isSelected: self.selections.contains(item)) {
                            if self.selections.contains(item) {
                                self.selections.removeAll(where: { $0 == item })
                            }
                            else {
                                self.selections.append(item)
                            }
                        }
                    }
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .modifier(StaticNeumorphicWhiteBlackViewModifier(radius: 4, size: 4))
                .padding([.horizontal],16)
                .padding([.bottom,],24)
            }
            .onAppear(perform: {
                self.getEmails()
                self.selections = self.preferedUsers.selectedUsersArray
                
            })
                .edgesIgnoringSafeArea(.bottom)
                
                .navigationBarTitle("Choose people to your group", displayMode: .inline)
                .navigationBarItems(trailing:
                    Button(action: {
                        self.preferedUsers.selectedUsersArray = self.selections
                        self.preferedUsers.updateAllSelectedString()
                        self.isSelectPeopleViewOpen.toggle()
                    }) {
                        Text("Done")
                    }
                    .buttonStyle(BackgroundNeumorphicWhiteBlackStyle(size: CGSize(width: 75, height: 25)))
            )
        }
    }
    
    func getEmails() {
        DataService.instance.getEmail(forSearchQuery: "") { (emailsArray) in
            self.allEmails = emailsArray;
        }
    }
    
}

struct SettingsUsersPickerView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsUsersPickerView(preferedUsers: PreferedUsers(), isSelectPeopleViewOpen: .constant(false))
    }
}

struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.title)
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark").foregroundColor(.blue)
                }
            }
        }.foregroundColor(Color.black)
    }
}


class PreferedUsers: ObservableObject {
    @Published var selectedUsersArray = [String]()
    @Published var selectedUsersString: String = ""
    
    func updateAllSelectedString(){
        if self.selectedUsersArray.count > 0{
            self.selectedUsersString = self.selectedUsersArray.joined(separator:",") // "1-2-3"
            
        }else{
            if self.selectedUsersString.count > 0{
                self.selectedUsersString = ""
            }
        }
    }
}


