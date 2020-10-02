//
//  FoodDetail.swift
//  refriger-management-project
//
//  Created by 조종운 on 2020/08/22.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct FoodDetail: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var userHelper: UserHelper
    
    @ObservedObject var foodDetailInfo: FoodDetailInfo
    
    @State var addAlertStatus = false
    
    var addAlert: Alert {
        Alert(
            title: Text("장바구니 추가"),
            message: Text("\(foodDetailInfo.foodName) (이)가 \n \(foodDetailInfo.foodCount) 개 추가되었습니다.")
        )
    }
    
    var purchaseButton: some View {
        Button(action: {
            /* 로그인 돼있으면.. */
            if self.userHelper.login {
                CartHelper().addCart(
                    (Auth.auth().currentUser?.email!)!,
                    CartFoodType(
                        foodName: self.foodDetailInfo.foodName,
                        foodCategory: self.foodDetailInfo.foodCategory,
                        foodCount: self.foodDetailInfo.foodCount,
                        foodPrice: self.foodDetailInfo.foodPrice
                )) { (isSuccess) in
                    if isSuccess {
                        self.addAlertStatus = true
                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                    }
                }
            /* 로그인 안돼있으면.. */
            } else {
                self.presentationMode.wrappedValue.dismiss()
                withAnimation {
                    self.userHelper.login_locate = true
                }
            }
        }) {
            HStack(spacing: 20) {
                Image(systemName: "cart.fill")
                Text("장바구니")
                    .fontWeight(.semibold)
            }
            .frame(width: 200, height: 70)
            .background(Color("ButtonColor"))
            .cornerRadius(15)
        }
    }
    
    var body: some View {
        VStack {
            /* 장바구니 나가기 버튼 */
            HStack {
                Button(action: {
                    withAnimation {
                        self.foodDetailInfo.foodDetailOffset.width = UIScreen.main.bounds.width
                    }
                }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .foregroundColor(.black)
                }
                Spacer()
            }.padding()
            
            /* 식자재 이름, 이미지 */
            Text(foodDetailInfo.foodName)
                .fontWeight(.bold)
                .font(.system(size: 20))
            
            Image(foodDetailInfo.foodName)
                .resizable()
                .frame(width: 300, height: 300)
                .cornerRadius(15)
                .shadow(color: .gray, radius: 2, x: 2, y: 2)
                .shadow(color: Color.gray.opacity(0.5), radius: 1, x: -1, y: -1)
            
            Spacer()
            
            /* 갯수 증가, 감소 버튼 */
            HStack(spacing: 40) {
                CountButton(action: "minus", foodDetailInfo: foodDetailInfo)
                
                Text("\(foodDetailInfo.foodCount)")
                    .fontWeight(.semibold)
                
                CountButton(action: "plus", foodDetailInfo: foodDetailInfo)
            }
            
            Spacer()
            
            /* 가격 */
            HStack {
                VStack(alignment: .center, spacing: 5) {
                    Text("가격")
                        .foregroundColor(.gray)
                        .fontWeight(.bold)
                    
                    Text("\(foodDetailInfo.foodPrice) 원")
                        .fontWeight(.medium)
                }
                Spacer()
                
                /* 구매 버튼 */
                purchaseButton
                    .alert(isPresented: $addAlertStatus, content: { addAlert })
            }
            .foregroundColor(.black)
            .padding(.horizontal, 15)
            
        }
        .padding(.vertical, 15)
        .background(Color("MartBackground").edgesIgnoringSafeArea(.all))
    }
}

class FoodDetailInfo: ObservableObject {
    @Published var foodName: String = ""
    @Published var foodCategory: String = ""
    @Published var foodType: String = ""
    @Published var foodCount: Int = 0
    @Published var foodPrice: String = ""
    @Published var original_foodPrice: String = ""
    
    @Published var foodDetailOffset: CGSize = CGSize.init(width: UIScreen.main.bounds.width, height: 0)
}

/* 갯수 추가 | 제거 버튼 */
struct CountButton: View {
    
    let action: String
    
    @ObservedObject var foodDetailInfo: FoodDetailInfo
    
    var body: some View {
        Button(action: {
            /* 액션이 Plus */
            if self.action == "plus" {
                self.foodDetailInfo.foodCount += 1
            }
            /* 액션이 Minus */
            else if self.action == "minus" {
                if self.foodDetailInfo.foodCount > 1 {
                    self.foodDetailInfo.foodCount -= 1
                }
            }
             
            /* 콤마를 제거*/
            self.foodDetailInfo.foodPrice = CartHelper().sub_comma(self.foodDetailInfo.original_foodPrice)
            /* 갯수에 맞게 가격을 변경*/
            self.foodDetailInfo.foodPrice = String(Int(self.foodDetailInfo.foodPrice)! * self.foodDetailInfo.foodCount)
            /* 콤마 삽입 */
            self.foodDetailInfo.foodPrice = CartHelper().add_comma(self.foodDetailInfo.foodPrice)
            
        }) {
            Image(systemName: action)
                .frame(width: 30, height: 30)
                .foregroundColor(Color("ButtonColor"))
                .background(Color("CountButton"))
                .clipShape(Circle())
                .shadow(color: .gray, radius: 2, x: 2, y: 2)
                .shadow(color: Color.gray.opacity(1), radius: 1, x: -1, y: -1)
        }
    }
}

struct FoodDetail_Previews: PreviewProvider {
    static var previews: some View {
        FoodDetail(userHelper: UserHelper(), foodDetailInfo: FoodDetailInfo())
    }
}
