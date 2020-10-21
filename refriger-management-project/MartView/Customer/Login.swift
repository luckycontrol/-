//
//  Login.swift
//  refriger-management-project
//
//  Created by 조종운 on 2020/08/22.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct Login: View {
    
    @EnvironmentObject var tabViewHelper: TabViewHelper
    @EnvironmentObject var userHelper: UserHelper
    
    @Binding var view: String
    
    @State var id = ""
    @State var passwd = ""
    
    @State var backbutton = true
    
    var body: some View {
        NavigationView {
            
            VStack {
                VStack(alignment: .leading, spacing: 15) {
                    Text("계정이 있으신가요?")
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
                            TextField("이메일을 입력해주세요.", text: $id)
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
                            SecureField("비밀번호를 입력해주세요.", text: $passwd)
                            Divider().padding(.trailing, 15)
                        }
                    }
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
                    .shadow(color: .gray, radius: 2, x: 2, y: 2)
                    .shadow(color: Color.gray.opacity(0.5), radius: 1, x: -1, y: 1)
                    
                    /* 아이디 비밀번호 찾기 */
                    Button(action: {}) {
                        Text("아이디 / 비밀번호 찾기")
                            .foregroundColor(Color.black.opacity(0.6))
                    }
                }
                .padding(.horizontal, 15)
                .padding(.bottom, 50)
                
                //MARK: 로그인 버튼
                Button(action: {
                    Auth.auth().signIn(withEmail: self.id, password: self.passwd) { authResult, error in
                        if let error = error {
                           print(error)
                        } else {
                            // 로그인 성공
                            userHelper.getUserInfo(id: self.id) { isSuccess, address, hp, name in
                                
                                if isSuccess {
                                    userHelper.userEmail = self.id
                                    userHelper.userAddress = address
                                    userHelper.userHp = hp
                                    userHelper.userName = name
                                    
                                    userHelper.login = true
                                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                                    withAnimation {
                                        view = "마트"
                                    }
                                }
                            }
                        }
                    }
                }) {
                    HStack {
                        Text("로그인")
                    }
                    .frame(width: 300, height: 50)
                    .background(Color("ButtonColor"))
                    .foregroundColor(.black)
                    .shadow(color: .gray, radius: 2, x: 2, y: 2)
                    .shadow(color: Color.gray.opacity(0.5), radius: 1, x: -1, y: -1)
                }.disabled(id.count == 0 || passwd.count == 0)
                .padding(.bottom, 30)
                
                /* 회원가입 버튼 */
                NavigationLink(destination: CreateAccount()) {
                    Text("회원가입")
                        .foregroundColor(Color.black.opacity(0.6))
                }
                
            }
            .background(Color.white.edgesIgnoringSafeArea(.all))
            .navigationBarTitle("안녕, 나의 냉장고")
            .navigationBarItems(leading:
                /* 로그인 뷰 닫기 버튼 */
                Button(action: {
                    withAnimation {
                        view = "마트"
                        self.id = ""
                        self.passwd = ""
                        tabViewHelper.isOn = true
                    }
                }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 15, height: 15)
                }
            )
        }
        .accentColor(.black)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login(view: .constant("로그인"))
    }
}
