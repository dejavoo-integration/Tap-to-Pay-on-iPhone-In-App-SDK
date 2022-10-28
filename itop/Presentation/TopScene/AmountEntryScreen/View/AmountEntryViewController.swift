//
//  AmountEntryViewController.swift
//  itop
//
//  Created by meganathan on 21/07/22.
//


import UIKit
import SideMenu

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        keypadLogic()
        setUpCardUI()
        cornerRadius()

    }
    
    func keypadLogic() {
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
    
}



