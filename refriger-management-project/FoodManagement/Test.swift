//
//  Test.swift
//  refriger-management-project
//
//  Created by 조종운 on 2020/09/01.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI

struct Test: View {
    var body: some View {
        VStack {
            HStack {
                Text("Hello World!")
                Spacer()
            }
            Spacer()
        }
        .background(Color.blue.edgesIgnoringSafeArea(.all))
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
