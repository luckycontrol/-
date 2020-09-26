//
//  DragAppendView.swift
//  refriger-management-project
//
//  Created by 조종운 on 2020/09/15.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI

struct DragAppendView: View {
    @ObservedObject var savingFoodHelper: SavingFoodHelper
    
    @State var expiration: Date = Date()
    
    @State var appendAlertBool = false
    
    @Binding var selectedAppendWay: String
    
    var appendAlert: Alert {
        Alert(
            title: Text("식료품 추가"),
            message: Text("선택하신 식료품을 추가하시겠습니까?"),
            primaryButton: .default(Text("추가"), action: {
                self.savingFoodHelper.insertToList(food: ReadyForAppend(
                    id: UUID(),
                    foodName: self.savingFoodHelper.appendFood.foodName,
                    foodType: self.savingFoodHelper.appendFood.foodType,
                    foodImage: UIImage(imageLiteralResourceName: self.savingFoodHelper.appendFood.foodName),
                    expiration: self.expiration
                ))
                
                withAnimation {
                    self.selectedAppendWay = ""
                }
            }),
            secondaryButton: .cancel(Text("취소"))
        )
    }
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                /* 나가기 버튼 */
                VStack(alignment: .leading) {
                    Button(action: {
                        withAnimation { self.selectedAppendWay = "" }
                    }) {
                        Image(systemName: "arrow.left")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 15, height: 15)
                    }.padding(.bottom, 30)
                    
                    /* 타이틀 */
                    Text("식자재 추가")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    /* 이미지, 이름, 타입 */
                    HStack {
                        Image(savingFoodHelper.appendFood.foodName)
                            .resizable()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .shadow(color: .gray, radius: 1, x: 1, y: 1)
                        
                        VStack(alignment: .center) {
                            Text("식자재 이름: \(savingFoodHelper.appendFood.foodName)")
                                .fontWeight(.bold)
                            Text("식자재 종류: \(savingFoodHelper.appendFood.foodType)")
                                .fontWeight(.bold)
                        }.padding(.leading, 50)
                        
                        Spacer()
                    }.padding(.vertical, 20)
                    
                    Text("유통기한을 선택하세요")
                        .font(.title)
                        .fontWeight(.bold)
                    
                }.padding(15)
                
                DatePicker("", selection: $expiration, in: Date()..., displayedComponents: .date)
                .labelsHidden()
                
                Spacer()
                
                /* 식료품 추가 버튼 */
                Button(action: { self.appendAlertBool = true }) {
                    ZStack {
                        Capsule()
                            .foregroundColor(Color("CategoryColor"))
                            .frame(width: 300, height: 50)
                            .shadow(color: .gray, radius: 1, x: 1, y: 1)
                        
                        Text("추가하기")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                }.padding(.bottom, 30)
                .alert(isPresented: $appendAlertBool, content: { appendAlert })
            }
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
        }
        .offset(x: selectedAppendWay == "드래그추가" ? 0 : UIScreen.main.bounds.width)
    }
}

struct DragAppendView_Previews: PreviewProvider {
    static var previews: some View {
        DragAppendView(savingFoodHelper: SavingFoodHelper(), selectedAppendWay: .constant(""))
    }
}
