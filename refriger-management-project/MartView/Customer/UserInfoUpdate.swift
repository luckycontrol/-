//
//  UserInfoUpdate.swift
//  refriger-management-project
//
//  Created by 조종운 on 2020/09/01.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI

struct UserInfoUpdate: View {
    
    let userInfo_update_arg: String
    
    @Binding var userInfo_update_offset: CGSize
    
    var body: some View {
        VStack {
            /* 상단 바 - 휴대전화번호 변경 | 이름 변경 */
            HStack {
                Button(action: {
                    withAnimation {
                        self.userInfo_update_offset.width = UIScreen.main.bounds.width
                    }
                }) {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .frame(width: 15, height: 15)
                }
                Spacer()
                
                Text("\(userInfo_update_arg) 변경")
                    .fontWeight(.light)
                    .font(.system(size: 20))
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            
            Divider().background(Color.black.opacity(0.7))
            
            Spacer()
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

struct UserInfoUpdate_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoUpdate(userInfo_update_arg: "휴대 전화 번호", userInfo_update_offset: .constant(CGSize.zero))
    }
}
