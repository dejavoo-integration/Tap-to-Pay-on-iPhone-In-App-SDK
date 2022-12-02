//
//  WifiViewController.swift
//  itop
//
//  Created by APPLE on 19/11/22.
//

import UIKit

class WifiViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var excellentBtn: UILabel!
    @IBOutlet weak var checkConnection: UIButton!
    @IBOutlet weak var configureButton: UIButton!
    @IBOutlet weak var gprsButton: UIButton!
    @IBOutlet weak var wifiButton: UIButton!
    @IBOutlet weak var ethernetButton: UIButton!
    @IBOutlet weak var bluetoothButton: UIButton!
    
    @IBOutlet weak var wifiImage: UIImageView!
    
    @IBOutlet weak var closeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dropShadow()
        cornerRadius()
    }
    
   
    func cornerRadius() {
        gprsButton.layer.cornerRadius = 10
        wifiButton.layer.cornerRadius = 10
        ethernetButton.layer.cornerRadius = 10
        bluetoothButton.layer.cornerRadius = 10
        excellentBtn.layer.cornerRadius = 20
    }
    
    func dropShadow() {
       
        checkConnection.addShadowToButton( cornerRadius: 10)
        configureButton.addShadowToButton(cornerRadius: 10)
        headerLabel.addShadowToTextField(color: .gray,cornerRadius:20)
       wifiImage .setImageColor(color: UIColor(hexString: "#3E97A8"))
     
    }
    
    
    
    
    @IBAction func closeBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
        
    }
    
}
