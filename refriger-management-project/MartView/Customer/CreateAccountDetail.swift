//
//  CreateAccountDetail.swift
//  refriger-management-project
//
//  Created by 조종운 on 2020/08/31.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

/* 휴대전화번호랑 이름 입력받기 */
struct CreateAccountDetail: View {
    
    @Binding var id: String
    @Binding var passwd: String
    @Binding var message: String
    @Binding var createAccountDetail: Bool
    
    var body: some View {
        VStack {
            Text("Hello")
        }
    }
}

struct CreateAccountDetail_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountDetail(id: .constant(""), passwd: .constant(""), message: .constant(""), createAccountDetail: .constant(false))
            .environmentObject(TabViewHelper())
            .environmentObject(UserHelper())
    }
}
