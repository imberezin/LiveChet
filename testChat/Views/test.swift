//
//  test.swift
//  testChat
//
//  Created by israel.berezin on 25/06/2020.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI

struct test: View {
    var body: some View {
        VStack {
            Text("Text 1")
            Form {
                Section(header: VStack(alignment: .center, spacing: 0) {
                    Text("Text 2").padding(.all, 16)
                        .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                        .background(Color.white)
                }) {
                    EmptyView()
                }.padding([.top], -6)
            }
        }
    }
}

struct test_Previews: PreviewProvider {
    static var previews: some View {
        test()
    }
}
