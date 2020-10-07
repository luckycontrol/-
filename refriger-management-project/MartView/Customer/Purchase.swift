//
//  Purchase.swift
//  refriger-management-project
//
//  Created by 조종운 on 2020/09/03.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct Purchase: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var cartHelper: CartHelper
    
    @State private var loadUserInfo = false
    
    @State private var userInfo = User(userName: "", hp: "", address: "")
    
    @State private var detailAddress = ""
    
    @State private var totalPrice = ""
    
    @State private var purhcaseAlertStatus = false
    
    var user_email = (Auth.auth().currentUser?.email)!
    
    // MARK: 결제 Alert
    var purchaseAlert: Alert {
        Alert(
            title: Text("결제하시겠습니까?"),
            primaryButton: .default(Text("결제"), action: {
                cartHelper.purchase(user_email, totalPrice, userInfo)
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                presentationMode.wrappedValue.dismiss()
            }),
            secondaryButton: .cancel(Text("취소"))
        )
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            // MARK: 배달정보 - 주소
            if loadUserInfo {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("배달정보")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .padding(.bottom, 10)
                        
                        Text("\(userInfo.address)")
                            .font(.system(size: 22))
                            .fontWeight(.bold)
                    }.padding(20)
                    
                    HStack {
                        TextField("상세주소", text: $detailAddress)
                            .padding(10)
                    }
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding()
                    
                }
                .background(Color.white)
                .padding(.top, 10)
                .shadow(color: .gray, radius: 0.2, x: 0, y: 1)
                
                /* 휴대전화번호 */
                HStack {
                    HStack {
                        Text("\(userInfo.hp)")
                            .font(.system(size: 18))
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Button(action: {}) {
                            HStack {
                                Text("변경")
                                    .foregroundColor(.black)
                                    .padding(8)
                            }
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }.padding(20)
                }
                .background(Color.white)
                .padding(.vertical, 10)
                .shadow(color: .gray, radius: 0.2, x: 0, y: 1)
                
                /* 결제금액 */
                VStack {
                    VStack(alignment: .leading) {
                        Text("결제금액")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .padding(.bottom, 20)
                        
                        HStack {
                            Text("주문금액")
                                .fontWeight(.thin)
                            
                            Spacer()
                            
                            Text("\(totalPrice) 원")
                        }.padding(.bottom, 10)
                        
                        HStack {
                            Text("배달팁")
                                .fontWeight(.thin)
                            
                            Spacer()
                            
                            Text("1,000원")
                        }
                        
                        Divider()
                            .background(Color.black)
                        
                        HStack {
                            Text("총 결제금액")
                            
                            Spacer()
                            
                            Text("\(totalPrice) 원")
                                .font(.system(size: 20))
                        }
                        
                    }
                    .padding(20)
                }
                .background(Color.white)
                .padding(.vertical, 10)
                .shadow(color: .gray, radius: 0.2, x: 0, y: 1)
                
                /* 결제버튼 */
                Button(action: { self.purhcaseAlertStatus = true }) {
                    HStack {
                        Text("결제하기")
                    }
                    .frame(width: 300, height: 50)
                    .foregroundColor(.black)
                    .background(Color("ButtonColor"))
                    .cornerRadius(5)
                    .shadow(color: .gray, radius: 1, x: 2, y: 2)
                    
                }.padding(.top, 30)
                .alert(isPresented: $purhcaseAlertStatus, content: { purchaseAlert })
            }
        }
        .frame(width: UIScreen.main.bounds.width)
        .background(Color.gray.opacity(0.2).edgesIgnoringSafeArea(.bottom))
        .navigationBarTitle("결제하기", displayMode: .inline)
        .onAppear {
            /* 사용자 정보를 불러온다. */
            CartHelper().getUserInfo((Auth.auth().currentUser?.email!)!) { isSuccess, user in
                if isSuccess {
                    self.loadUserInfo = true
        
                    self.userInfo.userName = user.userName
                    self.userInfo.hp = user.hp
                    self.userInfo.address = user.address
                }
        
                /* 최종결제금액 게산 */
                self.totalPrice = self.calTotalPrice()
            }
        }
    }
    
    /* 최종결제금액 계산 */
    func calTotalPrice() -> String {
        var totalPrice = 0
        
        /* 콤마제거 -> 갯수만큼 곱 -> 콤마삽입 */
        for food in cartHelper.cartlist {
            var str_food = food.foodPrice
            
            str_food = cartHelper.sub_comma(str_food)
            
            totalPrice += Int(str_food)!
        }
        
        return cartHelper.add_comma(String(totalPrice))
    }
}

struct Purchase_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Purchase(cartHelper: CartHelper())
        }
    }
}
