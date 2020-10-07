//
//  FoodList.swift
//  refriger-management-project
//
//  Created by 조종운 on 2020/08/22.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct FoodList: View {
    
    @EnvironmentObject var tabViewHelper: TabViewHelper
    
    @ObservedObject var categorySelector: CategorySelector
    
//    @ObservedObject var userHelper: UserHelper
    @EnvironmentObject var userHelper: UserHelper
    
    @ObservedObject var cartHelper: CartHelper
    
    @ObservedObject var foodDetailInfo = FoodDetailInfo()
    
    @Binding var view: String
    
    @State private var foodName = ""
    @State private var foodCategory = ""
    @State private var foodType = ""
    @State private var foodCount = 1
    @State private var foodPrice = ""
    @State private var original_foodPrice = ""

    var body: some View {
        ZStack {
            VStack {
                /* 음식 리스트 */
                ScrollView(.vertical, showsIndicators: false) {
                    /* 상단바 - 카테고리버튼 / 장바구니버튼 */
                    HStack {
                        // -- 카테고리 버튼 --
                        Button(action: {
                            withAnimation {
                                if view != "메뉴" {
                                    view = "메뉴"
                                    tabViewHelper.isOn = false
                                } else {
                                    view = "마트"
                                    tabViewHelper.isOn = true
                                }
                            }
                        }) {
                            Image(systemName: "list.bullet")
                                .frame(width: 30, height: 30)
                        }
                        Spacer()
                        // -- 장바구니 버튼 --
                        Button(action: {
                            if self.userHelper.login {
                                self.cartHelper.loadCart((Auth.auth().currentUser?.email!)!) { (isSuccess) in
                                    if isSuccess {
                                        withAnimation {
                                            view = "카트"
                                            tabViewHelper.isOn = false
//                                            self.categorySelector.cart = true
                                        }
                                    }
                                }
                            } else {
                                withAnimation {
                                    view = "로그인"
                                    tabViewHelper.isOn = false
                                }
                            }
                        }) {
                            Image(systemName: "cart")
                            .frame(width: 25, height: 25)
                        }
                        
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 15)
                    .background(Color.clear)
                
                    /* 카테고리 이미지  */
                    Image("카테고리-" + categorySelector.foodCategory)
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width - 50, height: 150)
                        .cornerRadius(15)
                        .overlay(
                            VStack {
                                Spacer()
                                HStack {
                                    Text("\(categorySelector.foodCategory)")
                                        .font(.title).foregroundColor(.white)
                                        .fontWeight(.semibold)
                
                                    Spacer()
                                }.padding()
                            }
                        )
                        .shadow(color: .gray, radius: 1, x: 1, y: 1)
                        .shadow(color: .gray, radius: 1, x: -1, y: -1)
                        .padding(.bottom, 15)
                
                    /* FoodList 타이틀 글귀 - Fresh New Items */
                    HStack {
                        Text("Fresh New Items")
                            .font(.largeTitle)
                            .fontWeight(.light)
                
                        Spacer()
                    }.padding()
                
                    /* 식자재 리스트 출력 */
                    ForEach(0 ..< martfoodData.count, id: \.self) { index in
                        VStack {
                            if martfoodData[index].foodType == self.categorySelector.foodType {
                                VStack {
                                    Image(martfoodData[index].name)
                                        .renderingMode(.original)
                                        .resizable()
                                        .frame(height: 300)
                                        .cornerRadius(15)
                                        .shadow(color: .gray, radius: 1, x: 2, y: 2)
                                        .shadow(color: Color.gray.opacity(0.5), radius: 1, x: -1, y: -1)
                                        .padding(.horizontal, 30)
            
                                    VStack(spacing: 8) {
                                        Text(martfoodData[index].name)
                                            .fontWeight(.light)
                                        Text("\(martfoodData[index].price) 원")
                                            .fontWeight(.light)
                                    }
                                    .padding(.top, 5)
                                    .foregroundColor(.black)
                                }
                                .onTapGesture {
                                    foodName = martfoodData[index].name
                                    foodCategory = martfoodData[index].category
                                    foodType = martfoodData[index].foodType
                                    foodCount = 1
                                    foodPrice = martfoodData[index].price
                                    original_foodPrice = martfoodData[index].price
                                    
                                    withAnimation {
                                        view = "디테일"
                                        tabViewHelper.isOn = false
                                    }
                                    
                                }
                                
                            }
                        }
                    }
                }
            }.background(Color.white.edgesIgnoringSafeArea(.all))
            
            
            /* 음식 세부사항 뷰 */
            FoodDetail(userHelper: userHelper, foodName: $foodName, foodCategory: $foodCategory, foodType: $foodType, foodCount: $foodCount, foodPrice: $foodPrice, original_foodPrice: $original_foodPrice, view: $view)
                .offset(x: view == "디테일" ? .zero : UIScreen.main.bounds.width)
        }
    }
}

struct FoodList_Previews: PreviewProvider {
    static var previews: some View {
        FoodList(categorySelector: CategorySelector(), cartHelper: CartHelper(), foodDetailInfo: FoodDetailInfo(), view: .constant("마트"))
    }
}
