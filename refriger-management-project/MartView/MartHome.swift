//
//  MartHome.swift
//  refriger-management-project
//
//  Created by 조종운 on 2020/08/22.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct MartHome: View {
    
    @ObservedObject private var categorySelector = CategorySelector()
    
    @EnvironmentObject var userHelper: UserHelper
    
    @ObservedObject private var cartHelper = CartHelper()
    
    @State var view = "마트"
    
    @State private var menuFoodCategory = "과일"
    
    @State private var menuFoodType = "딸기 / 블루베리"
    
    @State var cartlist: [CartFoodType] = []
    
    var body: some View {
        ZStack {
            /* 메뉴 뷰 */
            Menu(categorySelector: categorySelector, view: $view, menuFoodCategory: $menuFoodCategory, menuFoodType: $menuFoodType, cartlist: $cartlist)
            
            /* 식자재 리스트 출력 뷰 */
            FoodList(view: $view, menuFoodCategory: $menuFoodCategory, menuFoodType: $menuFoodType, cartlist: $cartlist)
                .offset(x: view == "메뉴" ? UIScreen.main.bounds.width * 3/4 : .zero)
            
            /* 로그인 화면 */
            Login(view: $view)
                .offset(y: view == "로그인" ? 0 : UIScreen.main.bounds.height)
            
            /* 유저 정보 화면 */
            UserInfo(view: $view)
                .offset(y: view == "유저정보" ? 0 : UIScreen.main.bounds.height)
            
            /* 장바구니 */
            Cart(view: $view, cartlist: $cartlist)
                .offset(y: view == "카트" ? 0 : UIScreen.main.bounds.height)
            
        }
        .accentColor(.black)
    }
}

class CategorySelector: ObservableObject {
    @Published var menu = false
    @Published var category = true
    @Published var foodCategory = "과일"
    @Published var foodType = "딸기 / 블루베리"
    @Published var cart = false
}

class UserHelper: ObservableObject {
    @Published var login = false
    
    @Published var userEmail: String?
    @Published var userName: String?
    @Published var userAddress: String?
    @Published var userHp: String?
    
    /* 아이디 중복검사 */
    func emailDuplicateCheck(_ email: String, completion: @escaping (Bool, Bool) -> Void) {
        
        var duplicate = false
        
        firebase_db
            .collection("User").getDocuments(completion: { (snapShot, error) in
                if let error = error {
                    print(error)
                } else {
                    for document in snapShot!.documents {
                        if document.documentID == email {
                            duplicate = true
                        }
                    }
                    
                    completion(true, duplicate)
                }
            })
    }
    
    /* 회원가입 및 유저정보 기입 */
    func insertUserInfo(id: String, passwd: String, name: String, hp: String, address: String, completion: @escaping (Bool) -> Void) {
        /* 계정생성 */
        Auth.auth().createUser(withEmail: id, password: passwd) { authResults, error in
            /* 유저정보 기입 */
            firebase_db
                .collection("User").document(id).setData([
                    "userName": name,
                    "hp": hp,
                    "address": address
                ])
            
            completion(true)
        }
    }
    
    /* 로그인 후 회원정보 가져오기 [ 주소, hp, 사용자이름 ]  */
    func getUserInfo(id: String, completion: @escaping (Bool, String, String, String) -> Void) {
        var address: String = ""
        var hp: String = ""
        var name: String = ""
        
        firebase_db.collection("User").document(id).getDocument { document, error  in
            if document!.exists {
                address = document!.data()!["address"] as! String
                hp = document!.data()!["hp"] as! String
                name = document!.data()!["userName"] as! String
            }
            
            completion(true, address, hp, name)
        }
    }
}

struct MartHome_Previews: PreviewProvider {
    static var previews: some View {
        MartHome()
    }
}
