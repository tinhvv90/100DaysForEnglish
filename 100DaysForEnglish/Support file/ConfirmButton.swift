//
//  Button.swift
//  CustomerTaxiApp
//
//  Created by Trương Thắng on 1/14/17.
//  Copyright © 2017 Trương Thắng. All rights reserved.
//

import UIKit

@IBDesignable class ConfirmButton: UIButton {
    @IBInspectable var disableColor : UIColor = UIColor.darkGrayColor() {
        didSet {
            self.setBackgroundImage(UIImage(color: disableColor), forState: .Disabled)
        }
    }
    
    @IBInspectable var enableColor : UIColor  = UIColor.whiteColor() {
        didSet {
            self.setBackgroundImage(UIImage(color: enableColor), forState: .Normal)
        }
    }
}

public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.CGImage else { return nil }
        self.init(CGImage: cgImage)
    }
}
