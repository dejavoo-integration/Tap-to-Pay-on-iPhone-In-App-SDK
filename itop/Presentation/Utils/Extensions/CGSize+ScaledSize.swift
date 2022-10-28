//
//  CGSize.swift
//  itop
//
//  Created by meganathan on 21/07/22.
//


import Foundation
import UIKit

extension CGSize {
    var scaledSize: CGSize {
        .init(width: width * UIScreen.main.scale, height: height * UIScreen.main.scale)
    }
}
