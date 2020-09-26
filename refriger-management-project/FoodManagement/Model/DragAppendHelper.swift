//
//  DragAppendHelper.swift
//  refriger-management-project
//
//  Created by 조종운 on 2020/09/15.
//  Copyright © 2020 조종운. All rights reserved.
//

import Foundation
import SwiftUI

// 카테고리 리스트
class DragAppendHelper: ObservableObject {
    @Published var selectedList: [[SelfAppendCategory]] = []
    
    init() {
        getCategoryList("과일")
    }
    
    /* 선택된 카테고리의 식자재 리스트 생성 */
    func getCategoryList(_ category: String) {
        self.selectedList.removeAll()
        
        for food in selfAppendData {
            if food.foodType == category {
                if selectedList.count == 0 {
                    selectedList.append([food])
                } else {
                    
                    if selectedList[selectedList.count - 1].count < 5 {
                        selectedList[selectedList.count - 1].append(food)
                    } else {
                        selectedList.append([food])
                    }
                }
            }
        }
    }
}
