//
//  CustomerCopyViewController.swift
//  IceCream
//
//  Created by Deepika on 26/03/25.
//

import UIKit
import Foundation
import IposgoSDK
class CustomerCopyViewController: UIViewController {
    
    @IBOutlet weak var txnTypeLbl: UILabel!
    
    
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var transNoLbl: UILabel!
    @IBOutlet weak var txnStatusLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var cardImg: UIImageView!
    @IBOutlet weak var txnAmtLbl: UILabel!
    @IBOutlet weak var txnStatusImg: UIImageView!
    var responseDict: [String:Any]?
    @IBOutlet weak var cardNumberLbl: UILabel!
    var isFromCallBack: Bool?
    @IBOutlet weak var textFld: UITextView!
    @IBOutlet weak var errorView: UIView!
    var payType:PaymentMethod?
    var errorMsg: String?
    var isFromBatchSettlementInApp: Bool?
    var readerInstance = IposgoReader()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    var isFromVoid = false
    var entity : TxDetailEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        roundView.layer.cornerRadius = 5
        roundView.clipsToBounds = true
        roundView.layer.borderColor = UIColor.systemPurple.cgColor
        roundView.layer.borderWidth = 1
        textFld.isUserInteractionEnabled = false
        
        
        savingLastTXNInUD()
        
        let Spin_Response = responseDict?[ParamKey.Spin_Response.rawValue] as? [String:Any] ?? [:]
        let responseCode = Spin_Response[ParamKey.HostResponseCode.rawValue] as? String ?? responseDict?[ParamKey.HostResponseCode.rawValue] as? String
      
        let extadata = Spin_Response[ParamKey.ExtData.rawValue] as? [String:Any] ?? [:]
        let totalAmt = extadata[ParamKey.TotalAmt.rawValue] as? String ?? ""
        print(">>>extadata",extadata)
        
        let HostResponseMessage = Spin_Response[ParamKey.HostResponseMessage.rawValue] as? String
        let last4Digits = extadata[ParamKey.AcntLast4.rawValue] as? String ?? ""
        let cardType = extadata[ParamKey.CardType.rawValue] as? String ?? ""
        let TraceNum = extadata[ParamKey.TraceNum.rawValue] as? String ?? ""
        let Message = Spin_Response[ParamKey.message.rawValue] as? String ?? ""
        let txType = extadata[ParamKey.txnLabel.rawValue] as? String ?? ""
        
       
        txnTypeLbl.text = nullStringToEmpty(string: txType).uppercased()
        
        txnAmtLbl.text = isFromVoid ? "$" + (entity?.amount ?? "") : totalAmt
       
        cardNumberLbl.text = "XXXX \(last4Digits)"
        
        if responseCode != "00"{
            if payType == .KeyIn  ||  payType == .QR{
                if Message == "APPROVED" {
                    txnStatusLbl.textColor = .green
                    // Load the color from the asset catalog by its name
                    if let myColor = UIColor(named: "successgreen") {
                        txnStatusLbl.textColor = myColor  // Set the background color to the loaded color
                    } else {
                        txnStatusLbl.textColor = .green
                    }
                    txnStatusLbl.text = Constant.approval.rawValue
                    descriptionLbl.text = Constant.paymentSuccessMessage.rawValue
                    if let gifImage = UIImage.gifImageWithName(name: "approval") {
                        txnStatusImg.image = gifImage
                    }
                    
                }else{
                    declineRedMsg()
                }
                
            }else{
                declineRedMsg()
            }
            
            func declineRedMsg() {
                // Load the color from the asset catalog by its name
                if let myColor = UIColor(named: "declineRed") {
                    txnStatusLbl.textColor = myColor  // Set the background color to the loaded color
                } else {
                    txnStatusLbl.textColor = .red
                }
                
                txnStatusLbl.text = Constant.DECLINE.rawValue
                descriptionLbl.text = Constant.paymentDeclineMessage.rawValue + "\(HostResponseMessage ?? "")"
                
                if let gifImage = UIImage.gifImageWithName(name: "error") {
                    txnStatusImg.image = gifImage
                }
            }
            
        } else {
            txnStatusLbl.textColor = .green
            
            
            // Load the color from the asset catalog by its name
            if let myColor = UIColor(named: "successgreen") {
                txnStatusLbl.textColor = myColor  // Set the background color to the loaded color
            } else {
                txnStatusLbl.textColor = .green
            }
            txnStatusLbl.text = Constant.approval.rawValue
            descriptionLbl.text = Constant.paymentSuccessMessage.rawValue
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
            cardImg.image = UIImage(named: "wallet")
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
        
        redirectToHome()
    }
    
    func redirectToHome() {
        
        if isFromCallBack == true {
            guard let VC = self.storyboard?.instantiateViewController(identifier: "CollectionListVC") as? CollectionListVC else { return }
            titlename = Constant.Sale.rawValue
            VC.tranType = .SALE
            txnType = .SALE
            dlTxnType = .SALE
            self.navigationController?.pushViewController(VC, animated: true)
        } else {
            if let viewControllers = navigationController?.viewControllers {
                for vc in viewControllers {
                    if let targetVC = vc as? CollectionListVC {
                        titlename = Constant.Sale.rawValue
                        targetVC.tranType = .SALE
                        txnType = .SALE
                        dlTxnType = .SALE
                        navigationController?.popToViewController(targetVC, animated: true)
                        break
                    }
                }
            }
        }
    }
}


extension CustomerCopyViewController {
    
    func savingLastTXNInUD() { // For Deep Linking Version
        
        let deepLinkKey = UserDefaults.Keys.deepLinkingVersion.rawValue
        
        let currentValue = UserDefaults.standard.string(forKey: deepLinkKey)
        
        if isFromCallBack == true {
            errorView.isHidden = errorMsg != "" ? false : true
            textFld.text = nullStringToEmpty(string: errorMsg)
        } else if isFromBatchSettlementInApp == true {
            errorView.isHidden = false
            addingLoaderOnView()
            readerInstance.delegate = self
            startLoading()
            readerInstance.startBatchSettlement()
        } else {
            errorView.isHidden = true
        }
        if currentValue == "1" {
            
            
            let Spin_Response = responseDict?[ParamKey.Spin_Response.rawValue] as? [String:Any] ?? [:]
            let responseCode = Spin_Response[ParamKey.HostResponseCode.rawValue] as? String
            let extadata = Spin_Response[ParamKey.ExtData.rawValue] as? [String:Any] ?? [:]
            let totalAmt = extadata[ParamKey.TotalAmt.rawValue] as? String ?? ""
            let last4Digits = extadata[ParamKey.AcntLast4.rawValue] as? String ?? ""
            let cardType = extadata[ParamKey.cardType.rawValue] as? String ?? ""
            let TraceNum = extadata[ParamKey.TraceNum.rawValue] as? String ?? ""
            let dateTime = extadata[ParamKey.DateTime.rawValue] as? String ?? ""
            let rrn = extadata[ParamKey.RRN.rawValue] as? String ?? ""
            
            if responseCode == "00" {
                
                var transType: String?
                
                switch txnType {
                    
                case .SALE:
                    transType = Constant.Sale.rawValue
                case .REFUND:
                    transType = Constant.Refund.rawValue
                case .PRE_AUTH:
                    transType = Constant.PreAuth.rawValue
                case .TICKET:
                    transType = Constant.Ticket.rawValue
                default:
                    transType = Constant.Sale.rawValue
                    
                }
                
                let transactionData: [String: Any] = [
                    ParamKey.txName.rawValue: transType ?? "",
                    ParamKey.txnDateTime.rawValue: dateTime,
                    ParamKey.sumAmount.rawValue: totalAmt.replacingOccurrences(of: "$", with: ""),
                    ParamKey.cardMaskPan.rawValue: last4Digits,
                    ParamKey.cardType.rawValue: cardType,
                    ParamKey.rrnCode.rawValue: rrn,
                    ParamKey.traceNo.rawValue: TraceNum,
                    ParamKey.invoice.rawValue: TraceNum
                ]
                
                UserDefaults.standard.set(transactionData, forKey: UserDefaults.Keys.lastTransaction.rawValue)
            }
            
        }
    }
    
    
}

//MARK: ITap Delegates
@available(iOS 15.4, *)
extension CustomerCopyViewController: IposgoDelegate {
    
    func addingLoaderOnView() {
        // Set up the activity indicator
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor.black
        activityIndicator.hidesWhenStopped = true
        
        // Add the activity indicator to the view
        self.view.addSubview(activityIndicator)
    }
    
    // Call this function to start the loader
    func startLoading() {
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false // Optionally disable user interaction while loading
    }
    
    // Call this function to stop the loader
    func stopLoading() {
        activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true // Re-enable user interaction after loading
    }
    func didReceiveError(error: String?, code: Int?)  {
        
        print(">>>>Invoke App Error:",error as Any)
        DispatchQueue.main.async { [self] in
            stopLoading()
        }
        switch nullStringToEmpty(string: error) {
            
        case nullStringToEmpty(string: Constant.cardCancelled.rawValue):
            return
            
        default:
            DispatchQueue.main.async { [self] in
                self.textFld.text = nullStringToEmpty(string: error)
                let alert = UIAlertController(title: Constant.Alert.rawValue, message: nullStringToEmpty(string: error), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: Constant.ok.rawValue, style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.readerInstance.cleanup(delegate: self)
            }
            return
        }
        
    }
    
    func didReceiveSuccessData(message: String?, responseDict: [String : Any]?) {
        
        
        print(">>> Invoke App Success:  \(String(describing: message))")
        print(">>>RESponse",responseDict as Any)
        DispatchQueue.main.async { [self] in
           
            print("data....responseDict:\(String(describing: responseDict))")
            if responseDict != nil || responseDict?.count ?? 0 > 0 {
                stopLoading()
                self.textFld.text = "\(String(describing: responseDict))"
            } else {
                self.textFld.text = nullStringToEmpty(string: message)
                
            }
            
        }
    }
   
}
