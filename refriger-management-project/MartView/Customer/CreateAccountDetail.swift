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
    
    @EnvironmentObject var userHelper: UserHelper
    
    @Binding var id: String
    
    @Binding var passwd: String
    
    @Binding var message: String
    
    @Binding var createAccountDetail: Bool
    
    @State private var name = ""
    
    @State private var nameStatus = false
    
    @State private var address = ""
    
    @State private var addressStatus = false
    
    @State private var hp = ""
    
    @State private var hpStatus = false
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                HStack {
                    Text("회원가입")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }.padding(.horizontal)
                
                HStack {
                    Text("배송을 위해 정보를 입력해주세요")
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.horizontal)
                
                VStack(spacing: 35) {
                    UserInfoCell(inputType: "이름", inputInfo: $name, inputStatus: $nameStatus)
                    
                    if nameStatus {
                        UserInfoCell(inputType: "주소", inputInfo: $address, inputStatus: $addressStatus)
                    }
                    
                    if nameStatus && addressStatus {
                        UserInfoCell(inputType: "휴대폰 번호", inputInfo: $hp, inputStatus: $hpStatus)
                    }
                }
                .padding(.vertical, 30)
                
            }
            
            Spacer()
            
            if nameStatus && addressStatus && hpStatus {
                Button(action: {
                    userHelper.insertUserInfo(id: id, passwd: passwd, name: name, hp: hp, address: address) { isSucess in
                        message = "계정이 생성되었습니다!"
                        createAccountDetail = false
                    }
                }) {
                    Text("회원가입")
                        .fontWeight(.bold)
                        .frame(width: UIScreen.main.bounds.width * 4/5, height: 50)
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 15).foregroundColor(Color("CategoryColor")))
                        .shadow(radius: 3)
                }
            }
        }
        .padding()
    }
}

struct UserInfoCell: View {
    
    let inputType: String
    
    @Binding var inputInfo: String
    
    @Binding var inputStatus: Bool
    
    var body: some View {
        VStack {
            HStack {
                TextField(inputType, text: $inputInfo)
                    .onTapGesture {
                        withAnimation {
                            inputStatus = false
                        }
                    }
                    
                if !inputStatus {
                    Button(action: {
                        withAnimation {
                            inputStatus = true
                        }
                    }) {
                        Text("확인")
                            .fontWeight(.bold)
                            .frame(width: 80, height: 60)
                            .foregroundColor(.white)
                            .background(RoundedRectangle(cornerRadius:15).foregroundColor(Color("CategoryColor")))
                    }
                }
            }
            
            Divider()
        }
    }
}

struct InputTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(20)
            .background(RoundedRectangle(cornerRadius: 15).stroke(Color.gray.opacity(0.5), lineWidth: 2))
    }
}

struct CreateAccountDetail_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountDetail(id: .constant(""), passwd: .constant(""), message: .constant(""), createAccountDetail: .constant(false))
            .environmentObject(TabViewHelper())
            .environmentObject(UserHelper())
    }
}
