//
//  SupportViewController.swift
//  
//
//  Created by APPLE on 19/11/22.
//

import UIKit

class SupportViewController: UIViewController {
    
    
    @IBOutlet weak var contactUs: UIButton!
    @IBOutlet weak var demoVideos: UIButton!
    @IBOutlet weak var callMeBack: UIButton!
    @IBOutlet weak var uploadLog: UIButton!
    @IBOutlet weak var remoteDiagnosis: UIButton!
    @IBOutlet weak var hardwareDiagnosis: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var closeImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cornerRadius()
        dropShadow()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        tapGesture()
        
    }
    
    func tapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
          closeImage.isUserInteractionEnabled = true
           closeImage.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        UIView.animate(withDuration: 0.3, animations: {
            self.heightConstraint.constant = 0
            self.view.layoutIfNeeded()
        }) { [self](status) in
           
        }

    }
    
    func dropShadow() {
        headerLabel.addShadowToTextField(color: .gray,cornerRadius:20)
      
    }
    

    func cornerRadius() {
        contactUs.layer.cornerRadius = 10
        demoVideos.layer.cornerRadius = 10
        callMeBack.layer.cornerRadius = 10
        uploadLog.layer.cornerRadius = 10
        remoteDiagnosis.layer.cornerRadius = 10
        hardwareDiagnosis.layer.cornerRadius = 10
    }
    
    
    @IBAction func callMeBack(_ sender: UIButton) {
        let mainStoryboard = UIStoryboard(name: "CallMeBack", bundle: nil)
        let callMeBackVC = mainStoryboard.instantiateViewController(withIdentifier: "CallMeBackViewController") as? CallMeBackViewController
        self.present(callMeBackVC!, animated: true)
    }
    
    
    @IBAction func contactUsClicked(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            
            var screenHeight =  UIScreen.main.bounds.height / 2
            print(screenHeight)
            
        self.heightConstraint.constant = 300
            self.view.layoutIfNeeded()
        }) {(status) in
            
        }
        
    }
    
    
    
    @IBAction func closeButton(_ sender: UIButton) {
        
        self.dismiss(animated: true)
    }
}
