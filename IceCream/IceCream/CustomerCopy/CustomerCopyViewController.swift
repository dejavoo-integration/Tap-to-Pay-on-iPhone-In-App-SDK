//
//  CustomerCopyViewController.swift
//  IceCream
//
//  Created by Deepika on 26/03/25.
//

import UIKit
import Foundation
class CustomerCopyViewController: UIViewController {

  
    @IBOutlet weak var roundView: UIView!
    
    @IBOutlet weak var transNoLbl: UILabel!
    @IBOutlet weak var txnStatusLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var cardImg: UIImageView!
    @IBOutlet weak var txnAmtLbl: UILabel!
    @IBOutlet weak var txnStatusImg: UIImageView!
    var responseDict: [String:Any]?
    @IBOutlet weak var cardNumberLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        roundView.layer.cornerRadius = 5
        roundView.clipsToBounds = true
        roundView.layer.borderColor = UIColor.systemPurple.cgColor
        roundView.layer.borderWidth = 1
        
            let responseCode = responseDict?["HostResponseCode"] as? String
            let HostResponseMessage = responseDict?["HostResponseMessage"] as? String ?? ""
            let Spin_Response = responseDict?["Spin_Response"] as? [String:Any] ?? [:]
        _ = Spin_Response["Message"] as? String ?? ""
            let extadata = Spin_Response["ExtData"] as? [String:Any] ?? [:]
            let totalAmt = extadata["TotalAmt"] as? String ?? ""
            let last4Digits = extadata["AcntLast4"] as? String ?? ""
            let cardType = extadata["CardType"] as? String ?? ""
            let TraceNum = extadata["TraceNum"] as? String ?? ""
            
            print(totalAmt,last4Digits,cardType,TraceNum)
        
        txnAmtLbl.text =  totalAmt
        cardNumberLbl.text = "XXXX \(last4Digits)"
        
        if responseCode != "00"{
            
            // Load the color from the asset catalog by its name
            if let myColor = UIColor(named: "declineRed") {
                txnStatusLbl.textColor = myColor  // Set the background color to the loaded color
            } else {
                txnStatusLbl.textColor = .red
            }
            
            txnStatusLbl.text = "DECLINE"
            descriptionLbl.text = "Your payment was decline with\n" + "\(HostResponseMessage)"
            
            if let gifImage = UIImage.gifImageWithName(name: "error") {
                txnStatusImg.image = gifImage
            }

        } else {
            txnStatusLbl.textColor = .green
            
            
            // Load the color from the asset catalog by its name
            if let myColor = UIColor(named: "successgreen") {
                txnStatusLbl.textColor = myColor  // Set the background color to the loaded color
            } else {
                txnStatusLbl.textColor = .green
            }
            txnStatusLbl.text = "APPROVED"
            descriptionLbl.text = "Your payment was successfully processed. Thank you!"
            if let gifImage = UIImage.gifImageWithName(name: "approval") {
                txnStatusImg.image = gifImage
            }
               
        }
        
        //Card Image
        if cardType.lowercased() == "visa"{
            cardImg.image = UIImage(named: "visa")
        }else if cardType.uppercased() == "MASTERCARD"{
            cardImg.image = UIImage(named: "mastercard")
        }else if cardType.uppercased() == "AMEX"{
            
            cardImg.image = UIImage(named: "AMEX")
        }  else if cardType.lowercased() == "discover"{
            
            cardImg.image = UIImage(named: "DISCOVER")
        }  else if cardType.lowercased() == "wallet" {
            cardNumberLbl.text = "Wallet"
            transNoLbl.text = "#" +  TraceNum
            cardImg.image = UIImage(named: "wallet")
           
        } else{
            cardImg.image = UIImage(named: "visa")
        }
        
        //Card TransNum
        
        let invoiceChar = TraceNum
        switch invoiceChar.count {
        case 1:
            transNoLbl.text = "#00000" + invoiceChar
        case 2:
            transNoLbl.text = "#0000" + invoiceChar
        case 3:
            transNoLbl.text = "#000" + invoiceChar
        case 4:
            transNoLbl.text = "#00" + invoiceChar
        case 5:
            transNoLbl.text = "#0" + invoiceChar
        case 6:
            transNoLbl.text = "#" + invoiceChar
        default:
            break
        }
        
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        
        if let viewControllers = navigationController?.viewControllers {
            for vc in viewControllers {
                if let targetVC = vc as? CollectionListVC {
                    titlename = "Sale"
                    targetVC.tranType = .SALE
                    txnType = .SALE
                    navigationController?.popToViewController(targetVC, animated: true)
                    break
                }
            }
        }
    }
}
