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

    @State var tilte: String = ""
    @State var description: String = ""
    @State var peoples: String = ""
    
    @State var emailArray = [String]()
    @State var choosenUserArray = [String]()

    
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

            Form {
                Section(header: Text("Tittle")) {
                    TextField("Tittle", text: $tilte)
                    }
                
            
                Section(header: Text("Description")) {
                    TextField("Description", text: $description)
                }
                
                Section(header: Text("add people to your group")) {
                    TextField("", text: $description,onEditingChanged: {_ in
                        self.getEmails()
                    })
                    
                    List(self.emailArray, id: \.self){ email in
                        HStack{
                            Text(email)
                        }
                    }
                }

            }
            .padding(.top, -10)

        }
            

            
        
    }
    
    
    func getEmails(){
        DataService.instance.getEmail(forSearchQuery: peoples) { (emailsArray) in
            self.emailArray = emailsArray;
            //self.tableView.reloadData()
        }

    }
}

struct AddNewGruopView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewGruopView(feedVM: FeedVM())
    }
}
