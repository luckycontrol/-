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
    
    var deleteAlert: Alert {
        Alert(
            title: Text("식료품 삭제"),
            message: Text("선택하신 식료퓸을 삭제하시겠습니까?"),
            primaryButton: .default(Text("삭제"), action: {
                for f in savedfood {
                    if f.id == food.id {
                        managedObjectContext.delete(f)
                        break
                    }
                }
                
                do {
                   try managedObjectContext.save()
                } catch { }
            }),
            secondaryButton: .cancel(Text("취소"))
        )
    }
    
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
        .onTapGesture { }
        .onLongPressGesture(minimumDuration: 0.5) {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            deleteAlertState = true
        }
        .alert(isPresented: $deleteAlertState, content: {
            deleteAlert
        })
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
