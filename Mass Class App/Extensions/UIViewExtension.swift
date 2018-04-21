//
//  UIView.swift
//  OpenMBOiOS
//
//  Created by Christian Flanders on 2/8/18.
//

import Foundation
import UIKit

extension UIView {

    func drawCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
    }

    func drawShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 1.75
        self.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        self.layer.shadowOpacity = 0.75
//        self.layer.shouldRasterize = true
    }


    func drawGradient(colors: [CGColor]) {
        let layer = CAGradientLayer()
        layer.frame = self.frame
        layer.colors = colors
      self.layer.insertSublayer(layer, at: 0)

    }
}
