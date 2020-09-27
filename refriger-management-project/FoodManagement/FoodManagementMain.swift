//
//  FoodManagementMain.swift
//  refriger-management-project
//
//  Created by 조종운 on 2020/09/19.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI

struct FoodManagementMain: View {
    
    @FetchRequest(
        entity: FoodInInnerDB.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \FoodInInnerDB.expiration, ascending: false)
        ]
    ) var savedfood: FetchedResults<FoodInInnerDB>
    
    @EnvironmentObject var tabViewHelper: TabViewHelper
    
    @ObservedObject var savedFoodHelper = SavedFoodHelper()
    
    @State private var editSavedFood = false
    
    @State private var isChangeSortingWay = false
    
    @State private var changeSortingWay = "일반"
    
    @State private var selectedMenu = ""
    
    private let foodTypeList = ["과일", "채소", "정육", "해산물", "유제품", "기타"]
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            /* 저장된 식료품이 있는 경우 */
            if savedfood.count > 0 {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        /* 타이틀 / 수정버튼 */
                        HStack {
                            Text("식료품 관리")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation {
                                    self.editSavedFood.toggle()
                                }
                            }) {
                                if self.editSavedFood {
                                    Text("수정 완료")
                                } else {
                                    Text("수정")
                                }
                            }
                        }
                        
                        /* 직접추가 / QR코드 추가 */
                        if editSavedFood {
                            FoodManagementMenu(selectedMenu: $selectedMenu)
                        }
                        
                        SavedFoodList(savedFoodHelper: savedFoodHelper, foodType: "과일")
                        SavedFoodList(savedFoodHelper: savedFoodHelper, foodType: "정육")
                        SavedFoodList(savedFoodHelper: savedFoodHelper, foodType: "채소")
                        SavedFoodList(savedFoodHelper: savedFoodHelper, foodType: "유제품")
                        SavedFoodList(savedFoodHelper: savedFoodHelper, foodType: "해산물")
                        SavedFoodList(savedFoodHelper: savedFoodHelper, foodType: "기타")
                    }
                }
                .padding()
                .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                .edgesIgnoringSafeArea(.all)
                .overlay(savedFoodHelper.editFood ? Color.black.opacity(0.3).edgesIgnoringSafeArea(.all) : nil)
                .onTapGesture {
                    withAnimation {
                        savedFoodHelper.editFood = false
                    }
                }
                
                if savedFoodHelper.editFood {
                    DeleteSavedFood(savedFoodHelper: savedFoodHelper)
                }
                
            } else {
            /* 저장된 식료품이 없는 경우 */
                
                VStack {
                    /* 타이틀 / 수정버튼 */
                    HStack {
                        Text("식료품 관리")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                self.editSavedFood.toggle()
                            }
                        }) {
                            if self.editSavedFood {
                                Text("수정 완료")
                            } else {
                                Text("수정")
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    /* 직접추가 / QR코드 추가 */
                    if editSavedFood {
                        FoodManagementMenu(selectedMenu: $selectedMenu)
                    }
                    
                    Spacer()
                    
                    Text("저장된 식료품이 없어요.")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                }
            }

            /* 직접추가 뷰 */
            SelfAppendView(selectedMenu: $selectedMenu)
            
            /* QR코드추가 뷰 */
            
        }
    }
}

/* 메뉴 - 직접추가 | QR코드추가 */
struct FoodManagementMenu: View {
    
    @EnvironmentObject var tabViewHelper: TabViewHelper
    
    @Binding var selectedMenu: String
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                /* 직접추가 버튼 */
                Button(action: {
                    withAnimation {
                        self.selectedMenu = "직접추가"
                        self.tabViewHelper.isOn = false
                    }
                }) {
                    VStack {
                        VStack {
                            Image("직접추가")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 70, height: 70)
                            
                            Text("직접추가")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                        .padding()
                    }
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white))
                    .shadow(color: .gray, radius: 1, x: 1, y: 1)
                
                }
                
                /* QR코드추가 버튼 */
                Button(action: {
                    withAnimation {
                        self.selectedMenu = "qr코드추가"
                        self.tabViewHelper.isOn = false
                    }
                }) {
                    VStack {
                        VStack {
                            Image("qr코드추가")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 70, height: 70)
                            
                            Text("qr코드추가")
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                        }.padding()
                    }
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white))
                    .shadow(color: .gray, radius: 1, x: 1, y: 1)
                }
            }
            .padding()
        }
    }
}

struct FoodManagementMain_Previews: PreviewProvider {
    static var previews: some View {
        FoodManagementMain()
    }
}
