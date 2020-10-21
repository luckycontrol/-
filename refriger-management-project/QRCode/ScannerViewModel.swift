//
//  ScannerViewModel.swift
//  refriger-management-project
//
//  Created by 조종운 on 2020/10/04.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI
import Foundation

class ScannerViewModel: ObservableObject {
    
    let scanInterval: Double = 5.0
    
    @Published var torchIsOn: Bool = false
    @Published var viewStatus: Bool = false
    @Published var lastQrCode: String = ""
    
    // MARK: QR코드로 스캔한 주문을 가져온다.
    func getPurchaseFood(_ order: String, completion: @escaping (Bool, [String], [String], [Date]) -> Void) {
        let order = order.split(separator: "-")
        let orderId = order[0]
        let orderEmail = order[1]
        
        var foodNames: [String] = []
        var foodCategory: [String] = []
        var foodExpirations: [Date] = []
        
        firebase_db.document("Delivered/\(orderEmail)/\(orderId)/Food").getDocument { document, error in
            if let document = document, document.exists {
                foodNames = document.data()!["foodNames"] as! [String]
                foodCategory = document.data()!["foodCategory"] as! [String]
            }
            
            for index in 0 ..< foodNames.count {
                if foodCategory[index] == "과일" {
                    foodExpirations.append(Date.init(timeIntervalSinceNow: 86400 * 3))
                }
                else if foodCategory[index] == "채소" {
                    foodExpirations.append(Date.init(timeIntervalSinceNow: 86400 * 5))
                }
                else {
                    foodExpirations.append(Date.init(timeIntervalSinceNow: 86400 * 7))
                }
            }
        
            completion(true, foodNames, foodCategory, foodExpirations)
        }
    }
    
    // MARK: firebase의 Delivered에서 해당 주문의 Food와 orderInfo를 삭제
    func deleteOrderInFirebase(_ order: String) {
        let order = order.split(separator: "-")
        let orderId = order[0]
        let orderEmail = order[1]
        
        firebase_db.document("Delivered/\(orderEmail)/\(orderId)/Food").delete()
        firebase_db.document("Delivered/\(orderEmail)/\(orderId)/orderInfo").delete()
    }
    
    // MARK: firebase의 Delivered에서 주문자 이메일의 orderArr 에서 선택한 주문을 삭제
    func editOrderArrInFirebase(_ order: String) {
        let order = order.split(separator: "-")
        let orderEmail = order[1]
        
        firebase_db.document("Delivered/\(orderEmail)").getDocument { document, error in
            if let document = document, document.exists {
                var orderArr = document.data()!["orderArr"] as! [String]
                
                for index in 0 ..< orderArr.count {
                    if orderArr[index] == order.joined(separator: "-") {
                        orderArr.remove(at: index)
                        break
                    }
                }
                
                if orderArr.count == 0 {
                    firebase_db.document("Delivered/\(orderEmail)").delete()
                } else {
                    firebase_db.document("Delivered/\(orderEmail)").setData([
                        "orderArr" : orderArr
                    ], merge: true)
                }
            }
        }
    }
}
