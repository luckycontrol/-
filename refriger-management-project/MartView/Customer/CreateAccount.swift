//
//  CreateAccount.swift
//  refriger-management-project
//
//  Created by 조종운 on 2020/08/22.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct CreateAccount: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var id = ""
    @State var passwd = ""
    @State var message = ""
    
    @State var createAccountDetail = false
    
    var body: some View {
        VStack {
            /* 타이틀 */
            Text("안녕, 나의 냉장고")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.vertical, 50)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("계정을 생성하시는건가요?")
                    .font(.system(size: 22))
                    .fontWeight(.thin)
                    .foregroundColor(Color.black.opacity(0.8))
                
                /* 아이디 입력 폼 */
                HStack {
                    Image(systemName: "person.fill")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .padding()
                    
                    VStack {
                        TextField("이메일 형식으로 입력해주세요.", text: $id)
                        Divider().padding(.trailing, 15)
                    }
                }
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
                .shadow(color: .gray, radius: 2, x: 2, y: 2)
                .shadow(color: Color.gray.opacity(0.5), radius: 1, x: -1, y: 1)
                
                /* 비밀번호 입력 폼 */
                HStack {
                    Image(systemName: "lock.fill")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .padding()
                    
                    VStack {
                        SecureField("6자 이상을 입력해주세요.", text: $passwd)
                        Divider().padding(.trailing, 15)
                    }
                }
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
                .shadow(color: .gray, radius: 2, x: 2, y: 2)
                .shadow(color: Color.gray.opacity(0.5), radius: 1, x: -1, y: 1)
            }
            .padding(.horizontal, 15)
            
            Text(message)
                .foregroundColor(.red)
                .fontWeight(.semibold)
                .padding(.vertical, 25)
            
            /* 로그인 버튼 */
            Button(action: {
                UserHelper().emailDuplicateCheck(self.id) { (isSuccess, duplicate) in
                    if isSuccess {
                        /* 중복일경우 */
                        if duplicate {
                            self.message = "입력하신 이메일이 이미 존재합니다."
                            UINotificationFeedbackGenerator().notificationOccurred(.error)
                        } else {
                        /* 중복이 아닐 경우*/
                            self.message = ""
                            self.createAccountDetail = true
                        }
                    }
                }
            }) {
                HStack {
                    Text("회원가입")
                }
                .frame(width: 300, height: 50)
                .background(Color("ButtonColor"))
                .foregroundColor(.black)
                .shadow(color: .gray, radius: 2, x: 2, y: 2)
                .shadow(color: Color.gray.opacity(0.5), radius: 1, x: -1, y: -1)
            }.disabled(id.count == 0 || passwd.count == 0)
            
            Spacer()
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $createAccountDetail) {
            CreateAccountDetail(id: self.$id, passwd: self.$passwd, message: self.$message, createAccountDetail: self.$createAccountDetail)
        }
    }
    
    func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct CreateAccount_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreateAccount()
        }
    }
}
