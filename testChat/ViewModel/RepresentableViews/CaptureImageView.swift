//
//  CaptureImageView.swift
//  testChat
//
//  Created by israel.berezin on 22/06/2020.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import SwiftUI

struct CaptureImageView: UIViewControllerRepresentable {
    
    /// MARK: - Properties
    @Binding var isShown: Bool
    @Binding var image: Image?
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: $isShown, image: $image)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CaptureImageView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        /// Default is images gallery. Un-comment the next line of code if you would like to test camera
        //    picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<CaptureImageView>) {
        
    }
    
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        @Binding var isCoordinatorShown: Bool
        @Binding var imageInCoordinator: Image?
        
        init(isShown: Binding<Bool>, image: Binding<Image?>) {
            _isCoordinatorShown = isShown
            _imageInCoordinator = image
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            
            let imgData = NSData(data: unwrapImage.jpegData(compressionQuality: 1)!)
            let imageSize: Int = imgData.count
            print("actual size of image in KB: %f ", Double(imageSize) / 1000.0)
            
            
            let newImage = unwrapImage.resizedToHalfMB()
            let imgData1 = NSData(data: newImage!.jpegData(compressionQuality: 1)!)
            let imageSize1: Int = imgData1.count
            print("new size of image in KB: %f ", Double(imageSize1) / 1000.0)

            let strBase64 = imgData1.base64EncodedString(options: .lineLength64Characters)

            DataService.instance.updateUserImage(image: strBase64)
            imageInCoordinator = Image(uiImage: newImage!)
            isCoordinatorShown = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isCoordinatorShown = false
        }
    }
    
}

/*
 let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage

 let imgData = NSData(data: image.jpegData(compressionQuality: 1)!)
 var imageSize: Int = imgData.count
 print("actual size of image in KB: %f ", Double(imageSize) / 1000.0)

 */
