//
//  ReprintViewController.swift
//  itop
//
//  Created by APPLE on 20/11/22.
//

import UIKit

class ReprintViewController: UIViewController {
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       cornerRadius()
    }
    
    
    func cornerRadius() {
        backButton.layer.cornerRadius = 10
        forwardBtn.layer.cornerRadius = 10
    }
    
    
    
    @IBAction func closeButtonClicked(_ sender: UIButton) {
        
        self.dismiss(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
