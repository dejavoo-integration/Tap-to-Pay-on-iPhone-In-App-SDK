//
//  ViewController.swift
//  itop
//
//  Created by meganathan on 20/07/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btnClick: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AmountEntryViewController", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AmountEntryViewController")
        self.present(controller, animated: true, completion: nil)
    }
    
}

