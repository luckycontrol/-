//
//  RemoveAppendFood.swift
//  refriger-management-project
//
//  Created by 조종운 on 2020/09/22.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI

struct RemoveAppendFood: View {
    
    @ObservedObject var savingFoodHelper: SavingFoodHelper
    
    var body: some View {
        VStack {
            VStack {
                /* 나가기 버튼 */
                HStack {
                    Button(action: {
                        withAnimation {
                            self.savingFoodHelper.isRemove = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                
                /* 타이틀 */
                Text("선택하신 식료품을 지울까요?")
                    .font(.system(size: 22))
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                
                /* 이미지, 식료품이름, 식료품타입 */
                HStack {
                    Image(uiImage: savingFoodHelper.removeFood!.foodImage)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                    
                    VStack {
                        Text("\(savingFoodHelper.removeFood!.foodName)")
                            .foregroundColor(.black)
                        Text("\(savingFoodHelper.removeFood!.foodType)")
                            .foregroundColor(.black)
                    }
                    .padding(.leading, 30)
                }
                
                Spacer()
                
                /* 지우기버튼 */
                Button(action: {
                    self.savingFoodHelper.deleteInList(food: self.savingFoodHelper.removeFood!) { isSucess in
                        if isSucess {
                            withAnimation {
                                self.savingFoodHelper.isRemove = false
                            }
                        }
                    }
                }) {
                    HStack {
                        Text("삭제하기")
                            .foregroundColor(.white)
                    }
                    .frame(width: 200, height: 50)
                    .background(Capsule())
                    .foregroundColor(Color("CategoryColor"))
                    .shadow(color: .gray, radius: 1, x: 1, y: 1)
                }
            }
            .padding()
        }
        .frame(width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.height * 1/3)
        .background(RoundedRectangle(cornerRadius: 15))
        .foregroundColor(.white)
        .shadow(color: .gray, radius: 1, x: 1, y: 1)
    }
}

struct RemoveAppendFood_Previews: PreviewProvider {
    static var previews: some View {
        RemoveAppendFood(savingFoodHelper: SavingFoodHelper())
    }
}
