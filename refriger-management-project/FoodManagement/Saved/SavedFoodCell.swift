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
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.white)
                    .shadow(color: .gray, radius: 1, x: 1, y: 1)
                    .shadow(color: .green, radius: 4, x: 2, y: 2)
                
                VStack {
                    Image(uiImage: UIImage(data: food.foodImage!)!)
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 80, height: 80)
                        .shadow(color: .green, radius: 4, x: 2, y: 2)
                        .offset(y: -30)
                    
                    Spacer()
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(food.foodName!)
                                .fontWeight(.bold)
                            Text(food.foodType!)
                                .fontWeight(.bold)
                            Text("\(food.expiration!, formatter: dateformatter) 까지")
                                .multilineTextAlignment(.leading)
                        }.padding()
                        
                        
                        Spacer()
                    }
                }
            }
        }
        .frame(width: 170, height: 80)
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
