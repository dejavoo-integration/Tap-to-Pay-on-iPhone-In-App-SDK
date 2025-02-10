//
//  Loader.swift
//  IceCream
//
//  Created by Giri on 2/10/25.
//

import Foundation
import UIKit

let LoaDer = LoadingOverlay.shared

public class LoadingOverlay {
    
    var overlayView = UIView()
    var activityIndicator = UIImageView()
    let views = UIView()
    let loaderimage = UIImageView()
    let titlelb = UILabel()
    let subtitle = UILabel()
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    public func showOverlay(view: UIView) {
        
        overlayView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        overlayView.center = view.center
        
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        
        views.frame = CGRect(x: 10, y: screenHeight/2 - 50, width: screenWidth - 20, height: 128)
        views.layer.cornerRadius = 15
        views.layer.borderWidth = 2
        views.layer.borderColor = #colorLiteral(red: 0.2590000033, green: 0.6470000148, blue: 0.9610000253, alpha: 1)
        loaderimage.frame = CGRect(x: 20, y: views.bounds.height/2-25, width: 50, height: 50)
        
        loaderimage.image = UIImage(named: "Logo")
        
        views.backgroundColor = .white
        views.addSubview(loaderimage)
        titlelb.frame = CGRect(x: 100 , y: 40, width: Int(overlayView.frame.width)/2, height: 20)
        titlelb.text = "Processing..."
        titlelb.textColor = .black
        titlelb.font = .boldSystemFont(ofSize: 16)
        views.addSubview(titlelb)
        subtitle.frame = CGRect(x: 100 , y: Int(titlelb.frame.height) + 45, width: Int(overlayView.frame.width)/2, height: 20)
        subtitle.text = "Please wait..."
        subtitle.textColor = .black
        subtitle.font = .boldSystemFont(ofSize: 14)
        views.addSubview(subtitle)
      
        overlayView.addSubview(views)
        overlayView.backgroundColor = UIColor(displayP3Red: 0.0/256, green: 0.0/256, blue: 0.0/256, alpha: 0.7)
        overlayView.alpha = 0.95
        
        view.addSubview(overlayView)
    }
    
    public func hideOverlayView() {
        
        if overlayView.superview != nil {
            overlayView.removeFromSuperview()
        }
        
    }
}
