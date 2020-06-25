//
//  ErrorView.swift
//  testChat
//
//  Created by Israel Berezin on 6/2/20.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI


enum MessageViewType: Int{
    case error, resetPasswford, logout
}
struct ErrorView: View {
    
    @State var color = Color.black.opacity(0.7)
    let bodyText: String
    var messageViewType: MessageViewType = .error
    
    let action: () -> Void
    let closeAction: () -> Void
    
    init(bodyText: String ,messageViewType: MessageViewType = .error, action: @escaping () -> Void = {},closeAction: @escaping () -> Void){
        self.bodyText = bodyText
        self.messageViewType = messageViewType
        self.action = action
        self.closeAction = closeAction
    }


    var body: some View{
        
        GeometryReader{_ in
            
            VStack{
                
                HStack{
                    
                    Text(self.titleText())
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(self.color)
                    
                    Spacer()
                    Button(action: {
                        self.closeAction()
                    }) {
                        
                        Image(systemName: "xmark.circle")
                            .imageScale(.medium)
                            .font(Font.system(size: 30, weight: .bold))
                            .foregroundColor(Color("Color2"))
                    }

                    
                }
                .padding(.horizontal, 25)
                
                Text(self.bodyText)
                .lineLimit(nil)
                .foregroundColor(self.color)
                .padding(.top)
                .padding(.horizontal, 25)
                
                Button(action: {
                    withAnimation{

                        self.action()
                        self.closeAction()
                    }
                    
                }) {
                    
                    Text(self.buttonText())
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 120)
                }
                .background(Color(.black))
                .cornerRadius(10)
                .padding(.top, 25)
                
            }
            .padding(.vertical, 25)
            .frame(width: UIScreen.main.bounds.width - 70)
            .background(Color.white)
            .cornerRadius(15)
        }
        .background(Color.black.opacity(0.35).edgesIgnoringSafeArea(.all))
    }
    
    func titleText() ->String{
        switch self.messageViewType {
        case .error:
            return "Error"
        case .resetPasswford:
            return "Message"
        case .logout:
            return "Logout"
        }
    }
    
    func buttonText() ->String{
        switch self.messageViewType {
        case .error:
            return "Ok"
        case .resetPasswford:
            return "Message"

        case .logout:
                return "Logout"
        }
    }

}



struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(bodyText: "string", closeAction: {})
    }
}
