//
//  UIButton.swift
//  itop
//
//  Created by APPLE on 20/10/22.
//

import Foundation

import UIKit

extension UIButton {
    func roundedButton() {
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.bottomRight],
                                     cornerRadii: CGSize(width: 90, height: 90))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    
    private func image(withColor color: UIColor) -> UIImage? {
            let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
            UIGraphicsBeginImageContext(rect.size)
            let context = UIGraphicsGetCurrentContext()

            context?.setFillColor(color.cgColor)
            context?.fill(rect)

            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return image
        }

    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
            self.setBackgroundImage(image(withColor: color), for: state)
        }
}
