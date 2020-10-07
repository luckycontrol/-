//
//  DirectAppendView.swift
//  refriger-management-project
//
//  Created by 조종운 on 2020/09/15.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI

struct DirectAppendView: View {
    
    @ObservedObject var savingFoodHelper: SavingFoodHelper
    
    @Binding var selectedAppendWay: String
    
    @State var foodImage: UIImage?
    
    @State var foodName: String = ""
    
    @State var foodType: String = ""
    
    @State var expiration: Date = Date()
    
    let foodCategoryList = ["과일", "채소", "정육", "해산물", "유제품"]
    
    @State var usingCameraActionSheet = false
    
    @State var usingCameraStatus = false
    
    /* CameraRoll 사용 설정 - [ 카메라 사용 / 앨범 사용 ] */
    @State var sourceType: UIImagePickerController.SourceType?
    
    /* 식료품 이미지 추가방식을 물어보는 ActionSheet - [ 카메라로 촬영 / 앨범에서 선택 ] */
    var UsingCameraAlert: ActionSheet {
        ActionSheet(
            title: Text("이미지 선택"),
            message: Text("이미지 선택 방법을 골라주세요."),
            buttons: [
                .default(Text("카메라 사용"), action: { self.usingCameraStatus = true ;  self.sourceType = .camera}),
                .default(Text("앨범에서 선택"), action: { self.usingCameraStatus = true ; self.sourceType = .photoLibrary }),
                .cancel(Text("취소"))
            ]
        )
    }
    
    /* 식자재 이름 누락 / 추가의사 확인 Alert */
    @State var noticeAlert: Alert?
    
    /* 위 Alert를 작동하기위한 Bool */
    @State var noticeAlertBool = false
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                
                VStack(alignment: .leading) {
                    /* 나가기 버튼 */
                    Button(action: {
                        withAnimation { self.selectedAppendWay = "" }
                        self.resetThisView()
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
                    
                    /* 식자재 정보 - [사진, 이름] */
                    HStack {
                        
                        Button(action: { self.usingCameraActionSheet = true }) {
                            ZStack {
                                Circle()
                                    .foregroundColor(.white)
                                    .frame(width: 80, height: 80)
                                    .shadow(color: .gray, radius: 1, x: 1, y: 1)
                                
                                if foodImage != nil {
                                    Image(uiImage: foodImage!)
                                        .renderingMode(.original)
                                        .resizable()
                                        .clipShape(Circle())
                                        .frame(width: 80, height: 80)
                                    
                                }
                            }
                        }
                        .actionSheet(isPresented: $usingCameraActionSheet, content: { UsingCameraAlert })
                        .sheet(isPresented: $usingCameraStatus, content: { UsingCameraRoll(foodImage: self.$foodImage, sourceType: self.$sourceType) })
                        
                        HStack {
                            Text("식자재 이름 : ")
                                .fontWeight(.bold)
                            
                            VStack {
                                TextField("", text: $foodName)
                                Divider()
                            }
                        }.padding(.leading, 30)
                        
                        Spacer()
                    }
                }.padding(15)
                
                /* 식자재 카테고리 선택 */
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(foodCategoryList, id: \.self) { category in
                            DirectCategoryView(foodType: self.$foodType, categoryName: category)
                        }
                    }
                    .padding()
                }
                
                
                HStack {
                    /* 유통기한선택 - 텍스트 */
                    Text("유통기한을 선택해주세요")
                        .font(.system(size: 15))
                        .fontWeight(.bold)
                    
                    /* 유통기한선택 - DatePicker */
                    DatePicker("", selection: $expiration, in: Date()..., displayedComponents: .date)
                }.padding()
                
                Spacer()
                
                /* 추가버튼 */
                Button(action: {
                    self.noticeAlertBool = true
                    
                    if self.foodName == "" || self.foodImage == nil {
                        self.noticeAlert = Alert(
                            title: Text("필요정보 누락"),
                            message: Text("식료품 이름을 기입해주세요."),
                            dismissButton: .cancel(Text("확인"))
                        )
                    }
                    else {
                        self.noticeAlert = Alert(
                            title: Text("식료품 추가"),
                            message: Text("선택하신 식자재를 추가하시겠습니까?"),
                            primaryButton: .default(Text("추가"), action: {
                                /* 식자재 넣고 */
                                self.savingFoodHelper.insertToList(
                                    food: ReadyForAppend(
                                        id: UUID(),
                                        foodName: self.foodName,
                                        foodType: self.foodType,
                                        foodImage: self.foodImage!,
                                        expiration: self.expiration
                                ))
    
                                /* 뷰 나가기 */
                                withAnimation {
                                    self.selectedAppendWay = ""
                                }
                            }),
                            secondaryButton: .cancel(Text("취소"))
                        )
                    }
                }) {
                    ZStack {
                        Capsule()
                            .frame(width: 300, height: 50)
                            .foregroundColor(Color("CategoryColor"))
                            .shadow(color: .gray, radius: 1, x: 1, y: 1)
                        
                        Text("추가하기")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                .alert(isPresented: $noticeAlertBool, content: { noticeAlert! })
            }
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
        }
        .offset(x: selectedAppendWay == "직접추가" ? 0 : UIScreen.main.bounds.width)
    }
    
    /* 뷰를 나갈 때 정보 초기화 */
    func resetThisView() {
        foodImage = nil
        foodName = ""
        foodType = ""
        expiration = Date()
    }
}

/* 카테고리 선택 뷰 */
struct DirectCategoryView: View {
    
    @Binding var foodType: String
    
    let categoryName: String
    
    var body: some View {
        Button(action: { self.foodType = self.categoryName }) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                    .shadow(color: .gray, radius: 1, x: 1, y: 1)
                
                VStack {
                    Image(foodType == categoryName ? categoryName + "선택" : categoryName)
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                    Text(categoryName)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
            }
        }
    }
}

struct DirectAppendView_Previews: PreviewProvider {
    static var previews: some View {
        DirectAppendView(savingFoodHelper: SavingFoodHelper(), selectedAppendWay: .constant(""))
    }
}
