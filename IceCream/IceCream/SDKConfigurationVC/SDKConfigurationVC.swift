//
//  SDKConfigurationVC.swift
//  IceCream
//
//  Created by Deepika on 5/29/25.
//

import UIKit
import SwiftyGif


class SDKConfigurationVC: UIViewController {

    @IBOutlet weak var bgGif: UIImageView!
    @IBOutlet weak var deepLinkingBut: UIButton!
    @IBOutlet weak var inAppBut: UIButton!
    @IBOutlet weak var logo: UIImageView!
    var delegate: RegisterDeepLinking?
    @IBOutlet weak var dLView: UIView!
    @IBOutlet weak var InAppView: UIView!
    var isFromCallBacK : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        inAppBut.setImage(#imageLiteral(resourceName: "radiochecked"), for: .normal)
        deepLinkingBut.setImage(#imageLiteral(resourceName: "radio"), for: .normal)
        dLView.layer.cornerRadius = 10
        InAppView.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let gifManager = SwiftyGifManager(memoryLimit: 20) // Optional
        let gifImageView = UIImageView(gifImage: try! UIImage(gifName: "decor.gif"), manager: gifManager)
        gifImageView.frame = bgGif.bounds
        gifImageView.contentMode = .scaleAspectFill
        gifImageView.backgroundColor = .clear
        bgGif.backgroundColor = .clear
        bgGif.addSubview(gifImageView)
        
        
        let inAppKey = UserDefaults.Keys.inAppSDKVersion.rawValue
        let currentValue = UserDefaults.standard.string(forKey: inAppKey)
        
        switch currentValue {
        case "1":
            
            inAppBut.setImage(#imageLiteral(resourceName: "radiochecked"), for: .normal)
            deepLinkingBut.setImage(#imageLiteral(resourceName: "radio"), for: .normal)
        default:
            inAppBut.setImage(#imageLiteral(resourceName: "radio"), for: .normal)
            deepLinkingBut.setImage(#imageLiteral(resourceName: "radiochecked"), for: .normal)
        }
        
    }
    
    
    @IBAction func inAppAction(_ sender: UIButton) {
       
        let deepLinkKey = UserDefaults.Keys.deepLinkingVersion.rawValue

        let currentValue = UserDefaults.standard.string(forKey: deepLinkKey)

        if currentValue == "1" {
            
            
            let alert = UIAlertController(title: Constant.Confirmation.rawValue,
                                          message: Constant.contiueWithInApp.rawValue,
                                          preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: Constant.cancel.rawValue, style: .cancel) { _ in
                print("Cancel tapped")
            }
            
            let okAction = UIAlertAction(title: Constant.ok.rawValue, style: .default) { [self] _ in
                print("OK tapped")
                if isFromCallBacK == true  {
                    routeToRegistrationFromSwitchingSDKVersion(isFromDlFlow: false)
                } else {
                    routeToRegistrationFromDL(isFromDL: false)
                }
            }
            
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func deepLinkingAction(_ sender: UIButton) {
        
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
                
                if isFromCallBacK == true  {
                    routeToRegistrationFromSwitchingSDKVersion(isFromDlFlow: true)
                } else {
                    routeToRegistrationFromDL(isFromDL: true)
                }
               
               
            }
            
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func proceedEvent(_ sender: UIButton) {
        
        guard let VC = self.storyboard?.instantiateViewController(identifier: "CollectionListVC") as? CollectionListVC else { return }
        titlename = Constant.Sale.rawValue
        VC.tranType = .SALE
        txnType = .SALE
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    
    func routeToRegistrationFromDL(isFromDL: Bool) {
        
        if let viewControllers = navigationController?.viewControllers {
            for vc in viewControllers {
                if let targetVC = vc as? RegistrationViewController {
                    self.delegate?.didReceiveDeepLink(isFromDlFlow: isFromDL)
                    navigationController?.popToViewController(targetVC, animated: true)
                    break
                }
            }
        }
    }
    
    func routeToRegistrationFromSwitchingSDKVersion(isFromDlFlow: Bool) {
        
        guard let VC = self.storyboard?.instantiateViewController(identifier: "RegistrationViewController") as? RegistrationViewController else { return }
        VC.isFromDLFlow = isFromDlFlow
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
}
