//
//  SavedFoodCell.swift
//  refriger-management-project
//
//  Created by 조종운 on 2020/09/18.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI

struct SavedFoodCell: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
        entity: FoodInInnerDB.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \FoodInInnerDB.expiration, ascending: true),
        ]
    ) var savedfood: FetchedResults<FoodInInnerDB>
    
    @ObservedObject var savedFoodHelper: SavedFoodHelper
    
    let food: FoodInInnerDB
    
    let dateformatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    @State var deleteAlertState = false
    
    @State var foodColor: String = ""
    
    var deleteAlert: Alert {
        Alert(
            title: Text("식료품 삭제"),
            message: Text("선택하신 식료퓸을 삭제하시겠습니까?"),
            primaryButton: .default(Text("삭제"), action: {
                managedObjectContext.delete(food)
            }),
            secondaryButton: .cancel(Text("취소"))
        )
    }
    
    var body: some View {
        VStack {
            if food.foodImage == nil {
                Image(food.foodName!)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .offset(y: -30)
                    .shadow(color: Color(foodColor), radius: 1, x: 1, y: 1)
                    .padding()
            } else {
                Image(uiImage: UIImage(data: food.foodImage!)!)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .offset(y: -30)
                    .shadow(color: Color(foodColor), radius: 1, x: 1, y: 1)
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
        .frame(width: UIScreen.main.bounds.width * 1/3)
        .shadow(color: .gray, radius: 1, x: 1, y: 1)
        .shadow(color: Color(foodColor), radius: 2, x: 1, y: 1)
        .padding(20)
        .onTapGesture { }
        .onLongPressGesture(minimumDuration: 0.5) {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            deleteAlertState = true
        }
        .alert(isPresented: $deleteAlertState, content: {
            deleteAlert
        })
        .onAppear {
            let expiration = food.expiration!
            let startDate = Date()
            
            let interval = expiration.timeIntervalSince(startDate)
            
            let left = Int(interval / 86400)
            
            if left >= 7 {
                foodColor = "fresh"
            }
            else if left >= 3 {
                foodColor = "alert"
            }
            else if left >= 1 {
                foodColor = "becareful"
            }
            else {
                foodColor = "trash"
            }
        }
    }
}

struct SavedFoodCell_Previews: PreviewProvider {
    static var previews: some View {
        SavedFoodCell(savedFoodHelper: SavedFoodHelper(), food: FoodInInnerDB())
    }
}
