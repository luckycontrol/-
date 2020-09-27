//
//  SavedFoodCell.swift
//  refriger-management-project
//
//  Created by 조종운 on 2020/09/18.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI

struct SavedFoodCell: View {
    
    @ObservedObject var savedFoodHelper: SavedFoodHelper
    
    let food: FoodInInnerDB
    
    let dateformatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var body: some View {
        VStack {
            HStack {
                Image(uiImage: UIImage(data: food.foodImage!)!)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .offset(y: -30)
                    .shadow(color: .green, radius: 1, x: 1, y: 1)
                    .padding()
            }
            
            VStack(alignment: .leading) {
                Text("\(food.foodName!)")
                Text("\(food.foodType!)")
                Text("\(food.expiration!, formatter: dateformatter)")
            }
            .foregroundColor(.black)
            .padding()
        }
        .background(RoundedRectangle(cornerRadius: 15))
        .foregroundColor(.white)
        .shadow(color: .gray, radius: 1, x: 1, y: 1)
        .shadow(color: .green, radius: 2, x: 1, y: 1)
        .padding(20)
        .onTapGesture {
            /* 클릭하면 선택된 식료품이 팝업된다. */
            savedFoodHelper.savedFood = ReadyForAppend(
                id: food.id!,
                foodName: food.foodName!,
                foodType: food.foodType!,
                foodImage: UIImage(data: food.foodImage!)!,
                expiration: food.expiration!
            )
            
            withAnimation {
                savedFoodHelper.editFood = true
            }
        }
    }
}

extension SavedFoodCell {
    
    /* 유통기한에따라 색 변환 */
    func expirationColor() {
        
    }
}

struct SavedFoodCell_Previews: PreviewProvider {
    static var previews: some View {
        SavedFoodCell(savedFoodHelper: SavedFoodHelper(), food: FoodInInnerDB())
    }
}
