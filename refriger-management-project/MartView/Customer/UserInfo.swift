//
//  UserInfo.swift
//  refriger-management-project
//
//  Created by 조종운 on 2020/08/31.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct UserInfo: View {
    
    @EnvironmentObject var userHelper: UserHelper
    
    @Binding var view: String
    
    @State var userInfo_update_arg = ""
    
    @State var userInfo_update_offset = CGSize.init(width: UIScreen.main.bounds.width, height: 0)
    
    let userInfo_list = ["이메일아이디", "비밀번호", "휴대 전화 번호", "이름"]
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                /* 상단바 - 나가기버튼 | 타이틀 */
                HStack {
                    Button(action: {
                        withAnimation {
                            view = "마트"
                        }
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 15, height: 15)
                    }
                    Spacer()
                    
                    Text("내 정보 수정")
                        .fontWeight(.light)
                        .font(.system(size: 20))
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                
                Divider().background(Color.black.opacity(0.7))
                
                ForEach(userInfo_list, id: \.self) {
                    UserInfoForm(infoType: $0, userInfo_update_arg: self.$userInfo_update_arg, userInfo_update_offset: self.$userInfo_update_offset)
                }
                
                /* 로그아웃 | 회원탈퇴 버튼 */
                HStack(spacing: 15) {
                    Spacer()
                    // 로그아웃 버튼
                    Button(action: {
                        withAnimation {
                            view = "마트"
                            userHelper.login = false
                        }
                    }) {
                        Text("로그아웃")
                    }
                    
                    Text("|")
                    // 회원탈퇴 버튼
                    Button(action: {}) {
                        Text("회원탈퇴")
                    }
                }
                .foregroundColor(Color.gray.opacity(0.7))
                .padding()
                
                Spacer()
            }
            
            UserInfoUpdate(userInfo_update_arg: userInfo_update_arg, userInfo_update_offset: $userInfo_update_offset)
                .offset(x: userInfo_update_offset.width)
                .gesture(DragGesture()
                    .onChanged ({ gesture in
                        if gesture.translation.width > 0 {
                            self.userInfo_update_offset.width = gesture.translation.width
                        }
                    })
                    .onEnded ({ _ in
                        if self.userInfo_update_offset.width >= 150 {
                            withAnimation {
                                self.userInfo_update_offset.width = UIScreen.main.bounds.width
                            }
                        } else {
                            withAnimation {
                                self.userInfo_update_offset.width = 0
                            }
                        }
                    })
                )
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

/* 정보입력 폼 */
struct UserInfoForm: View {
    /* 이메일아이디, 비밀번호, 휴대 전화 번호, 이름 */
    let infoType: String
    
    @Binding var userInfo_update_arg: String
    
    @Binding var userInfo_update_offset: CGSize
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 12) {
                    Text("\(infoType)")
                        .foregroundColor(Color.black.opacity(0.8))
                    
                    if infoType == "이메일아이디" {
                        //Text("\((Auth.auth().currentUser?.email!)!)")
                        Text("이메일")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(Color.gray.opacity(0.8))
                    }
                    
                    else if infoType == "비밀번호" {
                        Text("비밀번호는 변경하실 수 없습니다.")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(Color.black)
                    }
                    
                    else if infoType == "휴대 전화 번호" {
                        Text("01035918251")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(Color.black)
                    }
                    
                    else {
                        Text("조종운")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(Color.black)
                    }
                }
                Spacer()
                
                if infoType == "휴대 전화 번호" || infoType == "이름" {
                    Button(action: {
                        withAnimation {
                            self.userInfo_update_arg = self.infoType
                            self.userInfo_update_offset.width = 0
                        }
                    }) {
                        HStack {
                            Text("변경")
                                .fontWeight(.semibold)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 10)
                        }
                        .overlay(Rectangle().stroke(Color.black, lineWidth: 1))
                    }
                }
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            
            Divider().background(Color.black.opacity(0.7))
        }
    }
}

struct UserInfo_Previews: PreviewProvider {
    static var previews: some View {
        UserInfo(view: .constant("유저정보"))
    }
}
