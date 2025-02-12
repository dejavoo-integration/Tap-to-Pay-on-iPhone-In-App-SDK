//
//  RegistrationViewController.swift
//  IceCream
//
//  Created by Giri on 2/10/25.
//

import UIKit
import IposgoSDK

class RegistrationViewController: BaseViewController {
    @IBOutlet weak var titlelb:UILabel!
    @IBOutlet weak var txt: UITextView!
    @IBOutlet weak var tpnTxtFld: UITextField!
    let readerInstance = IposgoReader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tpnTxtFld.keyboardType = .numberPad
        tpnTxtFld.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func appDidBecomeActive() {
          print("App became active")
        readerInstance.delegate = self
        readerInstance.checkDeviceConfiguration()
      }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
      
    
    
    override func viewWillAppear(_ animated: Bool) {
        titlelb.text = titlename
    }
    
    
    @IBAction func registerDeviceAC(_ sender: UIButton) {
        self.tpnTxtFld.endEditing(true)
        
        guard nullStringToEmpty(string: tpnTxtFld.text) != "" else {
            let alert = UIAlertController(title: "Alert", message: "Enter TPN", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        LoaDer.showOverlay(view: self.view)
        let payload = RegisterData(tpn: "544425158338", merchantCode: "393670256150")
        readerInstance.delegate = self
        Task {
            
            readerInstance.downloadParameter(param: payload)
        }
        
    }

}

//MARK: ITap Delegates
@available(iOS 15.4, *)
extension RegistrationViewController: IposgoDelegate {

    func didReceiveError(error: String?, code: Int?)  {
 
        print(">>>>Invoke App Error:",error as Any)
        DispatchQueue.main.async { [self] in
            LoaDer.hideOverlayView()
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
        print(">>>RESponse",responseDict)
        
        
        DispatchQueue.main.async { [self] in
            
            
            LoaDer.hideOverlayView()
            
            if nullStringToEmpty(string: message) == "Device is ready for tap to pay now" {
                UserDefaults.standard.setValue(true, forKey: "termsConditionsAccepted")
                UserDefaults.standard.setValue(true, forKey: "isRegistered")
                //Navigation
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                titlename = "Sale"
                let readerVC = mainStoryboard.instantiateViewController(withIdentifier: "CollectionListVC") as! CollectionListVC
                readerVC.tranType = .SALE
                navigationController?.pushViewController(readerVC, animated: true)
                
            } else {
                self.txt.text = nullStringToEmpty(string: message)
            }
            
            
        }
    }
    
    
}


//MARK: - UITextFieldDelegate
@available(iOS 15.4, *)
extension RegistrationViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
         return true
    }
    // UITextFieldDelegate method to enforce 12-digit limit
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // Get the current text in the text field
            let currentText = textField.text ?? ""
            
            // Create the updated text after the change
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            // Ensure the updated text is numeric and no more than 12 characters long
            let isNumeric = updatedText.allSatisfy { $0.isNumber }
            let isWithinLimit = updatedText.count <= 12

            return isNumeric && isWithinLimit
        }
}

@available(iOS 15.4, *)
extension RegistrationViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
}

