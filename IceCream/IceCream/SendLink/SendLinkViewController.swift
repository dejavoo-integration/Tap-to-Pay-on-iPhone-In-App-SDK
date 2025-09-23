//
//  SendLinkViewController.swift
//  IceCream
//
//  Created by Giri on 7/14/25.
//

import UIKit
import IposgoSDK

class SendLinkViewController: UIViewController {
    
    @IBOutlet weak var amountTxt: UITextField!
    @IBOutlet weak var phonenumberTxt: UITextField!
    @IBOutlet weak var EmailTxt: UITextField!
    @IBOutlet weak var referenceTxt: UITextField!
    @IBOutlet weak var expiryTxt: UITextField!
    @IBOutlet weak var descriptionTxt: UITextField!
    @IBOutlet weak var countryTxt: UITextField!
    var tranType : IposgoSDK.TransType?
    let readerInstance = IposgoReader()
    var payType:PaymentMethod?
    var originalY: CGFloat = 0
    var expiryTime = [LinkExpiryCases(title: linkExpiry.OneDay.rawValue, value: LinkExpiry.OneDay),LinkExpiryCases(title: linkExpiry.OneWeek.rawValue, value: LinkExpiry.OneWeek),LinkExpiryCases(title: linkExpiry.OneMonth.rawValue, value: LinkExpiry.OneMonth)]
    let activityIndicator = UIActivityIndicatorView(style: .large)
    var expiry:LinkExpiry?
    let pickerView = UIPickerView()
    let countryPickerView = UIPickerView()
    var coutrycode:String?
    var CountryList = [Country]()
    var amount:String?
    var phoneNo  = ""
    var tipAmount:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        amountTxt.text = amount
        pickerandtoolbar()
        textfieldAnimation()
        // Keyboard notifications
                NotificationCenter.default.addObserver(self,
                    selector: #selector(keyboardWillShow(_:)),
                    name: UIResponder.keyboardWillShowNotification,
                    object: nil)

                NotificationCenter.default.addObserver(self,
                    selector: #selector(keyboardWillHide(_:)),
                    name: UIResponder.keyboardWillHideNotification,
                    object: nil)
            
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
     
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
    
    func pickerandtoolbar(){
        pickerView.delegate = self
        pickerView.dataSource = self
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        expiryTxt.text = nullStringToEmpty(string: expiryTime.first?.title)
        expiry = LinkExpiry.OneDay
        expiryTxt.inputView = pickerView
        
        // Add toolbar with Done button
                let toolbar = UIToolbar()
                toolbar.sizeToFit()
                let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
                toolbar.setItems([doneButton], animated: false)
        expiryTxt.inputAccessoryView = toolbar
        
        countryTxt.inputView = countryPickerView
        countryTxt.delegate = self

                // Add Done button toolbar
                let toolbar1 = UIToolbar()
                toolbar1.sizeToFit()
                let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped1))
                toolbar1.setItems([done], animated: true)
        countryTxt.inputAccessoryView = toolbar1
        CountryList = loadCountriesFromFile() ?? []
        
        if let currentCode = Locale.current.region?.identifier,
           let index = CountryList.firstIndex(where: { $0.code == currentCode }) {
            countryPickerView.selectRow(index, inComponent: 0, animated: false)
            countryTxt.text = "\(CountryList[index].dial_code)"
        }
    }
    
    
    
    func loadCountriesFromFile() -> [Country]? {
        
        guard let url = Bundle.main.url(forResource: "CountryCodes", withExtension: "json") else {
            print("JSON file not found")
            return nil
        }
        
       
        do {
            let data = try Data(contentsOf: url)
            let countries = try JSONDecoder().decode([Country].self, from: data)
            return countries
        } catch {
            print("Failed to decode JSON: \(error)")
            return nil
        }
        
    }
  
    
    
    @objc func doneTapped() {
        expiryTxt.resignFirstResponder()
        }
    
    @objc func doneTapped1() {
        if countryTxt.text == ""{
            countryTxt.text = CountryList.first?.dial_code
        }
       
        countryTxt.resignFirstResponder()
    }
    
    // MARK: - Move view up/down when keyboard shows/hides
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let bottomField = descriptionTxt // the last one most likely to be covered
            let bottomFieldMaxY = bottomField?.convert(bottomField?.bounds ?? CGRect(x: 0, y: 0, width: 0, height: 0), to: self.view).maxY
            let keyboardMinY = keyboardFrame.minY

            if bottomFieldMaxY ?? 0 > keyboardMinY {
                let overlap = (bottomFieldMaxY ?? 0) - keyboardMinY + 20
                self.view.frame.origin.y = originalY - overlap
            }
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = originalY
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @IBAction func sendLinkAc(_ sender: UIButton) {
        
        if nullStringToEmpty(string: phonenumberTxt.text) == "" && nullStringToEmpty(string: EmailTxt.text) == "" {
            let alert = UIAlertController(title: Constant.Alert.rawValue, message: Constant.sendlinkError.rawValue, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Constant.ok.rawValue, style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
         }
         
         if nullStringToEmpty(string: phonenumberTxt.text) != "" {
             
             if !phonenumberTxt.text!.numberValidation {
                 
                 let alert = UIAlertController(title: Constant.Alert.rawValue, message: Constant.invalidNumber.rawValue, preferredStyle: .alert)
                 alert.addAction(UIAlertAction(title: Constant.ok.rawValue, style: .default, handler: nil))
                 self.present(alert, animated: true, completion: nil)
                 return
             }
             
         }
         
         if nullStringToEmpty(string: EmailTxt.text) != "" {
             
             if !EmailTxt.text!.isValidEmail  {
                 let alert = UIAlertController(title: Constant.Alert.rawValue, message: Constant.mailAddress.rawValue, preferredStyle: .alert)
                 alert.addAction(UIAlertAction(title: Constant.ok.rawValue, style: .default, handler: nil))
                 self.present(alert, animated: true, completion: nil)
                 return
             }
         }
        
        phoneNo = (countryTxt.text ?? "" ) + (phonenumberTxt.text ?? "")
        if phonenumberTxt.text?.count ?? 0 > 1 {
            phoneNo = (countryTxt.text ?? "" ) + (phonenumberTxt.text ?? "")
        }else{
            phoneNo = ""
        }
        
        let payload = TxnData(Linkexpiry: .OneMonth, amount: amountTxt.text ?? "", tipAmount: tipAmount, currencyCode: .usd, tranType: tranType ?? .SALE,
                              email: EmailTxt.text ?? "",
                              phoneNo: phoneNo,
                              payType: .SendLink,
                              description: descriptionTxt.text ?? "",
                              referenceNo: referenceTxt.text ?? "")
        sender.isEnabled = false
        startLoading()
        readerInstance.delegate = self
        readerInstance.startTransactionExternalPayment(param: payload, hostVC: self)
    }
    
    @IBAction func goBackVC(_ sender: UIButton) {
        goRootVC()
    }
    
    func goRootVC(){
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

extension SendLinkViewController: UITextFieldDelegate {
    // MARK: - Move to next field on Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == amountTxt {
            phonenumberTxt.becomeFirstResponder()
        } else if textField == phonenumberTxt {
            EmailTxt.becomeFirstResponder()
        } else if textField == EmailTxt {
            expiryTxt.becomeFirstResponder()
        } else if textField == expiryTxt {
            referenceTxt.becomeFirstResponder()
        } else if textField == referenceTxt {
            descriptionTxt.becomeFirstResponder()
        } else {
            textField.resignFirstResponder() // Dismiss keyboard
        }
        return true
    }
}


extension SendLinkViewController : IposgoDelegate {
    
    func didReceiveError(error: String?, code: Int?) {
        DispatchQueue.main.async { [self] in
            stopLoading()
        }
        let refreshAlert = UIAlertController(title: Constant.Alert.rawValue, message: nullStringToEmpty(string: error), preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: Constant.ok.rawValue, style: .default, handler: { (action: UIAlertAction!) in
            self.goRootVC()
        }))
        present(refreshAlert, animated: true, completion: nil)
           
    }
    
    func didReceiveSuccessData(message: String?, responseDict: [String : Any]?) {
        DispatchQueue.main.async { [self] in
            stopLoading()
        }
        if responseDict?["message"] is String {
            let refreshAlert = UIAlertController(title: Constant.Alert.rawValue, message: "The link has been sent successfully", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: Constant.ok.rawValue, style: .default, handler: { (action: UIAlertAction!) in
                self.goRootVC()
            }))
            present(refreshAlert, animated: true, completion: nil)
            
        }
    }
}

extension SendLinkViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == countryPickerView{
            return CountryList.count
        }else{
            return expiryTime.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == countryPickerView{
            return CountryList[row].name
        }else{
            return expiryTime[row].title
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == countryPickerView{
            countryTxt.text = CountryList[row].dial_code
            coutrycode = nullStringToEmpty(string: CountryList[row].code)
        }else{
            expiry = expiryTime[row].value
            return expiryTxt.text = nullStringToEmpty(string: expiryTime[row].title)
        }
    }
   
    
    
    func textfieldAnimation(){
        // Save initial Y position
        originalY = self.view.frame.origin.y
        
        // Set delegates
        amountTxt.delegate = self
        phonenumberTxt.delegate = self
        EmailTxt.delegate = self
        referenceTxt.delegate = self
        expiryTxt.delegate = self
        descriptionTxt.delegate = self
        
        //pickerView.isHidden = true
        amountTxt.keyboardType = .decimalPad
        phonenumberTxt.keyboardType = .numberPad
        EmailTxt.keyboardType = .emailAddress
        referenceTxt.keyboardType = .decimalPad
        descriptionTxt.keyboardType = .default
        
        descriptionTxt.center.x = view.frame.width + 50
        expiryTxt.center.x = view.frame.width + 50
        phonenumberTxt.center.x = view.frame.width + 50
        amountTxt.center.y -= view.bounds.width
        EmailTxt.center.y -= view.bounds.width
        referenceTxt.center.y -= view.bounds.width
        phonenumberTxt.center.y -= view.bounds.width
        expiryTxt.center.y -= view.bounds.width
        descriptionTxt.center.y -= view.bounds.width
        UIView.animate(withDuration: 1.0, delay: 0.3, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0,options: .allowAnimatedContent) {
            self.descriptionTxt.center.x = self.view.frame.width/2
            self.expiryTxt.center.x = self.view.frame.width/2
            self.phonenumberTxt.center.x = self.view.frame.width/2
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.phonenumberTxt.center.y += self.view.bounds.width
            self.EmailTxt.center.y += self.view.bounds.width
            self.referenceTxt.center.y += self.view.bounds.width
            self.expiryTxt.center.y += self.view.bounds.width
            self.descriptionTxt.center.y += self.view.bounds.width
            self.descriptionTxt.center.y += self.view.bounds.width
        })
    }
}


enum linkExpiry : String {
case OneDay = "One Day"
case OneWeek = "One Week"
case OneMonth = "One Month"
}
struct LinkExpiryCases {
    
    var title: String?
    var value: LinkExpiry?
}


struct Country: Codable {
    let name: String
    let code: String
    let dial_code: String
}
//MARK:- email & number check
extension String {
    
    var isValidEmail: Bool {
        return NSPredicate(format: "SELF MATCHES %@", "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$").evaluate(with: self)
      
    }
    var numberValidation: Bool {
        return NSPredicate(format: "SELF MATCHES %@", "^(?=.*[0-9]).{10}$").evaluate(with: self)
    }
    
}
