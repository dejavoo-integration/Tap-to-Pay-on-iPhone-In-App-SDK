//
//  RegistrationViewController.swift
//  IceCream
//
//  Created by Giri on 2/10/25.
//

import UIKit
import IposgoSDK
import DeepLinking

protocol RegisterDeepLinking {
    
    func didReceiveDeepLink(isFromDlFlow:  Bool?)
}

extension RegistrationViewController : RegisterDeepLinking {
    func didReceiveDeepLink(isFromDlFlow: Bool?) {
        self.isFromDLFlow = isFromDlFlow ?? true
    }
}

class RegistrationViewController: BaseViewController {
    
    
   
    @IBOutlet weak var titlelb:UILabel!
    @IBOutlet weak var txt: UITextView!
    @IBOutlet weak var tpnTxtFld: UITextField!
    let readerInstance = IposgoReader()
    @IBOutlet weak var merchantCode: UITextField!
    let dLReaderInstance = Wrapper()
    var isFromDLFlow = false
    var callBackMessage: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        merchantCode.keyboardType = .numberPad
        tpnTxtFld.keyboardType = .numberPad
        
        tpnTxtFld.delegate = self
        merchantCode.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        
//        tpnTxtFld.text = "794525543578"
//        merchantCode.text = "469849821415"
        
      
        
     
    }
    
    @objc func appDidBecomeActive() {
         
        if UserDefaults.standard.string(forKey: UserDefaults.Keys.inAppSDKVersion.rawValue) == "1" {
            readerInstance.delegate = self
            readerInstance.checkDeviceConfiguration()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
      

    override func viewWillAppear(_ animated: Bool) {
        titlelb.text = Constant.Registration.rawValue
        
        
        if callBackMessage != "" {
            txt.text = callBackMessage
        }
        if let tpn = UserDefaults.standard.string(forKey: UserDefaults.Keys.tpn.rawValue){
            tpnTxtFld.text = tpn
        }
        if let merchantcode = UserDefaults.standard.string(forKey: UserDefaults.Keys.merchantCode.rawValue){
            merchantCode.text = merchantcode
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
   
    deinit {
        // Remove observers when the view controller is deallocated
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func registerDeviceAC(_ sender: UIButton) {
        
        self.tpnTxtFld.endEditing(true)
        
        guard nullStringToEmpty(string: tpnTxtFld.text) != "" else {
            let alert = UIAlertController(title: Constant.Alert.rawValue, message: Constant.enterTPN.rawValue, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Constant.ok.rawValue, style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard nullStringToEmpty(string: merchantCode.text) != "" else {
            let alert = UIAlertController(title: Constant.Alert.rawValue, message: Constant.merchantCode.rawValue, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Constant.ok.rawValue, style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        LoaDer.showOverlay(view: self.view)
        
            if isFromDLFlow == true {
                
                deeplinkingRegistration()
                
            } else { // InApp SDK
                let payload = RegisterData(tpn:  tpnTxtFld.text ?? "", merchantCode: merchantCode.text ?? "")
                readerInstance.delegate = self
                
                Task {
                    
                    readerInstance.downloadParameter(param: payload)
                }
            }
    }
    
    func deeplinkingRegistration()  {
       
        let payload = DeepLinkingRegisterData(tpn:  tpnTxtFld.text ?? "", merchantCode:  merchantCode.text ?? "")
        dLReaderInstance.downloadParameter(param: payload , delegate: self)
        
    }

}

//MARK: ITap Delegates
@available(iOS 15.4, *)
extension RegistrationViewController: IposgoDelegate {

    func didReceiveError(error: String?, code: Int?)  {
       
        print(">>>>Invoke App Error:",error as Any)
        
        DispatchQueue.main.async {
            LoaDer.hideOverlayView()
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
       
            LoaDer.hideOverlayView()
            
            if nullStringToEmpty(string: message) == UserDefaults.Keys.deviceReadyStatus.rawValue {
                
                UserDefaults.standard.setValue(true, forKey: UserDefaults.Keys.termsConditionsAccepted.rawValue)
                UserDefaults.standard.setValue(true, forKey: UserDefaults.Keys.isRegistered.rawValue)
                
                let inAppKey = UserDefaults.Keys.inAppSDKVersion.rawValue
                let deepLinkKey = UserDefaults.Keys.deepLinkingVersion.rawValue
                let tpn = UserDefaults.Keys.tpn.rawValue
                let merchantcode = UserDefaults.Keys.merchantCode.rawValue
                UserDefaults.standard.set("1", forKey: inAppKey)
                UserDefaults.standard.set("0", forKey: deepLinkKey)
                
                UserDefaults.standard.set(tpnTxtFld.text, forKey: tpn)
                UserDefaults.standard.set(merchantCode.text, forKey: merchantcode)
                
               
                //Navigation
                guard let VC = self.storyboard?.instantiateViewController(identifier: "SDKConfigurationVC") as? SDKConfigurationVC else { return }
                VC.delegate = self
                self.navigationController?.pushViewController(VC, animated: true)
                
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
