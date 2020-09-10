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
    
    @State var userName: String = ""
    @State var hp: String = ""
    @State var address: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.createAccountDetail = false
                }) {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .foregroundColor(.black)
                    
                }.padding()
                Spacer()
            }.padding(.bottom, 30)
            
            /* 타이틀 */
            Text("안녕, 나의 냉장고")
                .font(.largeTitle)
                .fontWeight(.thin)
                .padding(.bottom, 50)
            
            /* 이름, 휴대폰번호, 주소 입력 셀 */
            VStack(alignment: .leading, spacing: 30) {
                
                Text("배송에 필요한 정보를 입력해주세요.")
                    .font(.system(size: 22))
                    .fontWeight(.thin)
                    .foregroundColor(Color.black.opacity(0.8))
                
                CreateAccountUserInfoCell(action: "이름", info: $userName)
                CreateAccountUserInfoCell(action: "휴대폰 번호", info: $hp)
                CreateAccountUserInfoCell(action: "주소", info: $address)
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 30)
            
            /* 기입버튼 */
            Button(action: {
                UserHelper().insertUserInfo(id: self.id, passwd: self.passwd, name: self.userName, hp: self.hp, address: self.address) { (isSuccess) in
                    if isSuccess {
                        self.message = "성공적으로 가입되었습니다!"
                        self.id = ""
                        self.passwd = ""
                        self.createAccountDetail = false
                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                    }
                }
            }) {
                HStack {
                    Text("기입완료")
                }
                .frame(width: 300, height: 50)
                .background(Color("ButtonColor"))
                .foregroundColor(.black)
                .shadow(color: .gray, radius: 2, x: 2, y: 2)
                .shadow(color: Color.gray.opacity(0.5), radius: 1, x: -1, y: -1)
            }.disabled(userName.count == 0 || hp.count == 0 || address.count == 0)
            
            Spacer()
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

/* 개인정보 입력 셀 */
struct CreateAccountUserInfoCell: View {
    
    let action: String
    @Binding var info: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack {
                    TextField("\(action)", text: $info)
                        .keyboardType(action == "휴대폰 번호" ? .numberPad : .default)

                    Divider().background(Color.black.opacity(0.7))
                }
            }
        }
    }
}

struct CreateAccountDetail_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountDetail(id: .constant(""), passwd: .constant(""), message: .constant(""), createAccountDetail: .constant(false))
    }
}
