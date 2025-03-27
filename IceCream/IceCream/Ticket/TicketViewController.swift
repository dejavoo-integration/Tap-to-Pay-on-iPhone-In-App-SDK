//
//  TicketViewController.swift
//  IceCream
//
//  Created by Giri on 2/6/25.
//

import UIKit
import IposgoSDK



class TicketViewController: BaseViewController {
    
    @IBOutlet weak var voidTicketBut: UIButton!
    
    @IBOutlet weak var titlelb:UILabel!
    var tranType : TransType?
    @IBOutlet weak var rrnTxtFld: UITextField!
    @IBOutlet weak var tip: UITextField!
    @IBOutlet weak var amtTxtFld: UITextField!
    let readerInstance = IposgoReader()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amtTxtFld.delegate = self
        tip.delegate = self
        rrnTxtFld.delegate = self
        
        amtTxtFld.keyboardType = .numberPad
        tip.keyboardType = .numberPad
        rrnTxtFld.keyboardType = .numberPad
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titlelb.text = titlename
        tranType = txnType
        
        // Set up the activity indicator
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor.black
        activityIndicator.hidesWhenStopped = true
        
        // Add the activity indicator to the view
        self.view.addSubview(activityIndicator)
        
        voidTicketBut.setTitle(titlename, for: .normal)
        
        switch tranType {
            
        case .TICKET:
            amtTxtFld.isHidden = false
            tip.isHidden = false
            rrnTxtFld.isHidden = false
            
        default:
            
            amtTxtFld.isHidden = true
            tip.isHidden = true
            rrnTxtFld.isHidden = false
        }
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
        
        readerInstance.delegate = self
        switch tranType {
            
        case .TICKET:
            let payload = TicketTxnData(amount: amtTxtFld.text ?? "", tipAmount: tip.text,currencyCode: .usd, tranType: .TICKET, rrn: rrnTxtFld.text ?? "")
            
            print(">>>payload",payload)
            startLoading()
            readerInstance.startTicket(param: payload)
        default:
            let payload = VoidTxnData(rrn: rrnTxtFld.text ?? "",tranType: .VOID)
            print(">>>payload",payload)
            startLoading()
            readerInstance.startVoid(param: payload)
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
            
        case nullStringToEmpty(string: "Transaction canceled by the merchant/card holder"):
            return
            
        default:
            DispatchQueue.main.async { [self] in
                
                let alert = UIAlertController(title: "Alert", message: nullStringToEmpty(string: error), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
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
            stopLoading()
            print("data....responseDict:\(String(describing: responseDict))")
            if responseDict != nil || responseDict?.count ?? 0 > 0 {
                //                let responseCode = responseDict?["HostResponseCode"] as? String
                //                let HostResponseMessage = responseDict?["HostResponseMessage"] as? String
                //                let Spin_Response = responseDict?["Spin_Response"] as? [String:Any] ?? [:]
                //                let msg = Spin_Response["Message"] as? String ?? ""
                //                let extadata = Spin_Response["ExtData"] as? [String:Any] ?? [:]
                //                let AMT = extadata["TotalAmt"] as? String ?? ""
                //                if responseCode == "00"{ // 00 sucess, not equal to zero is failure response code
                //                    showAlert(title: msg, msg: "The transaction was completed successfully \(AMT)")
                //                    clearTxtFld()
                //                }else{
                //                    showAlert(title: msg, msg: nullStringToEmpty(string: HostResponseMessage))
                //                }
                
                let VC = storyboard?.instantiateViewController(identifier: "CustomerCopyViewController") as! CustomerCopyViewController
                VC.responseDict = responseDict
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
