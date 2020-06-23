//
//  AddNewGruopView.swift
//  testChat
//
//  Created by Israel Berezin on 6/11/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI


struct AddNewGruopView: View {
    
    @ObservedObject var currUserVM: CurrUserVM = CurrUserVM()
    @ObservedObject var feedVM: FeedVM
    @ObservedObject var preferedLanguages: PreferedLanguages = PreferedLanguages()
    
    @Environment(\.presentationMode) var presentationMode

    @State var tilte: String = ""
    @State var description: String = ""
    @State var peoples: String = ""
    
    @State var emailArray = [String]()
    @State var choosenUserArray = [String]()
    
    @State var selectPeople: Bool = false
    
    
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
            
            ZStack{
                
                if self.selectPeople{
                    SettingsLanguagePickerView(preferedLanguages: self.preferedLanguages, selectPeople: self.$selectPeople)
                }else{
                    VStack {
                        Form {
                            Section(header: Text("Group Tittle")) {
                                TextField("Tittle", text: $tilte)
                            }
                            
                            
                            Section(header: Text("Group Description")) {
                                TextField("Description", text: $description)
                            }
                            
                            Section(header: HStack {
                                Text("add people to your group")
                                Spacer()
                                //                                     Text("Tap on ➕ to create your's groups")
                                
                                Button(action: {
                                    self.selectPeople.toggle()
                                }) {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                        .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                                }
                            }) {
                                
                                if self.preferedLanguages.allSelected.count > 0{
                                    ScrollView(.vertical, showsIndicators: true){
                                        Text(self.preferedLanguages.allSelected)
                                            .font(.caption)
                                            .fontWeight(.light)
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(nil)
                                    }.frame(minHeight: 15, maxHeight: 45)
                                }else{
                                    EmptyView()
                                }
                                
                                
                            }
                            HStack{
                                Spacer()
                                Button(action: {
                                    self.createNewGroup()
                                }) {
                                    Text("Create")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                    
                                    
                                }.padding(.horizontal,24)
                                    .padding(.vertical,16)
                                    .background(bgButtonVLinaerGradient)
                                    .cornerRadius(8)
                                    .padding()
                                Spacer()
                            }
                        }
                    }  .padding(.top, -10)
                }
            }
            
        }
        
    }
    
    
    func createNewGroup(){
        if self.tilte.count > 0{
            if self.description.count > 0{
                if self.preferedLanguages.allSelected.count > 0{
                    
                    self.feedVM.createGroup(withTitle: self.tilte, andDescription: self.description, forUserEmails: self.preferedLanguages.languages){ status in
                        if status{
                            // show good message
                            self.presentationMode.wrappedValue.dismiss()

                        }else{
                            // show error message
                        }
                    }
                    
                }else{
                    // show no People
                }
            }else{
                //show not description error
            }
        }else{
            // show not title error
        }
    }
}

struct AddNewGruopView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewGruopView(feedVM: FeedVM())
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


class PreferedLanguages: ObservableObject {
    @Published var languages = [String]()
    @Published var allSelected: String = ""
    
    func updateAllSelectedString(){
        if self.languages.count > 0{
            self.allSelected = self.languages.joined(separator:",") // "1-2-3"
            
        }else{
            if self.allSelected.count > 0{
                self.allSelected = ""
            }
        }
    }
    
}


struct SettingsLanguagePickerView: View {
    @State private var selections = [String]()
    
    @State private var allEmails = [String]()
    
    @ObservedObject var preferedLanguages: PreferedLanguages
    
    @Binding var selectPeople: Bool
    
    //    init(_ preferedLanguages: PreferedLanguages) {
    //        self.preferedLanguages = preferedLanguages
    //    }
    
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Choose people to your group")) {
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
            }
            .onAppear(perform: {
                self.getEmails()
                self.selections = self.preferedLanguages.languages
                
            })
                .listStyle(GroupedListStyle())
                .navigationBarTitle("Languages", displayMode: .inline)
                .navigationBarItems(trailing:
                    Button(action: {
                        self.preferedLanguages.languages = self.selections
                        self.preferedLanguages.updateAllSelectedString()
                        //                        self.presentationMode.wrappedValue.dismiss()
                        self.selectPeople.toggle()
                    }) {
                        Text("OK")
                    }
            )
        }
    }
    
    func getEmails() {
        DataService.instance.getEmail(forSearchQuery: "") { (emailsArray) in
            self.allEmails = emailsArray;
        }
        
        
    }
    
}
