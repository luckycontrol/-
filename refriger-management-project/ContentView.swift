//
//  ContentView.swift
//  refriger-management-project
//
//  Created by 조종운 on 2020/08/22.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            
            Test()
                .tabItem {
                    Image("refriger")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("냉장고")
            }
            
            MartHome()
                .tabItem {
                    Image(systemName: "bag")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text("식자재 구입")
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
