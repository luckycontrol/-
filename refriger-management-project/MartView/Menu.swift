//
//  Menu.swift
//  refriger-management-project
//
//  Created by 조종운 on 2020/08/22.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct Menu: View {
    
    @EnvironmentObject var tabViewHelper: TabViewHelper
    
    @ObservedObject var categorySelector: CategorySelector
    
//    @ObservedObject var userHelper: UserHelper
    
    @EnvironmentObject var userHelper: UserHelper
    
    @ObservedObject var cartHelper: CartHelper
    
    var body: some View {
        HStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 15) {
                    /* 사용자 버튼 - 로그인 or 회원정보 */
                    Button(action: {
                        withAnimation {
                            categorySelector.menu = false
                            
                            tabViewHelper.isOn = false
                            
                            if self.userHelper.login {
                                self.userHelper.user_info = true
                            } else {
                                self.userHelper.login_locate = true
                            }
                        }
                    }) {
                        VStack(alignment: .leading) {
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 70, height: 70)
                            
                            Text("안녕하세요.")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            if userHelper.login {
                                Text("\(userHelper.userName) 님")
                                    .font(.system(size: 24))
                                    .fontWeight(.semibold)
                            }
                        }
                    }.padding(.bottom, 30)
                        
                    /* 카테고리 버튼 - 선택할 수 있는 식자재 목록 출력 */
                    Button(action: {
                        withAnimation {
                            self.categorySelector.category.toggle()
                        }
                    }) {
                        HStack {
                            Text("카테고리")
                                .foregroundColor(categorySelector.category ? Color("MenuCategory") : Color.white)
                                .fontWeight(categorySelector.category ? .bold : .none)
                        }
                        .padding(.horizontal, categorySelector.category ? 10 : 0)
                        .padding(.vertical, categorySelector.category ? 8 : 0)
                        .background(categorySelector.category ? Color("MenuCategory").opacity(0.2) : Color.clear)
                        .cornerRadius(10)
                    }
                    
                    /* 카테고리 메뉴 - 카테고리 버튼 누르면 활성화 */
                    if categorySelector.category {
                        CategoryMenu(categorySelector: categorySelector)
                    }
                    
                    /* 장바구니 버튼 - 로그인 됐을때만 활성화 */
                    Button(action: {
                        if self.userHelper.login {
                            self.cartHelper.loadCart((Auth.auth().currentUser?.email!)!) { (isSuccess) in
                                if isSuccess {
                                    withAnimation {
                                        tabViewHelper.isOn = false
                                        categorySelector.menu = false
                                        categorySelector.cart = true
                                    }
                                }
                            }
                        } else {
                            withAnimation {
                                tabViewHelper.isOn = false
                                categorySelector.menu = false
                                userHelper.login_locate = true
                            }
                        }
                    }) {
                        Text("장바구니")
                    }
                    
                    Divider()
                        .frame(width: 150, height: 2)
                        .background(Color.white)
                        .padding(.vertical, 25)
                    
                    /* 로그아웃 버튼 */
                    if userHelper.login {
                        Button(action: {
                            do {
                                try Auth.auth().signOut()
                                withAnimation {
                                    self.userHelper.login = false
                                }
                            } catch let error as NSError {
                                print(error)
                            }
                        }) {
                            Text("로그아웃")
                        }
                    }
                    
                    Spacer()
                }
                .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                .padding(.leading, 20)
                .foregroundColor(.white)
            }
            Spacer()
        }
        .background(Color("MenuBackground").edgesIgnoringSafeArea(.all))
    }
}

struct CategoryMenu: View {
    
    @ObservedObject var categorySelector: CategorySelector
    
    @State var index = 1
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            /* 카테고리 선택버튼 - 과일 */
            Button(action: { withAnimation { self.index = 1 }}) {
                HStack {
                    Text("과일")
                        .foregroundColor(index == 1 ? Color("MenuCategory") : .white)
                        .fontWeight(index == 1 ? .bold : .none)
                }
            }
            
            /* 푸드타입 선택 - 과일 ( 딸기/블루베리 | 감귤/한라봉 | 사과 ) */
            if index == 1 {
                VStack(alignment: .leading, spacing: 10) {
                    Button(action: {
                        self.categorySelector.foodCategory = "과일"
                        self.categorySelector.foodType = "딸기 / 블루베리"
                    }) {
                        Text("딸기 / 블루베리")
                    }
                    
                    Button(action: {
                        self.categorySelector.foodCategory = "과일"
                        self.categorySelector.foodType = "감귤 / 한라봉"
                    }) {
                        Text("감귤 / 한라봉")
                    }
                    
                    Button(action: {
                        self.categorySelector.foodCategory = "과일"
                        self.categorySelector.foodType = "사과"
                    }) {
                        Text("사과")
                    }
                }
                .padding(.leading, 15)
            }
            
            /* 카테고리 선택버튼 - 채소 */
            Button(action: { withAnimation { self.index = 2 }}) {
                HStack {
                    Text("채소")
                        .foregroundColor(index == 2 ? Color("MenuCategory") : .white)
                        .fontWeight(index == 2 ? .bold : .none)
                }
            }
            
            /* 푸드타입 선택 - 채소 ( 고구마/감자 | 상추/깻잎 | 시금치/부추 ) */
            if index == 2 {
                VStack(alignment: .leading, spacing: 10) {
                    Button(action: {
                        self.categorySelector.foodCategory = "채소"
                        self.categorySelector.foodType = "고구마 / 감자"
                    }) {
                        Text("고구마 / 감자")
                    }
                    
                    Button(action: {
                        self.categorySelector.foodCategory = "채소"
                        self.categorySelector.foodType = "상추 / 깻잎"
                    }) {
                        Text("상추 / 깻잎")
                    }
                    
                    Button(action: {
                        self.categorySelector.foodCategory = "채소"
                        self.categorySelector.foodType = "시금치 / 부추"
                    }) {
                        Text("시금치 / 부추")
                    }
                }
                .padding(.leading, 15)
            }
            
            /* 카테고리 선택버튼 - 정육 */
            Button(action: { withAnimation { self.index = 3 }}) {
                HStack {
                    Text("정육")
                        .foregroundColor(index == 3 ? Color("MenuCategory") : .white)
                        .fontWeight(index == 3 ? .bold : .none)
                }
            }
            
            /* 푸드타입 선택 - 과일 ( 소고기 | 돼지고기 | 닭/오리고기 ) */
            if index == 3 {
                VStack(alignment: .leading, spacing: 10) {
                    Button(action: {
                        self.categorySelector.foodCategory = "정육"
                        self.categorySelector.foodType = "소고기"
                    }) {
                        Text("소고기")
                    }
                    
                    Button(action: {
                        self.categorySelector.foodCategory = "정육"
                        self.categorySelector.foodType = "돼지고기"
                    }) {
                        Text("돼지고기")
                    }
                    
                    Button(action: {
                        self.categorySelector.foodCategory = "정육"
                        self.categorySelector.foodType = "닭 / 오리고기"
                    }) {
                        Text("닭 / 오리고기")
                    }
                }
                .padding(.leading, 15)
            }
        }
        .padding(.leading, 15)
    }
}



struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu(categorySelector: CategorySelector(), cartHelper: CartHelper())
    }
}
