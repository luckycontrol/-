//
//  SelfAppendCategoryData.swift
//  refriger-management-project
//
//  Created by 조종운 on 2020/09/13.
//  Copyright © 2020 조종운. All rights reserved.
//

import Foundation
import SwiftUI

let selfAppendData: [SelfAppendCategory] = load_category_data("SelfAppendDataSet.json")

func load_category_data<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError("파일을 불러올 수 없습니다.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("파일을 데이터 타입으로 변환할 수 없습니다.")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("데이터를 JSON으로 디코딩 할 수 없습니다.")
    }
}

struct SelfAppendCategory: Identifiable, Codable, Hashable {
    var id: Int
    var foodName: String
    var foodType: String
}

/* 식료품을 저장하기 위한 클래스 */
class SavingFoodHelper: ObservableObject {
    @Published var readyForAppend: [[ReadyForAppend]] = []
    
    @Published var appendFood = SelfAppendCategory(id: 0, foodName: "", foodType: "")
    
    @Published var removeFood: ReadyForAppend?
    @Published var isRemove = false
    
    /* 선택된 식자재를 리스트에 추가 */
    func insertToList(food: ReadyForAppend) {
        if readyForAppend.count == 0 {
            readyForAppend.append([food])
        } else {
            
            if readyForAppend[readyForAppend.count - 1].count < 3 {
                readyForAppend[readyForAppend.count - 1].append(food)
            } else {
                readyForAppend.append([food])
            }
        }
    }
    
    /* 리스트에 있는 선택된 식자재를 삭제 */
    func deleteInList(food: ReadyForAppend, completion: @escaping (Bool) -> Void) {
        for row in 0 ..< readyForAppend.count {
            for index in 0 ..< readyForAppend[row].count {
                if readyForAppend[row][index].id == food.id {
                    readyForAppend[row].remove(at: index)
                    break
                }
            }
        }
        
        if reorderInList() {
            completion(true)
        }
    }
    
    /* 배열을 재 정렬한다. [ 삭제후 바르게 출력하기 위해서.. ] */
    func reorderInList() -> Bool {
        var temp: [ReadyForAppend] = []
        
        for row in 0 ..< readyForAppend.count {
            for index in 0 ..< readyForAppend[row].count {
                temp.append(readyForAppend[row][index])
            }
        }
        
        readyForAppend = []
        
        /* readyForAppend배열에 다시 삽입 */
        for food in temp {
            insertToList(food: food)
        }
        
        return true
    }
    
    /* 리스트를 내장 DB에 저장 */
    
}

/* 저장된 식자재를 위한 클래스 */
class SavedFoodHelper: ObservableObject {
    @Published var savedFoodList: [ReadyForAppend] = []
    @Published var changeSortingWay: String = "일반"
    
    /* DB에서 가져오기 */
    
    /* DB에 리스트 넣기 */
    
    /* 해당 식료품을 리스트에서 지우기 */
    
    
}

struct ReadyForAppend: Identifiable, Equatable{
    var id: UUID
    var foodName: String
    var foodType: String
    var foodImage: UIImage
    var expiration: Date
}
