//
//  AmountEntryViewController.swift
//  itop
//
//  Created by meganathan on 21/07/22.
//


import UIKit
import SideMenu
import Alamofire
import SwiftyJSON

class AmountEntryViewController: UIViewController,UINavigationControllerDelegate {
    
    
    @IBOutlet weak var lblAmountEntry: UILabel!
    @IBOutlet weak var btnAmountEntryBack: UIButton!
    @IBOutlet weak var keyPad: KeyBoardPad!
    @IBOutlet weak var btnAmountEntryOK: UIButton!
    @IBOutlet weak var lblMenu: UILabel!
    var runningnumber = ""
    var inum = ""
    @IBOutlet weak var btnAmountClear: UIButton!
    @IBOutlet weak var dropShadowLabel: UILabel!
    @IBOutlet weak var wifiImage: UIImageView!
    @IBOutlet weak var hamburgerImage: UIImageView!
    @IBOutlet weak var hamburgerBtn: UIButton!
    @IBOutlet weak var stackOptions: UIStackView!
    @IBOutlet weak var settingsBtn: UIImageView!
    @IBOutlet weak var starBtn: UIImageView!
    @IBOutlet weak var profileBtn: UIImageView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var favouritesImage: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var reprintBtn: UIButton!
    @IBOutlet weak var upgradeApp: UIButton!
    @IBOutlet weak var showSettle: UIButton!
    @IBOutlet weak var reportsBtn: UIButton!
    @IBOutlet weak var adjustTip: UIButton!
    @IBOutlet weak var preSaleTicket: UIButton!
    @IBOutlet weak var giftLoyalty: UIButton!
    @IBOutlet weak var cashBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keypadLogic()
        setUpCardUI()
        cornerRadius()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tapGesture()
        settingsTap()
        wifiAction()
        supportAction()
    }
        
    func supportAction() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapping(tapGestureRecognizer:)))
           profileBtn.isUserInteractionEnabled = true
           profileBtn.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapping(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let mainStoryboard = UIStoryboard(name: "SupportViewController", bundle: nil)
        let supportVC = mainStoryboard.instantiateViewController(withIdentifier: "SupportViewController") as? SupportViewController
        self.present(supportVC!, animated: true)
    }
    
    
    func wifiAction() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTap(tapGestureRecognizer:)))
           wifiImage.isUserInteractionEnabled = true
           wifiImage.addGestureRecognizer(tapGestureRecognizer)
    }
   
    @objc func imageTap(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let mainStoryboard = UIStoryboard(name: "WifiViewControllerStoryboard", bundle: nil)
        
        let wifiVC = mainStoryboard.instantiateViewController(withIdentifier: "WifiViewController") as? WifiViewController
        
        self.present(wifiVC!, animated: true)
    }
    
    
    func settingsTap() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapp(tapGestureRecognizer:)))
           settingsBtn.isUserInteractionEnabled = true
           settingsBtn.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    @objc func imageTapp(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        let mainStoryboard = UIStoryboard(name: "UpgradeAppViewController", bundle: nil)
        
        let UpgradeVC = mainStoryboard.instantiateViewController(withIdentifier: "UpgradeAppViewController") as? UpgradeAppViewController
        
        self.present(UpgradeVC!, animated: true)
     
    }
    
    
    func tapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
           favouritesImage.isUserInteractionEnabled = true
           favouritesImage.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        stackOptions.isHidden = true
        //bottomView.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
            
            var screenHeight =  UIScreen.main.bounds.height / 2
            print(screenHeight)
            
            self.heightConstraint.constant = 500
            self.view.layoutIfNeeded()
        }) {(status) in
            
        }
    }
    
    
    @IBAction func closeBtnClicked(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.heightConstraint.constant = 0
            self.view.layoutIfNeeded()
        }) { [self](status) in
            stackOptions.isHidden = false
        }
    }
    
    
    func keypadLogic() {
        UserDefaults.standard.removeObject(forKey: "upgradeApp")
        runningnumber = ""
        inum = ""
        keyPad.clear()
        lblAmountEntry.text = "$0.00"
        lblAmountEntry.textColor = UIColor.darkText
    }
    
    
    func cornerRadius() {
        dropShadowLabel.addShadowToTextField(color: .gray,cornerRadius:20)
        hamburgerImage.setImageColor(color: .white)
        let hexaValue = UIColor(hexString: "#3E97A8")
        lblMenu.textColor = hexaValue
        wifiImage.setImageColor(color: hexaValue)
        hamburgerBtn.roundedButton()
        settingsBtn.setImageColor(color: UIColor.red)
        profileBtn.setImageColor(color: UIColor(hexString: "#293687"))
        starBtn.setImageColor(color: UIColor(hexString: "#F5A540"))
        
        reprintBtn.layer.cornerRadius = 10
        upgradeApp.layer.cornerRadius = 10
        showSettle.layer.cornerRadius = 10
        reportsBtn.layer.cornerRadius = 10
        adjustTip.layer.cornerRadius = 10
        preSaleTicket.layer.cornerRadius = 10
        giftLoyalty.layer.cornerRadius = 10
        cashBtn.layer.cornerRadius = 10
        
    }
    
    
    private func setUpCardUI() {
        [keyPad].forEach{
             $0?.onClickNumberBlock = {
                //UnBlock Button Action
                 self.blockNumberPad()
            }
            $0?.onClickOKBlock = {
               //UnBlock Button Action
                self.blockOKpad()
           }
            
            $0?.onClickBackBlock = {
               //UnBlock Button Action
                self.blockBackPad()
           }
            
        }
    }
    
    private func blockNumberPad() {
        switch(keyPad.inum.count)
            {
                case 3 :
            keyPad.inum = keyPad.inum.replacingOccurrences(of: "\(keyPad.inum)", with: "\("0.0" + keyPad.runningnumber.substring(from: keyPad.runningnumber.count - 1))")

                case 4 :
            keyPad.inum = keyPad.inum.replacingOccurrences(of: "\(keyPad.inum)", with: "\("0." + keyPad.runningnumber.substring(from: keyPad.runningnumber.count - 2))")

                default:
            keyPad.inum = keyPad.inum.replacingOccurrences(of: "\(keyPad.inum)", with: "\(keyPad.runningnumber.substring(to: keyPad.runningnumber.count - 3) + "." + keyPad.runningnumber.substring(from: keyPad.runningnumber.count - 2))")
            }
        lblAmountEntry.text = "$" + keyPad.inum
            //print ("Value:" + "\(textView.inum)")
    }

    private func blockBackPad()
    {
        switch(keyPad.runningnumber.count)
        {
        case 1 :
            if(keyPad.runningnumber.count > 0){
                keyPad.inum = "0.00"
                keyPad.runningnumber = keyPad.runningnumber.substring(to: keyPad.runningnumber.index(before: keyPad.runningnumber.endIndex))
            }
        case 2 :
            if(keyPad.runningnumber.count > 0){
                keyPad.inum = String(keyPad.inum.replacingOccurrences(of: keyPad.runningnumber.substring(to:1), with:"\("0" + keyPad.runningnumber.substring(to: 0))"))
                keyPad.runningnumber = keyPad.runningnumber.substring(to: keyPad.runningnumber.index(before: keyPad.runningnumber.endIndex))
            }
        case 3 :
            if(keyPad.runningnumber.count > 0){
                keyPad.runningnumber = keyPad.runningnumber.substring(to: keyPad.runningnumber.index(before: keyPad.runningnumber.endIndex))
                keyPad.inum = keyPad.runningnumber
                keyPad.inum = keyPad.inum.replacingOccurrences(of: keyPad.runningnumber, with:"\("0." + keyPad.runningnumber.substring(from: keyPad.runningnumber.count-2))")
            }
        default:
            if(keyPad.runningnumber.count > 0){
                keyPad.runningnumber = keyPad.runningnumber.substring(to: keyPad.runningnumber.index(before: keyPad.runningnumber.endIndex))
                keyPad.inum = keyPad.runningnumber
                keyPad.inum = keyPad.inum.replacingOccurrences(of: keyPad.runningnumber, with: keyPad.runningnumber.substring(to: keyPad.runningnumber.count - 3) + "\("." + keyPad.runningnumber.substring(from: keyPad.runningnumber.count - 2))")
            }
        }
        lblAmountEntry.text = "$" + keyPad.inum
       
    }
    
    private func blockOKpad()
    {
        
        let mainStoryboard = UIStoryboard(name: "CardTapOnScreenViewController", bundle: nil)
        if let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "CardTapOnScreenViewController") as? CardTapOnScreenViewController {
            homeViewController.iAmount = keyPad.inum
            self.present(homeViewController, animated: true,completion: nil)
        }
        
    }
    
    
    @IBAction func numberPressed(_ sender: UIButton)
    {
        if runningnumber.count <= 10 {
            runningnumber += "\(sender.tag)"
            inum = "\(Double(Float(runningnumber)!))"
            switch(inum.count)
            {
            case 3 :
                inum = inum.replacingOccurrences(of: "\(inum)", with: "\("0.0" + runningnumber.substring(from: runningnumber.count - 1))")
            
            case 4 :
                inum = inum.replacingOccurrences(of: "\(inum)", with: "\("0." + runningnumber.substring(from: runningnumber.count - 2))")
                
            default:
                inum = inum.replacingOccurrences(of: "\(inum)", with: "\(runningnumber.substring(to: runningnumber.count - 3) + "." + runningnumber.substring(from: runningnumber.count - 2))")
            }
            lblAmountEntry.text = "$" + inum }
    }
     
    @IBAction func btnAmountEntryClearAction(_ sender: Any) {
        runningnumber = ""
        inum = ""
        lblAmountEntry.text = "$0.00"
        keyPad.clear()
    }
    
    @IBAction func btnAmountBackAction(_ sender: Any) {
        switch(runningnumber.count)
        {
        case 1 :
            if(runningnumber.count > 0){
            inum = "0.00"
            runningnumber = runningnumber.substring(to: runningnumber.index(before: runningnumber.endIndex))
            }
            
        case 2 :
            if(runningnumber.count > 0){
            inum = inum.replacingOccurrences(of: runningnumber.substring(to: 1), with:"\("0" + runningnumber.substring(to: 0))")
            runningnumber = runningnumber.substring(to: runningnumber.index(before: runningnumber.endIndex))
            }
            
        case 3 :
            if(runningnumber.count > 0){
            runningnumber = runningnumber.substring(to: runningnumber.index(before: runningnumber.endIndex))
            inum = runningnumber
            inum = inum.replacingOccurrences(of: runningnumber, with:"\("0." + runningnumber.substring(from: runningnumber.count-2))")
            }
           
            
        default:
            if(runningnumber.count > 0){
            runningnumber = runningnumber.substring(to: runningnumber.index(before: runningnumber.endIndex))
            inum = runningnumber
            inum = inum.replacingOccurrences(of: runningnumber, with: runningnumber.substring(to: runningnumber.count - 3) + "\("." + runningnumber.substring(from: runningnumber.count - 2))")
            }
           
        }
        
        lblAmountEntry.text = "$" + inum
    }
    
    @IBAction func btnAmountEntryAction(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "CardTapOnScreenViewController", bundle: nil)
        if let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "CardTapOnScreenViewController") as? CardTapOnScreenViewController {
            homeViewController.iAmount = inum
            self.present(homeViewController, animated: true,completion: nil)
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sideMenuNavigationController = segue.destination as? SideMenuNavigationController else { return }
        sideMenuNavigationController.leftSide = true
        sideMenuNavigationController.settings = makeSettings()
    }
    
    private func makeSettings() -> SideMenuSettings {
        let presentationStyle = SideMenuPresentationStyle.menuSlideIn
        presentationStyle.backgroundColor = .gray
        presentationStyle.presentingEndAlpha = 0.5
        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
        return settings
    }
    
    @IBAction func hamburgerButton(_ sender: UIButton) {
        
        let mainStoryboard = UIStoryboard(name: "SideMenuViewController", bundle: nil)
        if let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController {
            homeViewController.presentationStyle = .menuSlideIn
            self.present(homeViewController, animated: true,completion: nil)
        }
        

    }
    
    
    @IBAction func reportBtnClicked(_ sender: UIButton) {
        
//        let mainStoryboard = UIStoryboard(name: "ReportViewController", bundle: nil)
//
//        let reportVC = mainStoryboard.instantiateViewController(withIdentifier: "ReportViewController") as? ReportViewController
//
//        self.present(reportVC!, animated: true)
        
    }
    
    
    @IBAction func showSettle(_ sender: UIButton) {
        settlementSummary()
    }
    
    
    @IBAction func upgradeApp(_ sender: UIButton) {
        let mainStoryboard = UIStoryboard(name: "UpgradeAppViewController", bundle: nil)
        
        let UpgradeVC = mainStoryboard.instantiateViewController(withIdentifier: "UpgradeAppViewController") as? UpgradeAppViewController
        
        self.present(UpgradeVC!, animated: true)
        
    }
    
    
    func navigateToPageVC() {
        let mainStoryboard = UIStoryboard(name: "PageViewController", bundle: nil)
        let settleVC = mainStoryboard.instantiateViewController(withIdentifier: "PageViewController") as? PageViewController
        self.present(settleVC!, animated: true)
    }
    
    func settlementSummary() {
        let url = "https://api.denovosystem.tech/v1/open-batch-test/999522600449"
       let header : HTTPHeaders = ["Authorization": "api-key cG9ydGFsLVRlbXA9VG9rZW4tcGhhc2UtMQ=="]
    
        AF.request(url, method: .get,headers: header).responseJSON { [self] response in
            print("isiLagi: \(response)")
            switch response.result {
            case .success(let data):
                print("isi: \(data)")
            let json = JSON(data)
                
            let batchProfile = json["batch_profiles"].arrayValue
            print(batchProfile)
                
            if  let cashPayment = json["cash_payment"]["data"].array {
                    print(cashPayment)
                    UserDefaults.standard.set(true, forKey: "cash_payment")
                  }
        
                if let alterPayment = json["alter_payments"]["data"].array
                   {
                    print(alterPayment)
                    UserDefaults.standard.set(true, forKey: "alter_payments")
                }
    
            for batchProfiles in batchProfile {
                let batchSumarry = batchProfiles["batch_summary"].arrayValue
                    print(batchSumarry)
                
                let batchDetails = batchProfiles["batch_details"].arrayValue
                print(batchDetails)
                
                
                if let batchNum = batchProfiles["batch_number"].string {
                    print(batchNum)
                    UserDefaults.standard.set(batchNum, forKey: "batchNumber")
                }
                if let without_Fee = batchProfiles["without_fee"].int  {
                    print(without_Fee)
                    UserDefaults.standard.set(without_Fee, forKey: "withoutFee")
                    
                }
                if let Fee = batchProfiles["fee"].int  {
                    print(Fee)
                    UserDefaults.standard.set(Fee, forKey: "Fee")
                }
                if let without_tip = batchProfiles["without_tip"].int  {
                    print(without_tip)
                    UserDefaults.standard.set(without_tip, forKey: "withoutTip")
                }
                if let tip = batchProfiles["tip"].int  {
                    print(tip)
                    UserDefaults.standard.set(tip, forKey: "Tip")
                }
               
                
                for summaryList in batchSumarry {
                    if let amount = summaryList["amount"].int{
                        print(amount)
                    }
                    if let type = summaryList["type"].string {
                        print(type)
                    }
                    if let transaction_no = summaryList["transaction_no"].int {
                        print(transaction_no)
                    }
                }
                
                navigateToPageVC()
            }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    
    @IBAction func reprintPressed(_ sender: UIButton) {
        let mainStoryboard = UIStoryboard(name: "ReprintViewController", bundle: nil)
        let supportVC = mainStoryboard.instantiateViewController(withIdentifier: "ReprintViewController") as? ReprintViewController
        self.present(supportVC!, animated: true)
        
    }
}



