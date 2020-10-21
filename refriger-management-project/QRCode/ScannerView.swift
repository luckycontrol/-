//
//  ScannerView.swift
//  refriger-management-project
//
//  Created by 조종운 on 2020/10/04.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI

struct ScannerView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @EnvironmentObject var tabViewHelepr: TabViewHelper
    
    @ObservedObject var viewModel = ScannerViewModel()
    
    @Binding var scannerStatus: Bool
    
    var body: some View {
        ZStack {
            if scannerStatus {
                QrCodeScannerView()
                    .found(r: self.onFoundQRCode)
                    .torchLight(isOn: self.viewModel.torchIsOn)
                    .interval(delay: self.viewModel.scanInterval)
                    .edgesIgnoringSafeArea(.all)
            }
            
            VStack {
                
                HStack {
                    Button(action: {
                        withAnimation {
                            scannerStatus = false
                            tabViewHelepr.isOn = true
                        }
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .frame(width: 30, height: 30)
                    }
                    Spacer()
                }
                
                VStack {
                    Text("QR코드를 스캔해주세요")
                        .font(.subheadline)
                        .fontWeight(.bold)
                }
                .padding(.vertical, 20)
                
                Spacer()
                
                HStack {
                    Button(action: {
                        viewModel.torchIsOn.toggle()
                    }, label: {
                        Image(systemName: viewModel.torchIsOn ? "bolt.fill" : "bolt.slash.fill")
                            .imageScale(.large)
                            .foregroundColor(viewModel.torchIsOn ? Color.yellow : Color.blue)
                            .padding()
                    })
                }
                .background(Color.white)
                .cornerRadius(10)
            }
            .padding()
        }
        .offset(y: scannerStatus ? .zero : UIScreen.main.bounds.height)
    }
    
    
    // MARK: QR코드를 스캔할 때
    func onFoundQRCode(_ code: String) {
        let order = code
        
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        
        // Delivered에서 해당 주문의 Food [ foodNames, foodCounts, foodCategory ] 를 가져온다.
        
        // 식료품 정보들에 유통기한을 부여한다. 과일: +3일, 채소: +5일, 정육: +7일
        
        // 식료품을 CoreData에 저장한다.
        viewModel.getPurchaseFood(order) { isSuccess, foodNames, foodCategory, foodExpirations in
            if isSuccess {
                
                scannerStatus = false
                tabViewHelepr.isOn = true
                
                for index in 0 ..< foodNames.count {
                    
                    let food = FoodInInnerDB(context: self.managedObjectContext)
                    
                    food.id = UUID()
                    food.foodName = foodNames[index]
                    food.foodType = foodCategory[index]
                    food.foodImage = nil
                    food.expiration = foodExpirations[index]
                    
                }
                
                do {
                    try managedObjectContext.save()
                } catch {
                    print("저장 실패 \(error)")
                }
                
                // Delivered에서 해당 주문을 지운다.
                viewModel.deleteOrderInFirebase(order)
                
                // Delivered에서 orderArr을 수정한다. orderArr이 비었다면 이메일 Document를 삭제한다.
                viewModel.deleteOrderInFirebase(order)
                
                viewModel.editOrderArrInFirebase(order)
            }
        }
    }
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView(scannerStatus: .constant(false))
    }
}
