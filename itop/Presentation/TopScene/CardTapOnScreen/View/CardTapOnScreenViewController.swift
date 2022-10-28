//
//  CardTapOnScreenViewController.swift
//  itop
//
//  Created by meganathan on 25/07/22.
//


import UIKit
import SwiftUI

class CardTapOnScreenViewController: UIViewController{
    
    @IBOutlet weak public var lblAmountEntry: UILabel!
    @IBOutlet weak var imgctCancel: UIImageView!
    @IBOutlet weak var btnctDebt: UIButton!
    @IBOutlet weak var btnctEBT: UIButton!
    @IBOutlet weak var btnctWallet: UIButton!
    @IBOutlet weak var btnctgift: UIButton!
    @IBOutlet weak var btnctEnterCard: UIButton!
    @IBOutlet weak var btnctQRCode: UIButton!
    var iAmount:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnctDebt.layer.cornerRadius = 15
        btnctEBT.layer.cornerRadius = 15
        btnctWallet.layer.cornerRadius = 15
        btnctgift.layer.cornerRadius = 15
        btnctEnterCard.layer.cornerRadius = 15
        btnctQRCode.layer.cornerRadius = 15
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(tapGesture1))
        imgctCancel.addGestureRecognizer(tap1)
        imgctCancel.isUserInteractionEnabled = true
        lblAmountEntry.text = "$\(iAmount)"
    }
    @IBAction func brnDebtAction(_ sender: Any) {
        let CustomerCopyStoryboard = UIStoryboard(name: "CustomerCopyViewController", bundle: nil)
        if let CustomerViewController = CustomerCopyStoryboard.instantiateViewController(withIdentifier: "CustomerCopyViewController") as? CustomerCopyViewController {
            CustomerViewController.iAmount = "\(iAmount)"
            self.present(CustomerViewController, animated: true,completion: nil)
        }
    }
    @IBAction func btnEBTAction(_ sender: Any) {
        let CustomerCopyStoryboard = UIStoryboard(name: "CustomerCopyViewController", bundle: nil)
        if let CustomerViewController = CustomerCopyStoryboard.instantiateViewController(withIdentifier: "CustomerCopyViewController") as? CustomerCopyViewController {
            CustomerViewController.iAmount = "\(iAmount)"
            self.present(CustomerViewController, animated: true,completion: nil)
        }
    }
    @IBAction func btnGiftAction(_ sender: Any) {
        let CustomerCopyStoryboard = UIStoryboard(name: "CustomerCopyViewController", bundle: nil)
        if let CustomerViewController = CustomerCopyStoryboard.instantiateViewController(withIdentifier: "CustomerCopyViewController") as? CustomerCopyViewController {
            CustomerViewController.iAmount = "\(iAmount)"
            self.present(CustomerViewController, animated: true,completion: nil)
        }
    }
    @IBAction func btnWalletAction(_ sender: Any) {
        let CustomerCopyStoryboard = UIStoryboard(name: "CustomerCopyViewController", bundle: nil)
        if let CustomerViewController = CustomerCopyStoryboard.instantiateViewController(withIdentifier: "CustomerCopyViewController") as? CustomerCopyViewController {
            CustomerViewController.iAmount = "\(iAmount)"
            self.present(CustomerViewController, animated: true,completion: nil)
        }
    }
    @IBAction func btnQRCode(_ sender: Any) {
        let CustomerCopyStoryboard = UIStoryboard(name: "CustomerCopyViewController", bundle: nil)
        if let CustomerViewController = CustomerCopyStoryboard.instantiateViewController(withIdentifier: "CustomerCopyViewController") as? CustomerCopyViewController {
            CustomerViewController.iAmount = "\(iAmount)"
            self.present(CustomerViewController, animated: true,completion: nil)
        }
    }
    
    @IBAction func btnEnterCard(_ sender: Any) {
        let CustomerCopyStoryboard = UIStoryboard(name: "CustomerCopyViewController", bundle: nil)
        if let CustomerViewController = CustomerCopyStoryboard.instantiateViewController(withIdentifier: "CustomerCopyViewController") as? CustomerCopyViewController {
            CustomerViewController.iAmount = "\(iAmount)"
            self.present(CustomerViewController, animated: true,completion: nil)
        }
    }
    @objc func tapGesture1() {
        dismiss(animated: true, completion: nil)
    }
}

