//
//  CALayer+Extension.swift
//  CustomerTaxiApp
//
//  Created by Trương Thắng on 12/6/16.
//  Copyright © 2016 Trương Thắng. All rights reserved.
//

import UIKit

// MARK: - <#Mark#>

extension CALayer {
    @IBInspectable var borderUIColor: UIColor? {
        set{
            if let color = newValue {
                borderColor = color.CGColor
            }
        }
        get {
            if let color = borderColor {
                return UIColor(CGColor: color)
            } else {
                return nil
            }
        }
    }
}
