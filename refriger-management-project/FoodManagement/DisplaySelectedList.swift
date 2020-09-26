//
//  DisplaySelectedList.swift
//  refriger-management-project
//
//  Created by 조종운 on 2020/09/20.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI

struct DisplaySelectedList: View {
    
    @ObservedObject var savingFoodHelper: SavingFoodHelper
    
    var body: some View {
        Group {
            if savingFoodHelper.readyForAppend.count > 0 {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(0 ..< savingFoodHelper.readyForAppend.count, id: \.self) { row in
                            VStack {
                                ForEach(self.savingFoodHelper.readyForAppend[row]) { food in
                                    SelectedFoodImage(savingFoodHelper: self.savingFoodHelper, food: food)
                                }
                                Spacer()
                            }
                        }
                    }
                }
            } else {
                Text("아래 식료품을 이쪽으로 드래그해주세요!")
            }
        }
    }
}

/* 선택된 식자재 이미지 - 삭제를 위해 따로 만듦.. */
struct SelectedFoodImage: View {
    
    @ObservedObject var savingFoodHelper: SavingFoodHelper
    
    let food: ReadyForAppend
    
    var body: some View {
        VStack {
            ZStack {
                Image(uiImage: food.foodImage)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .shadow(color: .gray, radius: 1, x: 1, y: 1)
            }
            .onTapGesture {
                self.savingFoodHelper.removeFood = self.food
                withAnimation {
                    self.savingFoodHelper.isRemove = true
                }
            }
            
            
            Text("\(food.foodName)")
        }
    }
}

struct DisplaySelectedList_Previews: PreviewProvider {
    static var previews: some View {
        DisplaySelectedList(savingFoodHelper: SavingFoodHelper())
    }
}
