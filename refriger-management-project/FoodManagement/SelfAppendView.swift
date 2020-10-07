//
//  SelfAppendView.swift
//  refriger-management-project
//
//  Created by 조종운 on 2020/09/14.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI

struct SelfAppendView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @EnvironmentObject var tabViewHelper: TabViewHelper
    
    let foodCategories = ["과일", "채소", "정육", "해산물", "유제품"]
    
    @ObservedObject var dragAppendHelper = DragAppendHelper()
    
    @ObservedObject var savingFoodHelper = SavingFoodHelper()
    
    @State var selectedCategory = "과일"
    
    @Binding var selectedMenu: String
    
    @State var selectedAppendWay = ""
    
    @State var deleteFood: ReadyForAppend?
    
    var body: some View {
        
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack {
                    VStack(alignment: .leading) {
                        /* 나가기 버튼 */
                        Button(action: {
                            withAnimation {
                                self.selectedMenu = ""
                                self.tabViewHelper.isOn = true
                                self.reset()
                            }
                        }) {
                            Image(systemName: "xmark")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 15, height: 15)
                        
                        }.padding(.bottom, 15)
                        
                        /* 타이틀 */
                        Text("식자재 직접 추가")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            
                        /* 저장될 식자재 리스트 */
                        ZStack {
                            Color.gray.opacity(0.2)
                            
                            DisplaySelectedList(savingFoodHelper: self.savingFoodHelper)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .frame(height: UIScreen.main.bounds.height * 1/3)
                        .shadow(color: .gray, radius: 1, x: 1, y: 1)
                        
                        /* 직접추가 버튼 */
                        HStack {
                            Button(action: {
                                withAnimation {
                                    self.selectedAppendWay = "직접추가"
                                }
                            }) {
                                HStack {
                                    Text("직접추가")
                                        .foregroundColor(.white)
                                        .fontWeight(.semibold)
                                        .padding()
                                }
                                .frame(width: 100, height: 30)
                                .background(RoundedRectangle(cornerRadius: 10))
                                .foregroundColor(Color("CategoryColor"))
                                .shadow(color: .gray, radius: 1, x: 1, y: 1)
                            }
                        }
                            
                        /* 카테고리 선택지 */
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(foodCategories, id: \.self) { category in
                                    CategoryView(selectedCategory: self.$selectedCategory, dragAppendHelper: self.dragAppendHelper, foodCategory: category)
                                }
                            }.padding(.vertical)
                        }
                            
                        /* 카테고리 타이틀 */
                        Text("식자재 카테고리")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    
                    /* 식자재 선택지 */
                    ZStack {
                        DragCategoryView(dragAppendHelper: dragAppendHelper, savingFoodHelper: savingFoodHelper, selectedAppendWay: $selectedAppendWay)
                    }
                    .frame(height: UIScreen.main.bounds.height * 1/4)
                    
                    /* 추가 버튼 */
                    Button(action: {
                        for row in 0 ..< self.savingFoodHelper.readyForAppend.count {
                            for index in 0 ..< self.savingFoodHelper.readyForAppend[row].count {
                                let food = FoodInInnerDB(context: self.managedObjectContext)
                                
                                food.id = self.savingFoodHelper.readyForAppend[row][index].id
                                food.foodName = self.savingFoodHelper.readyForAppend[row][index].foodName
                                food.foodType = self.savingFoodHelper.readyForAppend[row][index].foodType
                                food.foodImage = self.savingFoodHelper.readyForAppend[row][index].foodImage.pngData()
                                food.expiration = self.savingFoodHelper.readyForAppend[row][index].expiration
                                
                            }
                        }
                        
                        do {
                            try managedObjectContext.save()
                        } catch {}
                    }) {
                        ZStack {
                            Capsule()
                                .foregroundColor(Color("CategoryColor"))
                                .frame(width: 250, height: 50)
                            
                            Text("추가하기")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                            
                        }
                        .shadow(color: .gray, radius: 1, x: 1, y: 1)
                    }
                    
                }
                .padding(.horizontal)
                .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
            }
            .edgesIgnoringSafeArea(.all)
            .overlay(savingFoodHelper.isRemove ? Color.black.opacity(0.3).edgesIgnoringSafeArea(.all) : nil)
            
            /* 삭제 뷰 */
            if savingFoodHelper.isRemove {
                RemoveAppendFood(savingFoodHelper: savingFoodHelper)
            }
            
            DirectAppendView(savingFoodHelper: savingFoodHelper, selectedAppendWay: $selectedAppendWay)
            
            DragAppendView(savingFoodHelper: savingFoodHelper, selectedAppendWay: $selectedAppendWay)
        }
        .offset(x: selectedMenu == "직접추가" ? 0 : UIScreen.main.bounds.width)
    }
}

extension SelfAppendView {
    func reset() {
        self.selectedCategory = "과일"
        dragAppendHelper.getCategoryList("과일")
        
        savingFoodHelper.readyForAppend.removeAll()
    }
}


/* 카테고리 선택지 뷰 */
struct CategoryView: View {
    
    @Binding var selectedCategory: String
    
    @ObservedObject var dragAppendHelper: DragAppendHelper
    
    let foodCategory: String
    
    var body: some View {
        HStack {
            Text("\(foodCategory)")
                .fontWeight(foodCategory == selectedCategory ? .bold : .none)
        }
        .frame(width: 100, height: 30)
        .foregroundColor(foodCategory == selectedCategory ? .white : Color.black.opacity(0.8))
        .background(foodCategory == selectedCategory ? Color("CategoryColor") : Color.gray.opacity(0.2))
        .clipShape(Capsule())
        .shadow(color: .gray, radius: 1, x: 1, y: 1)
        .onTapGesture {
            self.selectedCategory = self.foodCategory
            self.dragAppendHelper.getCategoryList(self.foodCategory)
        }
    }
}

/* 드래그하는 식료품 뷰 */
struct DragCategoryView: View {
    
    @ObservedObject var dragAppendHelper: DragAppendHelper
    
    @ObservedObject var savingFoodHelper: SavingFoodHelper
    
    @Binding var selectedAppendWay: String
    
    var body: some View {
        VStack {
            ForEach(0 ..< self.dragAppendHelper.selectedList.count, id: \.self) { row in
                HStack {
                    ForEach(self.dragAppendHelper.selectedList[row], id: \.self) { food in
                        DragFoodImage(food: food, selectedAppendWay: self.$selectedAppendWay, savingFoodHelper: self.savingFoodHelper)
                    }
                }
            }
        }
    }
}


struct SelfAppendView_Previews: PreviewProvider {
    static var previews: some View {
        SelfAppendView(selectedMenu: .constant(""))
    }
}
