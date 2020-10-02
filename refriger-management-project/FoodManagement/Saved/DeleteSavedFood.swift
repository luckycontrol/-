//
//  DeleteSavedFood.swift
//  refriger-management-project
//
//  Created by 조종운 on 2020/09/27.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI

struct DeleteSavedFood: View {
    
    @ObservedObject var savedFoodHelper: SavedFoodHelper
    
    @State var deleteFood = false
    
    @State var expiration = Date()
    
    let dateformatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var body: some View {
        VStack {
            VStack {
                /* 식료품이름, 삭제버튼 */
                HStack {
                    Text("\(savedFoodHelper.savedFood!.foodName)")
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    Button(action: { self.deleteFood = true }) {
                        Text("삭제")
                            .foregroundColor(.red)
                    }
                }
                
                /* 식료품 이미지, 타입 유통기한 */
                HStack {
                    Image(uiImage: savedFoodHelper.savedFood!.foodImage)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .shadow(color: .gray, radius: 1, x: 1, y: 1)
                    
                    VStack(alignment: .leading) {
                        Text("\(savedFoodHelper.savedFood!.foodType)")
                        DatePicker("", selection: $expiration, in: Date()..., displayedComponents: .date)
                            .labelsHidden()
                        
                    }
                    .padding(.leading, 40)
                    
                    Spacer()
                }
                
                Spacer()
                
                /* 변경버튼 */
                Button(action: {
                    savedFoodHelper.savedFood?.expiration = expiration
                    self.savedFoodHelper.editFood = false
                }) {
                    HStack {
                        Text("변경")
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width - 90, height: 40)
                            .shadow(color: .gray, radius: 1, x: 1, y: 1)
                    }
                    .background(RoundedRectangle(cornerRadius: 15))
                    .foregroundColor(Color("CategoryColor"))
                }
            }
            .foregroundColor(.black)
            .padding()
        }
        .background(RoundedRectangle(cornerRadius: 15))
        .frame(width: UIScreen.main.bounds.width - 90, height: UIScreen.main.bounds.height * 1/3)
        .foregroundColor(.white)
        .shadow(color: .gray, radius: 1, x: 1, y: 1)
    }
}

struct DeleteSavedFood_Previews: PreviewProvider {
    static var previews: some View {
        DeleteSavedFood(savedFoodHelper: SavedFoodHelper())
    }
}
