//
//  CallMeBackViewController.swift
//  itop
//
//  Created by APPLE on 20/11/22.
//

import UIKit

class CallMeBackViewController: UIViewController {
    
    
    @IBOutlet var helpSupportBtn: UIButton!
    @IBOutlet var demoRequired: UIButton!
    @IBOutlet var networkSimIssue: UIButton!
    @IBOutlet var cardIssue: UIButton!
    @IBOutlet var settlementIssue: UIButton!
    
    @IBOutlet weak var frontButton: UIButton!
    
    
    @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        dropShadow()
    }
    

    func dropShadow() {
        helpSupportBtn.addShadowToButton(cornerRadius: 20)
        demoRequired.addShadowToButton(cornerRadius: 20)
        networkSimIssue.addShadowToButton(cornerRadius: 20)
        cardIssue.addShadowToButton(cornerRadius: 20)
        settlementIssue.addShadowToButton(cornerRadius: 20)
    }
    
    
    @IBAction func helpSupport(_ sender: UIButton) {
        
        sender.tag = 0
    
        let mainStoryboard = UIStoryboard(name: "HelpSupportViewController", bundle: nil)
        let helpVC = mainStoryboard.instantiateViewController(withIdentifier: "HelpSupportViewController") as? HelpSupportViewController
        //helpVC?.titleTag.tag = sender.tag
        self.present(helpVC! , animated: true)
        
    }
    
    
    
    @IBAction func demoRequired(_ sender: UIButton) {
        var demoRequired = "Demo Required"
        
        sender.tag = 1
        
        let mainStoryboard = UIStoryboard(name: "HelpSupportViewController", bundle: nil)
        let callMeBackVC = mainStoryboard.instantiateViewController(withIdentifier: "HelpSupportViewController") as? HelpSupportViewController
        //callMeBackVC?.titleTag.tag = sender.tag
        self.present(callMeBackVC!, animated: true)
    }
    
    
    @IBAction func networkIssue(_ sender: UIButton) {
        
        var networkIssue = "Network/Sim Issue"
        
        sender.tag = 2
        
        let mainStoryboard = UIStoryboard(name: "HelpSupportViewController", bundle: nil)
        let callMeBackVC = mainStoryboard.instantiateViewController(withIdentifier: "HelpSupportViewController") as? HelpSupportViewController
       // callMeBackVC?.titleTag.tag = sender.tag
        self.present(callMeBackVC!, animated: true)
    }
    
    
    @IBAction func cardIssue(_ sender: UIButton) {
        
        var cardIssue = "Card Issue"
        
        sender.tag  = 3
        
        let mainStoryboard = UIStoryboard(name: "HelpSupportViewController", bundle: nil)
        let callMeBackVC = mainStoryboard.instantiateViewController(withIdentifier: "HelpSupportViewController") as? HelpSupportViewController
      //  callMeBackVC?.titleTag.tag = sender.tag
        self.present(callMeBackVC!, animated: true)
    }
    
    
    @IBAction func settlementIssue(_ sender: UIButton) {
        
        var settlementIssue = "Settlement Issue"
        
        sender.tag = 4
        
        let mainStoryboard = UIStoryboard(name: "HelpSupportViewController", bundle: nil)
        let callMeBackVC = mainStoryboard.instantiateViewController(withIdentifier: "HelpSupportViewController") as? HelpSupportViewController
      //  callMeBackVC?.titleTag.tag = sender.tag
        self.present(callMeBackVC!, animated: true)
    }
    
  
    @IBAction func backPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true)
    }
    
}
