//
//  CustomerCopyViewController.swift
//  itop
//
//  Created by meganathan on 25/07/22.
//


import UIKit

class CustomerCopyViewController: UIViewController{

    @IBOutlet weak var btnccsms: UIButton!
    @IBOutlet weak var btnccemail: UIButton!
    @IBOutlet weak var btnccprint: UIButton!
    @IBOutlet weak var btnccnoreceipt: UIButton!
    @IBOutlet weak var lblAmountEntry: UILabel!
    var iAmount:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnccsms.layer.cornerRadius = 10
        btnccemail.layer.cornerRadius = 10
        btnccprint.layer.cornerRadius = 10
        btnccnoreceipt.layer.cornerRadius = 10
        lblAmountEntry.text = "$\(iAmount)"
    }
    
    @IBAction func btnccsmsAction(_ sender: Any) {
        
        
        let mainStoryboard = UIStoryboard(name: "SMSReceiptViewController", bundle: nil)
         let smsViewController = mainStoryboard.instantiateViewController(withIdentifier: "SMSReceiptViewController") as! SMSReceiptViewController
        self.present(smsViewController, animated: true)
        
  
        
        //        self.showMessageAlert(title: "Tap On Phone", message: "SMS send to the Customer Mobile", showRetry: true, retryTitle: "Cancel", showCancel: false, onRetry: {
      // self.view.window!.rootViewController?.viewDidLoad()
     //            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
      //        }, onCancel: nil)
    }
    
    @IBAction func btnccemailAction(_ sender: Any) {
        self.showMessageAlert(title: "Tap On Phone", message: "Email send to the Customer", showRetry: true, retryTitle: "Cancel", showCancel: false, onRetry: {
            self.view.window!.rootViewController?.viewDidLoad()
            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil) }, onCancel: nil)
    }
    
    @IBAction func btnccprintAction(_ sender: Any) {
        self.showMessageAlert(title: "Tap On Phone", message: "Printing Reciept", showRetry: true, retryTitle: "Cancel", showCancel: false, onRetry: {
            self.view.window!.rootViewController?.viewDidLoad()
            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil) }, onCancel: nil)
    }
    
    @IBAction func btnccnoreceipt(_ sender: Any) {
        self.showMessageAlert(title: "Tap On Phone", message: "No Reciept to be printed for the Customer", showRetry: true, retryTitle: "Cancel", showCancel: false, onRetry: {
            self.view.window!.rootViewController?.viewDidLoad()
            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil) }, onCancel: nil)
    }
}
