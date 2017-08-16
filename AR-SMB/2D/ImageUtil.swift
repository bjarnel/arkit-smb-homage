//
//  ImageUtil.swift
//  SuperMarioAR
//
//  Created by Bjarne Lundgren on 08/08/2017.
//  Copyright © 2017 Silicon.dk ApS. All rights reserved.
//

import Foundation
import UIKit

class ImageUtil {
    // from stackoverflow
    class func flipImageLeftRight(_ image: UIImage) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: image.size.width, y: image.size.height)
        context.scaleBy(x: -image.scale, y: -image.scale)
        
        context.draw(image.cgImage!, in: CGRect(origin:CGPoint.zero, size: image.size))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    class func flipImageUpDown(_ originalImage: UIImage) -> UIImage? {

        //https://stackoverflow.com/questions/1135631/vertical-flip-of-cgcontext
        let tempImageView:UIImageView = UIImageView(image: originalImage)
        UIGraphicsBeginImageContext(tempImageView.frame.size)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        
        //let flipVertical:CGAffineTransform = CGAffineTransformMake(1,0,0,-1,0,tempImageView.frame.size.height)
        let flipVertical:CGAffineTransform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: tempImageView.frame.size.height)
        context.concatenate(flipVertical)
        tempImageView.layer .render(in: context)
        
        let flippedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return flippedImage
        
        /*
        let image:UIImage = UIImage(cgImage: image.cgImage!,
                                    scale: image.scale,
                                    orientation: UIImageOrientation.rightMirrored)
        return image
        */
    }
}
