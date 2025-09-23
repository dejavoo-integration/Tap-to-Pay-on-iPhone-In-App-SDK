//
//  TicketViewController.swift
//  IceCream
//
//  Created by Giri on 2/6/25.
//

import UIKit
import IposgoSDK
import DeepLinking


class TicketViewController: BaseViewController {
    
    @IBOutlet weak var sendLink: UIButton!
    @IBOutlet weak var feeTxtFld: UITextField!
    @IBOutlet weak var voidTicketBut: UIButton!
    var entity: TxDetailEntity?
    @IBOutlet weak var titlelb:UILabel!
    var tranType : IposgoSDK.TransType?
    @IBOutlet weak var rrnTxtFld: UITextField!
    @IBOutlet weak var tip: UITextField!
    @IBOutlet weak var amtTxtFld: UITextField!
    let readerInstance = IposgoReader()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    var saleAmt:String?
    @IBOutlet weak var key_inPaybut: UIButton!
    @IBOutlet weak var qrPaybut: UIButton!
    var dlReaderInstance = Wrapper()
    var payType:PaymentMethod?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amtTxtFld.delegate = self
        tip.delegate = self
        feeTxtFld.delegate = self
        
        amtTxtFld.keyboardType = .numberPad
        tip.keyboardType = .numberPad
        feeTxtFld.keyboardType = .numberPad
        
        // Set up the activity indicator
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor.black
        activityIndicator.hidesWhenStopped = true
        
        // Add the activity indicator to the view
        self.view.addSubview(activityIndicator)
        
        
    }
    func sendLinkEnable() -> Bool {
        
        let sdkBundleId = "com.denovo.ttpsdk"
        let customDefaults = UserDefaults(suiteName: sdkBundleId)
         let txnTypeEntity =  customDefaults?.value(forKey: "sltx_type") as? [String] ?? [""]
        
        if txnTypeEntity.contains("9") {
            return true
        }else{
            return false
        }
       
    }
    
    @IBAction func goBackVC(_ sender: UIButton) {
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        titlelb.text = titlename
        tranType = txnType
         
        switch tranType {
            
        case .TICKET:

            amtTxtFld.text = "$" + (entity?.amount ?? "")
            
            
        default:
            
            amtTxtFld.text = "$" + (saleAmt ?? "")
          
        }
       
        
        
        
        let deepLinkKey = UserDefaults.Keys.deepLinkingVersion.rawValue

        let currentValue = UserDefaults.standard.string(forKey: deepLinkKey)

        switch currentValue { //Deep Linking SDK
            
        case "1":
            
            key_inPaybut.isHidden = true
            qrPaybut.isHidden = true
            sendLink.isHidden = true
            
            
            tip.isHidden = readerInstance.TipConfiguration() == true ? false : true
            feeTxtFld.isHidden = true
            switch tranType {
                
            case .REFUND,.PRE_AUTH:
                
                tip.isHidden = true
                feeTxtFld.isHidden = true
                
            default:
                tip.isHidden = false
                feeTxtFld.isHidden = false
            }
            
            
        
        default:
            //To check the Tip is Enable or not in Portal Configurations
            tip.isHidden = readerInstance.TipConfiguration() == true ? false : true
            feeTxtFld.isHidden = true
            
            switch tranType {
                
            case .PRE_AUTH,.REFUND:
                sendLink.isHidden = true
                qrPaybut.isHidden = true
                key_inPaybut.isHidden = false
                
            case .SALE:
                qrPaybut.isHidden = false
                key_inPaybut.isHidden = false
                sendLink.isHidden = false
            default:
                sendLink.isHidden = true
                qrPaybut.isHidden = true
                key_inPaybut.isHidden = true
               
            }
            
            
        }
        if sendLinkEnable() == false{
            sendLink.isHidden = true
        }
            
    }
    
    @IBAction func sendlinkAction(_ sender: Any) {
            goSendLinkVc()
    }
    func goSendLinkVc() {
        guard let VC = self.storyboard?.instantiateViewController(identifier: "SendLinkViewController") as? SendLinkViewController else {return}
        VC.amount = amtTxtFld.text ?? ""
        VC.tipAmount = tip.text ?? ""
        navigationController?.pushViewController(VC, animated: true)
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
    
    @IBAction func startTxn(_ sender: UIButton) {
        self.view.endEditing(true)
        
        
        let deepLinkKey = UserDefaults.Keys.deepLinkingVersion.rawValue

        let currentValue = UserDefaults.standard.string(forKey: deepLinkKey)

        switch currentValue { //Deep Linking SDK
            
        case "1":
            
            let tipScreen = UserDefaults.standard.string(forKey: UserDefaults.Keys.isEnableShowTipScreen.rawValue) == "1" ? true : false
            let breakupScreen = UserDefaults.standard.string(forKey: UserDefaults.Keys.isEnableShowBreakupScreen.rawValue) == "1" ? true : false
            let approvalScreen = UserDefaults.standard.string(forKey: UserDefaults.Keys.isEnableShowApprovalScreen.rawValue) == "1" ? true : false
            
            switch dlTxnType {
                
            case .REFUND,.PREAUTH:
                
                let payload = DLTxnData(amount: nullStringToEmpty(string: amtTxtFld.text), feeAmount: nullStringToEmpty(string: feeTxtFld.text), tipAmount: nullStringToEmpty(string: tip.text), currencyCode: .usd, tranType: dlTxnType,showApprovalScreen: approvalScreen)
                print(">>>payload",payload)
              
                dlReaderInstance.startTransaction(params: payload,delegate: self)
                
            case .TICKET:
                
                let payload = DLTicketTxnData(amount: nullStringToEmpty(string:  amtTxtFld.text), feeAmount: nullStringToEmpty(string: feeTxtFld.text), tipAmount: nullStringToEmpty(string: tip.text), currencyCode: .usd, tranType: .TICKET, rrn: entity?.rrnCode ?? "", showTipScreen: tipScreen, showBreakUpScreen: breakupScreen, showApprovalScreen: approvalScreen)
                print(">>>payload",payload)
              
                dlReaderInstance.startTicket(params: payload,delegate: self)
                
            default:
            
                let payload = DLTxnData(amount: nullStringToEmpty(string: amtTxtFld.text), feeAmount: nullStringToEmpty(string: feeTxtFld.text), tipAmount: nullStringToEmpty(string: tip.text), currencyCode: .usd, tranType: .SALE, showTipScreen: tipScreen, showBreakUpScreen: breakupScreen, showApprovalScreen: approvalScreen)
                print(">>>payload",payload)
              
                dlReaderInstance.startTransaction(params: payload,delegate: self)
            }
        
        default:
            
            switch tranType {
                
            case .TICKET:
                let payload = TicketTxnData(amount: amtTxtFld.text ?? "", tipAmount: tip.text,currencyCode: .usd, tranType: .TICKET, rrn: entity?.rrnCode ?? "")
                print(">>>payload",payload)
                readerInstance.delegate = self
                startLoading()
                readerInstance.startTicket(param: payload)
                
            default:
               
                
                let payload = TxnData(amount: amtTxtFld.text ?? "", tipAmount: tip.text ?? "", currencyCode: .usd, tranType: tranType ?? .SALE)
                print(">>>payload",payload)
                startLoading()
                readerInstance.delegate = self
                readerInstance.startTransaction(param: payload)
            }
            
        }
       
    }
    
}




//MARK: - UITextFieldDelegate
@available(iOS 15.4, *)
extension TicketViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if  textField == rrnTxtFld {
            
            return true
        }
        
        // Allow backspace
        if string.isEmpty {
            return true
        }
        
        // Check if the new character is numeric
        let isNumeric = "0123456789".contains(string)
        
        // If the character is not numeric, return false to prevent it from being entered
        if !isNumeric {
            return false
        }
        
        // Check the existing text in the text field
        guard let text = textField.text else {
            return true
        }
        
        // Get the full new text
        let newText = (text as NSString).replacingCharacters(in: range, with: string)
        
        // Format the text to include the decimal point
        if let formattedText = formatAmountText(newText) {
            textField.text =  formattedText
        }
        
        
        // Return false to prevent the default text change
        return false
    }
    
    private func formatAmountText(_ text: String) -> String? {
        // Remove any non-numeric characters
        let cleanedText = text.components(separatedBy: CharacterSet(charactersIn: "0123456789").inverted).joined()
        
        // Check if the cleaned text is not empty
        guard !cleanedText.isEmpty else {
            return nil
        }
        
        // Convert to double
        guard let amount = Double(cleanedText) else {
            return nil
        }
        
        // Format the amount with two decimal places
        let formattedAmount = String(format: "$%.2f", amount / 100)
        
        return formattedAmount
    }
}

@available(iOS 15.4, *)
extension TicketViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
}

//MARK: ITap Delegates
@available(iOS 15.4, *)
extension TicketViewController: IposgoDelegate {
    
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
                guard let VC = self.storyboard?.instantiateViewController(identifier: "CustomerCopyViewController") as? CustomerCopyViewController else { return }
                VC.responseDict = responseDict
                VC.payType = payType
                navigationController?.pushViewController(VC, animated: true)
                
            } else {
                print("message:\(nullStringToEmpty(string: message))")
                
            }
        }
    }
    
    func clearTxtFld() {
        tip.text = ""
        rrnTxtFld.text = ""
        amtTxtFld.text = ""
    }
}




