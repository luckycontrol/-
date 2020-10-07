//
//  DragFoodImage.swift
//  refriger-management-project
//
//  Created by 조종운 on 2020/09/15.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI

struct DragFoodImage: View {
    
    var food: SelfAppendCategory
    
    @Binding var selectedAppendWay: String
    
    @ObservedObject var savingFoodHelper: SavingFoodHelper
    
    @State var location = CGSize.zero
    
    var body: some View {
        VStack {
            Image(food.foodName)
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .shadow(color: .gray, radius: 1, x: 1, y: 1)
                .offset(self.location)
                .onTapGesture {}
                .gesture(DragGesture()
                    .onChanged { value in
                        self.location = value.translation

                        print("x: \(self.location.width), y: \(self.location.height)")
                    }
                    .onEnded { _ in
                        if self.location.height < -250 && self.location.height > -425 {
                            UINotificationFeedbackGenerator().notificationOccurred(.success)
                            self.savingFoodHelper.appendFood = self.food
                            withAnimation {
                                self.selectedAppendWay = "드래그추가"
                            }
                        }
                        self.location = .zero
                    }
                )
            
            Text("\(food.foodName)")
        }
    }
}
