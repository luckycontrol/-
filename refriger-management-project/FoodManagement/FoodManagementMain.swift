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
                    
                    /* 정렬기준 */
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                self.isChangeSortingWay = true
                                self.tabViewHelper.isOn = false
                            }
                        }) {
                            Text("정렬기준: \(changeSortingWay)")
                        }
                    }
                    
                    /* 직접추가 / QR코드 추가 */
                    if editSavedFood {
                        FoodManagementMenu(selectedMenu: $selectedMenu)
                    }
                    
                    if savedfood.count > 0 {
                        /* 저장된 식료품 리스트 */
                        ForEach(foodTypeList, id: \.self) { foodType in
                            VStack {
                                SavedFoodList(savedFoodHelper: self.savedFoodHelper, foodType: foodType)
                                Divider()
                                    .background(Color.gray.opacity(0.6))
                            }
                        }
                    } else {
                        Text("저장된 식료품이 없습니다.")
                    }
                    
                    Spacer()
                }
            }
            .padding()
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            .edgesIgnoringSafeArea(.all)
            .overlay(isChangeSortingWay ? Color.black.opacity(0.3).edgesIgnoringSafeArea(.all) : nil)
            
            /* 정렬기준 선택 Picker */
            if isChangeSortingWay {
                SelectSortingWayView(isChangeSortingWay: $isChangeSortingWay, changeSortingWay: $changeSortingWay)
            }
            
            /* 직접추가 뷰 */
            SelfAppendView(selectedMenu: $selectedMenu)
            
            /* QR코드추가 뷰 */
            
        }
    }
}

/* 정렬기준 선택 Picker */
struct SelectSortingWayView: View {
    
    @EnvironmentObject var tabViewHelper: TabViewHelper
    
    @Binding var isChangeSortingWay: Bool
    
    @Binding var changeSortingWay: String
    
    private let sortingWayList = ["일반", "유통기한이 짧은 순", "유통기한이 긴 순"]
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                /* Picker */
                VStack {
                    Text("정렬 기준")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.top)
                    
                    Picker("", selection: self.$changeSortingWay) {
                        ForEach(self.sortingWayList, id: \.self) { category in
                            Text(category)
                                .foregroundColor(.black)
                        }
                    }
                    .labelsHidden()
                }
                .background(RoundedRectangle(cornerRadius: 10))
                .foregroundColor(.white)
                .shadow(radius: 1)
                
                /* 종료버튼 */
                VStack {
                    Button(action: {
                        withAnimation {
                            self.isChangeSortingWay = false
                            self.tabViewHelper.isOn = true
                        }
                    }) {
                        Text("완료")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(width: UIScreen.main.bounds.width - 90, height: 50)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.white))
                            .shadow(radius: 1)
                        
                    }
                }
            }
            .position(x: geometry.size.width / 2, y: geometry.size.height - 200)
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
