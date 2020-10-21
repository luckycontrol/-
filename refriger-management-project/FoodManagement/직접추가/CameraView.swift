//
//  CameraView.swift
//  refriger-management-project
//
//  Created by 조종운 on 2020/10/13.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI

struct CameraView: View {
    
    @Binding var usingCameraStatus: Bool
    
    @Binding var foodImage: UIImage?
    
    @Binding var sourceType: UIImagePickerController.SourceType?
    
    var body: some View {
        if sourceType == .camera {
            ZStack {
                UsingCameraRoll(foodImage: $foodImage, sourceType: $sourceType)
                
                VStack {
                    Text("음식촬영")
                }
                .padding()
            }
        }
        else if sourceType == .photoLibrary {
            UsingCameraRoll(foodImage: $foodImage, sourceType: $sourceType)
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView(usingCameraStatus: .constant(false), foodImage: .constant(UIImage.init()), sourceType: .constant(.none))
    }
}
