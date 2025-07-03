//
//  ConfigurationViewController.swift
//  IceCream
//
//  Created by Deepika on 5/28/25.
//

import UIKit

enum OptionalScreen : String {
    case approvalScreen = "Show Approval Screen"
    case breakupScreen = "Show Breakup Screen"
    case tipScreen = "Show Tip Screen"
}
enum SDKVersion : String {
    
    case inAppSDK = "In-App SDK"
    case deepLinkingSDL = "Deep Linking SDK"
}

class ConfigurationViewController: UIViewController {
    

    @IBOutlet weak var dLOptionalTableView: UITableView!
    
    @IBOutlet weak var selectSDKTableView: UITableView!
    
    @IBOutlet weak var titlelb:UILabel!
    
    var sdkVersionList = [SDKVersion.inAppSDK.rawValue,SDKVersion.deepLinkingSDL.rawValue]
    var configurationList = [OptionalScreen.approvalScreen.rawValue,OptionalScreen.breakupScreen.rawValue,OptionalScreen.tipScreen.rawValue]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titlelb.text = Constant.Configuration.rawValue
        dLOptionalTableView.register(UINib(nibName: "ConfigurationCell", bundle: nil), forCellReuseIdentifier: "ConfigurationCell")
        selectSDKTableView.register(UINib(nibName: "ConfigurationCell", bundle: nil), forCellReuseIdentifier: "ConfigurationCell")
        tableViewRearrgement()
    }

    @IBAction func goBack(_ sender: UIButton) {
        
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


extension ConfigurationViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView {
            
        case dLOptionalTableView:
            return configurationList.count > 0 ?  configurationList.count : 0
        default:
            return sdkVersionList.count > 0 ?  sdkVersionList.count : 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
            
        case dLOptionalTableView:
            let cell = dLOptionalTableView.dequeueReusableCell(withIdentifier: "ConfigurationCell", for: indexPath) as! ConfigurationCell
            cell.selectionStyle = .none
            
            
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            cell.titleLbl.text = configurationList[indexPath.row]
            cell.switchButton.tag = indexPath.row
            
            cell.switchButton.addTarget(self, action: #selector(enableActionEvent), for: .touchUpInside)
            
            
            switch configurationList[indexPath.row] {
                
            case OptionalScreen.tipScreen.rawValue:
                if  let isEnableTip = UserDefaults.standard.string(forKey: UserDefaults.Keys.isEnableShowTipScreen.rawValue) {
                    
                    isEnableTip == "1" ?  cell.switchButton.setImage(#imageLiteral(resourceName: "SwitchOn"), for: .normal) : cell.switchButton.setImage(#imageLiteral(resourceName: "SwitchOff"), for: .normal)
                    
                    
                } else {
                    cell.switchButton.setImage(#imageLiteral(resourceName: "SwitchOff"), for: .normal)
                }
            case OptionalScreen.breakupScreen.rawValue:
                if  let isEnableBreakUp = UserDefaults.standard.string(forKey: UserDefaults.Keys.isEnableShowBreakupScreen.rawValue) {
                    
                    isEnableBreakUp == "1" ?  cell.switchButton.setImage(#imageLiteral(resourceName: "SwitchOn"), for: .normal) : cell.switchButton.setImage(#imageLiteral(resourceName: "SwitchOff"), for: .normal)
                    
                    
                } else {
                    cell.switchButton.setImage(#imageLiteral(resourceName: "SwitchOff"), for: .normal)
                }
            default:
                
                if  let isEnableApproval = UserDefaults.standard.string(forKey: UserDefaults.Keys.isEnableShowApprovalScreen.rawValue) {
                    
                    isEnableApproval == "1" ?  cell.switchButton.setImage(#imageLiteral(resourceName: "SwitchOn"), for: .normal) : cell.switchButton.setImage(#imageLiteral(resourceName: "SwitchOff"), for: .normal)
                    
                    
                } else {
                    cell.switchButton.setImage(#imageLiteral(resourceName: "SwitchOff"), for: .normal)
                }
            }
            
            return cell
        default:
            let cell = selectSDKTableView.dequeueReusableCell(withIdentifier: "ConfigurationCell", for: indexPath) as! ConfigurationCell
            cell.selectionStyle = .none
            
            
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            
            cell.titleLbl.text =  sdkVersionList[indexPath.row]
            cell.switchButton.tag = indexPath.row
            
            cell.switchButton.addTarget(self, action: #selector(sdKSelectionActionEvent), for: .touchUpInside)
            
            
            switch sdkVersionList[indexPath.row] {
                
            case SDKVersion.inAppSDK.rawValue:
                if  let isEnableInApp = UserDefaults.standard.string(forKey: UserDefaults.Keys.inAppSDKVersion.rawValue) {
                    
                    isEnableInApp == "1" ?  cell.switchButton.setImage(#imageLiteral(resourceName: "SwitchOn"), for: .normal) : cell.switchButton.setImage(#imageLiteral(resourceName: "SwitchOff"), for: .normal)
                    
                    
                } else {
                    cell.switchButton.setImage(#imageLiteral(resourceName: "SwitchOff"), for: .normal)
                }
                
            default:
                if  let isEnableDL = UserDefaults.standard.string(forKey: UserDefaults.Keys.deepLinkingVersion.rawValue) {
                    
                    isEnableDL == "1" ?  cell.switchButton.setImage(#imageLiteral(resourceName: "SwitchOn"), for: .normal) : cell.switchButton.setImage(#imageLiteral(resourceName: "SwitchOff"), for: .normal)
                    
                    
                } else {
                    cell.switchButton.setImage(#imageLiteral(resourceName: "SwitchOff"), for: .normal)
                }
              
            }
            return cell
        }
    }
    
   
    @objc func enableActionEvent(sender: UISwitch) {
        
        
        let point = sender.convert(CGPoint.zero, to:self.dLOptionalTableView)
        if let indexPath = dLOptionalTableView.indexPathForRow(at: point) {
        
            
            switch configurationList[indexPath.row] {
                
            case OptionalScreen.tipScreen.rawValue:
                let tipScreenKey = UserDefaults.Keys.isEnableShowTipScreen.rawValue

                if let isEnableTip = UserDefaults.standard.string(forKey: tipScreenKey) {
                    let newValue = (isEnableTip == "1") ? "0" : "1"
                    UserDefaults.standard.set(newValue, forKey: tipScreenKey)
                } else {
                    UserDefaults.standard.set("1", forKey: tipScreenKey)
                }
            case OptionalScreen.breakupScreen.rawValue:
                let breakupScreenKey = UserDefaults.Keys.isEnableShowBreakupScreen.rawValue

                if let isEnableBreakup = UserDefaults.standard.string(forKey: breakupScreenKey) {
                    let newValue = (isEnableBreakup == "1") ? "0" : "1"
                    UserDefaults.standard.set(newValue, forKey: breakupScreenKey)
                } else {
                    UserDefaults.standard.set("1", forKey: breakupScreenKey)
                }
            default:
                
                let approvalScreenKey = UserDefaults.Keys.isEnableShowApprovalScreen.rawValue

                if let isEnableApproval = UserDefaults.standard.string(forKey: approvalScreenKey) {
                    let newValue = (isEnableApproval == "1") ? "0" : "1"
                    UserDefaults.standard.set(newValue, forKey: approvalScreenKey)
                } else {
                    UserDefaults.standard.set("1", forKey: approvalScreenKey)
                }
            }
        }
        
        
        dLOptionalTableView.reloadData()
    }
    
        
    @objc func sdKSelectionActionEvent(sender: UIButton) {
        
        
        let point = sender.convert(CGPoint.zero, to:self.selectSDKTableView)
        if let indexPath = selectSDKTableView.indexPathForRow(at: point) {
        
            
            switch sdkVersionList[indexPath.row] {
                
            case SDKVersion.inAppSDK.rawValue:
                let inDeepLink = UserDefaults.Keys.deepLinkingVersion.rawValue
               

                let currentValue = UserDefaults.standard.string(forKey: inDeepLink)
                
                
                if currentValue == "1" {
                    
                    let alert = UIAlertController(title: Constant.Confirmation.rawValue,
                                                  message: Constant.contiueWithInApp.rawValue,
                                                  preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title: Constant.cancel.rawValue, style: .cancel) { _ in
                        print("Cancel tapped")
                    }
                    
                    let okAction = UIAlertAction(title: Constant.ok.rawValue, style: .default) { [self] _ in
                        print("OK tapped")
                        
                        routeToRegistrationFromDL(isFromDL: false)
                    }
                    
                    alert.addAction(cancelAction)
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
            default:
                    let inAppKey = UserDefaults.Keys.inAppSDKVersion.rawValue
                   

                    let currentValue = UserDefaults.standard.string(forKey: inAppKey)
                    
                    
                if currentValue == "1" {
                    let alert = UIAlertController(title: Constant.Confirmation.rawValue,
                                                  message: Constant.contiueWithDL.rawValue,
                                                  preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title: Constant.cancel.rawValue, style: .cancel) { _ in
                        print("Cancel tapped")
                    }
                    
                    let okAction = UIAlertAction(title: Constant.ok.rawValue, style: .default) { [self] _ in
                        print("OK tapped")
                        
                        routeToRegistrationFromDL(isFromDL: true)
                    }
                    
                    alert.addAction(cancelAction)
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        tableViewRearrgement()
        selectSDKTableView.reloadData()
    }
    
    func tableViewRearrgement() {
        
        if  let dL = UserDefaults.standard.string(forKey: UserDefaults.Keys.deepLinkingVersion.rawValue) {
            
            dLOptionalTableView.isHidden =  dL == "1" ? false :  true
        } else {
            dLOptionalTableView.isHidden =  true
        }
    }
    
    
    func routeToRegistrationFromDL(isFromDL: Bool) {
        
        guard let VC = self.storyboard?.instantiateViewController(identifier: "RegistrationViewController") as? RegistrationViewController else { return }
        VC.isFromDLFlow = isFromDL
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
}
