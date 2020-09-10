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
    
    @ObservedObject var categorySelector: CategorySelector
    
    @ObservedObject var userHelper: UserHelper
    
    @ObservedObject var cartHelper: CartHelper
    
    @ObservedObject var foodDetailInfo = FoodDetailInfo()

    var body: some View {
        ZStack {
            VStack {
                /* 상단바 - 카테고리버튼 / 장바구니버튼 */
                HStack {
                    // -- 카테고리 버튼 --
                    Button(action: {
                        withAnimation {
                            self.categorySelector.menu.toggle()
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
                                        self.categorySelector.cart = true
                                    }
                                }
                            }
                        } else {
                            withAnimation {
                                self.userHelper.login_locate = true
                            }
                        }
                    }) {
                        Image(systemName: "cart")
                        .frame(width: 25, height: 25)
                    }
                    
                }
                .foregroundColor(.black)
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
                
                /* 음식 리스트 */
                ScrollView(.vertical, showsIndicators: false) {
                
                    /* 카테고리 이미지  */
                    Image(categorySelector.foodCategory)
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
                                Button(action: {
                                    self.foodDetailInfo.foodName = martfoodData[index].name
                                    self.foodDetailInfo.foodType = martfoodData[index].foodType
                                    self.foodDetailInfo.foodCount = 1
                                    self.foodDetailInfo.foodPrice = martfoodData[index].price
                                    self.foodDetailInfo.original_foodPrice = martfoodData[index].price
                
                                    withAnimation {
                                        self.foodDetailInfo.foodDetailOffset.width = 0
                                    }
                                }) {
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
                                }
                            }
                        }
                    }
                }
            }.background(Color.white.edgesIgnoringSafeArea(.all))
            
            
            /* 음식 세부사항 뷰 */
            FoodDetail(userHelper: userHelper, foodDetailInfo: foodDetailInfo)
                .offset(x: foodDetailInfo.foodDetailOffset.width)
                .gesture(DragGesture()
                    .onChanged({ gesture in
                        if gesture.translation.width > 0 {
                            self.foodDetailInfo.foodDetailOffset.width = gesture.translation.width
                        }
                    })
                    .onEnded({ _ in
                        if self.foodDetailInfo.foodDetailOffset.width > 170 {
                            withAnimation {
                                self.foodDetailInfo.foodDetailOffset.width = UIScreen.main.bounds.width
                            }
                        } else {
                            withAnimation {
                                self.foodDetailInfo.foodDetailOffset.width = 0
                            }
                        }
                    })
                )

        }
    }
}

struct FoodList_Previews: PreviewProvider {
    static var previews: some View {
        FoodList(categorySelector: CategorySelector(), userHelper: UserHelper(), cartHelper: CartHelper(), foodDetailInfo: FoodDetailInfo())
    }
}
