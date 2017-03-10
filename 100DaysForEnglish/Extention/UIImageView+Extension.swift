//
//  UIImageView+Extension.swift
//  100DaysForEnglish
//
//  Created by Vu Tinh on 2/23/17.
//  Copyright © 2017 Vu Tinh. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func setImageFromURl(stringImageUrl url: String){
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOfURL: url) {
                self.image = UIImage(data: data)
            }
        }
    }
}

