//
//  UsingCameraRoll.swift
//  refriger-management-project
//
//  Created by 조종운 on 2020/09/16.
//  Copyright © 2020 조종운. All rights reserved.
//

import Foundation
import SwiftUI

struct UsingCameraRoll: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var foodImage: UIImage?
    
    @Binding var sourceType: UIImagePickerController.SourceType?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<UsingCameraRoll>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType!
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: UsingCameraRoll
        
        init(_ parent: UsingCameraRoll) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.foodImage = uiImage
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
