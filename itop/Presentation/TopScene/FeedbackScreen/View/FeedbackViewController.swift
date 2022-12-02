//
//  FeedbackViewController.swift
//  itop
//
//  Created by APPLE on 26/10/22.
//

import UIKit

class FeedbackViewController: UIViewController {
    
    @IBOutlet weak var feedBackView: UIView!
    
    @IBOutlet weak var thankyouLbl: UILabel!
    @IBOutlet weak var okBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cornerRadius()
        
    }
    
    
    func cornerRadius() {
        okBtn.layer.cornerRadius = 10
        feedBackView.layer.cornerRadius = 20
        
        thankyouLbl.layer.cornerRadius = 10
        
        thankyouLbl.layer.masksToBounds = true
        //let hexaValue = UIColor(hexString: "#3E97A8")

        
        feedBackView.layer.borderColor = UIColor(red: 62/255, green: 151/255, blue: 168/255, alpha: 1).cgColor
        feedBackView.layer.borderWidth = 2.0
    }
    

}
