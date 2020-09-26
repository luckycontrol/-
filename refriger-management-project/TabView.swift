//
//  TabView.swift
//  refriger-management-project
//
//  Created by 조종운 on 2020/09/19.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI

struct TabView: View {
    
    @EnvironmentObject var tabViewHelper: TabViewHelper
    
    private var imageSize = CGFloat(30)
    
    var body: some View {
        HStack {
            ZStack {
                Color.white
                
                HStack {
                    Button(action: { self.tabViewHelper.view = "식료품관리-선택" }) {
                        VStack {
                            Image(tabViewHelper.view == "식료품관리-선택" ? "식료품관리-선택" : "식료품관리")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: imageSize, height: imageSize)
                            
                            Text("식료품 관리")
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                        }
                    }
                        
                    Spacer()
                    
                    Button(action: { self.tabViewHelper.view = "마트-선택" }) {
                        VStack {
                            Image(tabViewHelper.view == "마트-선택" ? "마트-선택" : "마트")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: imageSize, height: imageSize)
                            
                            Text("식료품 구매")
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                        }
                    }
                    
                }
                .padding(.horizontal, 30)
            }
        
        }
        .frame(height: 100)
        .border(Color.gray)
    }
}

class TabViewHelper: ObservableObject {
    @Published var view = "식료품관리-선택"
    @Published var isOn = true
}



struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabView()
    }
}
