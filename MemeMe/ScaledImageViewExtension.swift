//
//  ScaledImageViewExtension.swift
//  MemeMe
//
//  Created by Niklas Rammerstorfer on 11/09/2017.
//  Copyright © 2017 rammerstorfer. All rights reserved.
//

import UIKit

extension UIImageView{
    
    /// This method mimics the native calculations of an UIImageView when in contentMode aspectFit. 
    /// When another contentMode is set, this property simply returns nil. 
    /// It returns a CGRect with the size of the actual displayed image.
    var containingImageRectangle: CGRect? {
        get{
            guard self.contentMode == .scaleAspectFit else{
                return nil
            }
            
            let imageViewSize = self.frame.size
            let imgSize = self.image?.size
            
            guard let imageSize = imgSize, imgSize != nil else {
                return CGRect.zero
            }
            
            let scaleWidth = imageViewSize.width / imageSize.width
            let scaleHeight = imageViewSize.height / imageSize.height
            let aspect = fmin(scaleWidth, scaleHeight)
            
            var imageRect = CGRect(x: 0, y: 0, width: imageSize.width * aspect, height: imageSize.height * aspect)
            
            // Center image
            imageRect.origin.x = (imageViewSize.width - imageRect.size.width) / 2
            imageRect.origin.y = (imageViewSize.height - imageRect.size.height) / 2
            
            // Add imageView offset
            imageRect.origin.x += self.frame.origin.x
            imageRect.origin.y += self.frame.origin.y
            
            return imageRect
        }
    }
}
