//
//  UITextField+Extension.swift
//  100DaysForEnglish
//
//  Created by Vu Tinh on 2/23/17.
//  Copyright © 2017 Vu Tinh. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    @IBInspectable var placeHolderTextColor: UIColor? {
        set {
            let placeholderText = self.placeholder != nil ? self.placeholder! : ""
            attributedPlaceholder = NSAttributedString(string:placeholderText, attributes:[NSForegroundColorAttributeName: newValue!])
        }
        get{
            return self.placeHolderTextColor
        }
    }
}
