//
//  UIColor.swift
//  firebase-messenger
//
//  Created by r3d on 25/10/2017.
//  Copyright © 2017 Alexandru Corut. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
