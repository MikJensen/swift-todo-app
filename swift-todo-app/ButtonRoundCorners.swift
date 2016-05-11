//
//  ButtonRoundCorners.swift
//  swift-todo-app
//
//  Created by Jógvan Olsen on 5/11/16.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit

// http://stackoverflow.com/a/27293815/1832471

public extension UIButton{
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        self.layer.mask = mask
    }
}