//
//  Cart.swift
//  refriger-management-project
//
//  Created by 조종운 on 2020/08/22.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct Cart: View {
    
    @EnvironmentObject var tabViewHelper: TabViewHelper
    
    @EnvironmentObject var userHelper: UserHelper
    
    @Binding var view: String
    
    @Binding var cartlist: [CartFoodType]
    
    @State var cartEdit = false
    
    @State var purchaseStatus = false
    
    @State var purchaseAlertStatus = false
    
    @State var purchase_offset = CGSize.init(width: UIScreen.main.bounds.width, height: 0)
    
    /* 결제버튼 누를 시 팝업되는 Alert */
    var purchaseAlert: Alert {
        Alert(
            title: Text("결제하시겠습니까?"),
            primaryButton: .default(Text("결제"), action: { self.purchaseStatus = true }),
            secondaryButton: .destructive(Text("취소"))
        )
    }
    
    var body: some View {
        NavigationView {
            VStack {
                /* 장바구니 리스트 출력 */
                if cartlist.count == 0 {
                    Text("장바구니가 비었습니다.")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        /* 리스트 출력 */
                        ForEach(cartlist, id: \.self) {
                            Cart_FoodCell(cartEdit: self.$cartEdit, cartlist: $cartlist, cartFoodInfo: $0)
                        }
                        
                        /* 결제버튼 */
                        NavigationLink(destination: Purchase(cartlist: $cartlist), isActive: self.$purchaseStatus) {
                            Button(action: { self.purchaseAlertStatus = true }) {
                                HStack {
                                    Text("구매하기")
                                        .fontWeight(.semibold)
                                }
                                .frame(width: 300, height: 50)
                                .background(Color("ButtonColor"))
                                .cornerRadius(20)
                                .shadow(color: .gray, radius: 2, x: 2, y: 2)
                                .shadow(color: Color.gray.opacity(0.5), radius: 1, x: -1, y: -1)
                            }
                            .alert(isPresented: $purchaseAlertStatus, content: { purchaseAlert })
                        }.padding(.vertical, 30)
                    }
                }
            }
            .background(Color.white.edgesIgnoringSafeArea(.all))
            .navigationBarTitle("장바구니", displayMode: .inline)
            .navigationBarItems(leading:
                /* 나가기 버튼 */
                Button(action: {
                    withAnimation {
                        view = "마트"
                        tabViewHelper.isOn = true
                    }
                }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 15, height: 15)
                }
                , trailing:
                /* 장바구니 수정 버튼 */
                Button(action: {
                    withAnimation {
                        self.cartEdit.toggle()
                    }
                }) {
                    Text(cartEdit ? "완료" : "수정")
                        .fontWeight(.semibold)
                        .foregroundColor(cartEdit ? Color.blue : Color.red)
                }
            )
        }
    }
}

/* 카트에 저장된 식재료 셀 */
struct Cart_FoodCell: View {
    
    @Binding var cartEdit: Bool
    
    @Binding var cartlist: [CartFoodType]
    
    let cartFoodInfo: CartFoodType
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                /* 셀 삭제 버튼 */
                if cartEdit {
                    Button(action: {
                        for index in 0 ..< cartlist.count {
                            if cartlist[index].foodName == cartFoodInfo.foodName {
                                cartlist.remove(at: index)
                            }
                        }
                        withAnimation {
                            CartHelper().editCartDB((Auth.auth().currentUser?.email)!, cartFoodInfo.foodName)
                        }
                    }) {
                        Image(systemName: "minus.rectangle")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.red)
                    }
                }
                
                Image(cartFoodInfo.foodName)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .shadow(color: .gray, radius: 2, x: 2, y: 2)
                    .shadow(color: Color.gray.opacity(0.5), radius: 1, x: -1, y: -1)
                    .cornerRadius(5)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(cartFoodInfo.foodName)")
                    Text("\(cartFoodInfo.foodCount) 개")
                }
                
                Spacer()
                
                Text("\(cartFoodInfo.foodPrice) 원")
            }
            .frame(height: 50)
            .padding(.horizontal, 15)
            
            Divider().background(Color.gray.opacity(0.8))
        }
        
    }
}

struct Cart_Previews: PreviewProvider {
    static var previews: some View {
        Cart(view: .constant("카트"), cartlist: .constant([]))
    }
}
