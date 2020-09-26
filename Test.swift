//
//  Test.swift
//  refriger-management-project
//
//  Created by 조종운 on 2020/09/19.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI

struct Test: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            GeometryReader { geometry in
                Text("\(geometry.frame(in: .global).midY)")
                    .frame(width: geometry.size.width, height: 50)
                    .background(Color.pink)
            }
        }
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
