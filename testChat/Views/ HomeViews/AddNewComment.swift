//
//  AddNewComment.swift
//  testChat
//
//  Created by Israel Berezin on 6/4/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI
import TextView

struct AddNewComment: View {
    @State var text = ""
    @State var isEditing = false
    
    @ObservedObject var currUserVM: CurrUserVM = CurrUserVM()
    @ObservedObject var feedVM: FeedVM

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        ZStack{
            
            VStack(alignment: .leading) {
                
                SimpleTopView(firstRow: "Post something")
                    
                HStack(spacing: 15){
                    self.currUserVM.userImage
                        .staticCircelImageViewModifier(imageSize: CGSize(width: 60, height: 60), shadowRadius: 1, shadowSize: 1)

                    Text(self.currUserVM.userName)
                    Spacer()
                }.padding(.leading)
                
                
                TextView(
                    text: $text,
                    isEditing: $isEditing,
                    placeholder: "Enter text here"
                ).frame(minHeight: 30, maxHeight: 120, alignment: .top).foregroundColor(Color.primary)
                    .background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))).padding()

                HStack{
                    Spacer()
                    Button(action: {
                        self.dissmisKeyborad()
                        self.post()

                    }) {
                        Text("Post")
                            .foregroundColor(.white)
                            .fontWeight(.bold)

                    } .padding()
                        .background(bgButtonVLinaerGradient)
                    .cornerRadius(8)
                        .padding()
                }
                Spacer()
            }.onTapGesture {
                self.dissmisKeyborad()
            }
        }.onAppear(){
            
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
    
    func post(){
        if self.text.count > 0 {
            
            self.feedVM.uploadNewPost(withMessage: self.text, forUID: self.currUserVM.userUid!){ isCopmlete in
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct AddNewComment_Previews: PreviewProvider {
    static var previews: some View {
        AddNewComment(feedVM: FeedVM())
    }
}

