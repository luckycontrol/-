//
//  SavedFoodList.swift
//  refriger-management-project
//
//  Created by 조종운 on 2020/09/19.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI

struct SavedFoodList: View {
    
    @FetchRequest(
        entity: FoodInInnerDB.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \FoodInInnerDB.expiration, ascending: false)
        ]
    ) var savedfood: FetchedResults<FoodInInnerDB>
    
    @ObservedObject var savedFoodHelper: SavedFoodHelper
    
    let foodType: String
    
    var body: some View {
        VStack{
            VStack(alignment: .leading) {
                /* 카테고리 이름 */
                Text("\(foodType)")
                    .foregroundColor(Color.black.opacity(0.6))
                    .fontWeight(.bold)
                
                /* 저장된 목록 출력 */
                ScrollView(.horizontal, showsIndicators: false) {
                    VStack {
                        HStack {
                            ForEach(savedfood) { food in
                                if food.foodType == foodType {
                                    SavedFoodCell(savedFoodHelper: savedFoodHelper, food: food)
                                }
                            }
                        }
                    }
                }
                Divider().background(Color.gray.opacity(0.7))
            }
            .padding()
        }
    }
}

struct SavedFoodList_Previews: PreviewProvider {
    static var previews: some View {
        SavedFoodList(savedFoodHelper: SavedFoodHelper(), foodType: "과일")
    }
}
