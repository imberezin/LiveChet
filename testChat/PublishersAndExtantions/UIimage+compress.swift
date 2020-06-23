//
//  UIimage+compress.swift
//  testChat
//
//  Created by israel.berezin on 22/06/2020.
//  Copyright © 2020 Israel Berezin. All rights reserved.
//

import Foundation

import UIKit


extension UIImage {

    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    func resizedTo1MB() -> UIImage? {
        guard let imageData = self.pngData() else { return nil }
        let megaByte = 1000.0

        var resizingImage = self
        var imageSizeKB = Double(imageData.count) / megaByte // ! Or devide for 1024 if you need KB but not kB

        while imageSizeKB > megaByte { // ! Or use 1024 if you need KB but not kB
            guard let resizedImage = resizingImage.resized(withPercentage: 0.5),
            let imageData = resizedImage.pngData() else { return nil }

            resizingImage = resizedImage
            imageSizeKB = Double(imageData.count) / megaByte // ! Or devide for 1024 if you need KB but not kB
        }

        return resizingImage
    }
    
    func resizedToHalfMB() -> UIImage? {
        guard let imageData = self.pngData() else { return nil }
        let megaByte = 500.0

        var resizingImage = self
        var imageSizeKB = Double(imageData.count) / megaByte // ! Or devide for 1024 if you need KB but not kB

        while imageSizeKB > megaByte { // ! Or use 1024 if you need KB but not kB
            guard let resizedImage = resizingImage.resized(withPercentage: 0.5),
            let imageData = resizedImage.pngData() else { return nil }

            resizingImage = resizedImage
            imageSizeKB = Double(imageData.count) / megaByte // ! Or devide for 1024 if you need KB but not kB
        }

        return resizingImage
    }

        func resizeWithPercent(percentage: CGFloat) -> UIImage? {
            let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
            imageView.contentMode = .scaleAspectFit
            imageView.image = self
            UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
            guard let context = UIGraphicsGetCurrentContext() else { return nil }
            imageView.layer.render(in: context)
            guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
            UIGraphicsEndImageContext()
            return result
        }
    
        func resizeWithWidth(width: CGFloat) -> UIImage? {
            let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
            imageView.contentMode = .scaleAspectFit
            imageView.image = self
            UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
            guard let context = UIGraphicsGetCurrentContext() else { return nil }
            imageView.layer.render(in: context)
            guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
            UIGraphicsEndImageContext()
            return result
        }
    

}
