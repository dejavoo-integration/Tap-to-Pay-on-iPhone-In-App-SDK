//
//  RoundButton.swift
//  itop
//
//  Created by meganathan on 22/07/22.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {

    @IBInspectable var roundButton:Bool = false {
        didSet{
            if roundButton {
                layer.cornerRadius = 15 //frame.height / 2
            }
        }
    }
    
    override func prepareForInterfaceBuilder() {
        if roundButton {
            layer.cornerRadius = 15 //frame.height / 2
        }
    }
}
