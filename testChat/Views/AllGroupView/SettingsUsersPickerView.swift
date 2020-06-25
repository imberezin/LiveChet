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
                        print("Select all")
                        self.selections = self.allEmails.map{ $0 }

                    }) {
                        Text("Select all")
                            .font(.headline)
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .frame(width: 150, height: 25, alignment: .center)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                            .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5036586708)) , radius: 4, x: 4, y: 4)
                            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)), radius: 4, x: -4, y: -4)
                    }

                    Spacer()
                    
                    Button(action: {
                        print("Remove all")
                        self.selections.removeAll()

                    }) {
                        Text("Remove all")
                            .font(.headline)
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .frame(width: 150, height: 25, alignment: .center)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                            .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5036586708)) , radius: 4, x: 4, y: 4)
                            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)), radius: 4, x: -4, y: -4)
                    }

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
                .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5036586708)) , radius: 4, x: 4, y: 4)
                .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)), radius: 4, x: -4, y: -4)
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
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .font(.headline)
                    .foregroundColor(.black)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5036586708)) , radius: 4, x: 4, y: 4)
                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)), radius: 4, x: -4, y: -4)
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


