//
//  BaseViewController.swift
//  IceCream
//
//  Created by Giri on 2/5/25.
//

import UIKit
import IposgoSDK
import DeepLinking

class BaseViewController: UIViewController, isClickMenuPassData {
    
    var topView: UIView?
    var menuViewController: MenuViewController!
    var menuView: UIView!
    var passdata1:isClickMenuPassData?
    @IBOutlet var shadowView: UIView!
    let readerInstance_Dl = Wrapper()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func passData(data: MenuItem) {
        
        
        if  data.title == "Ticket" || data.title == "Void" {
            routeToTicketandVoid(title: data.title)
        }else if data.title == "Registration"{
            routeToRegistration(title: data.title)
        }else if data.title == "Logout"{
            routeToSale_Refund(title: "Sale")
        }else if data.title == "Batch Settlement" {
        let alert = UIAlertController(title: Constant.Confirmation.rawValue,
                                          message: Constant.batchSettleMsg.rawValue,
                                          preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: Constant.cancel.rawValue, style: .cancel) { _ in
                print("Cancel tapped")
            }
            
            let okAction = UIAlertAction(title: Constant.ok.rawValue, style: .default) { [self] _ in
                print("OK tapped")
            let inDeepLink = UserDefaults.Keys.deepLinkingVersion.rawValue
                let currentValue = UserDefaults.standard.string(forKey: inDeepLink)
                if currentValue == "1" { // DL
                    readerInstance_Dl.startBatchSettlement(delegate: self)
                } else { // InApp
                    guard let regView =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomerCopyViewController") as? CustomerCopyViewController else { return }
                    regView.isFromBatchSettlementInApp = true
                    self.navigationController?.pushViewController(regView, animated: true)
                }
            }
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }else if data.title  == "Configuration" {
            routeToConfiguration()
        }else{
            routeToSale_Refund(title: data.title)
        }
        
    }
    
    @IBAction func menuAction(_ sender: UIButton)  {
        self.initmenuView()
        self.menuView.frame = CGRect(x: -screenWidth, y: 0, width: screenWidth, height: screenHeight)
        self.addChild(self.menuViewController)
        self.view.addSubview(self.menuView)
        
        UIView.animate(withDuration: 0.3) {
            self.menuView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        }
        self.view.endEditing(true)
    }
    
    @objc func close_menu()
    {
        UIView.animate(withDuration: 0.3, animations: { ()->Void in
            self.menuView.frame = CGRect(x: -screenWidth, y: 0, width: screenWidth, height: screenHeight)
        })  {(finisheh) in
            self.menuView.removeFromSuperview()
            self.menuViewController.removeFromParent()
        }
    }
    
}


extension BaseViewController {
    
    func initmenuView() {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        menuViewController = (storyBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController)
        menuView = menuViewController.view
        menuViewController.menuDelegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.close_menu))
        menuViewController.shadowView.addGestureRecognizer(tapGesture)
    }
    
    func routeToConfiguration() {
        let VC = storyboard?.instantiateViewController(identifier: "ConfigurationViewController") as! ConfigurationViewController
        navigationController?.pushViewController(VC, animated: true)
        
    }
    
    func routeToTicketandVoid(title: String) {
        titlename = title
        if title == "Ticket" {
            txnType = .TICKET
        }else{
            txnType = .VOID
        }
   
            
            if txnType == .VOID {
                let VC = storyboard?.instantiateViewController(identifier: "VoidPreAuthList") as! VoidPreAuthList
                VC.transactionType = "void"
                navigationController?.pushViewController(VC, animated: true)
            } else {
                let VC = storyboard?.instantiateViewController(identifier: "VoidPreAuthList") as! VoidPreAuthList
                VC.transactionType = "ticket"
                navigationController?.pushViewController(VC, animated: true)
            }
           
        
    }
    
    func routeToSale_Refund(title: String) {
        
        titlename = title
        
        if title == "Sale" {
            txnType = .SALE
            dlTxnType = .SALE
        } else if title == "Refund" {
            txnType = .REFUND
            dlTxnType = .REFUND
        } else if title == "PreAuth" {
            txnType = .PRE_AUTH
            dlTxnType = .PREAUTH
        }else{
            txnType = .SALE
            dlTxnType = .SALE
        }
        if let targetVC = navigationController?.viewControllers.first(where: { $0 is CollectionListVC }) {
            navigationController?.popToViewController(targetVC, animated: true)
            titlename = title
            targetVC.viewWillAppear(true)
        }else{
            guard let VC = self.storyboard?.instantiateViewController(identifier: "CollectionListVC") as? CollectionListVC else { return }
            navigationController?.pushViewController(VC, animated: true)
        }
        
    }
    
    func routeToRegistration(title: String) {
        titlename = title
        if let targetVC = navigationController?.viewControllers.first(where: { $0 is RegistrationViewController }) {
            navigationController?.popToViewController(targetVC, animated: true)
            titlename = title
            targetVC.viewWillAppear(true)
        }else{
            guard let VC = self.storyboard?.instantiateViewController(identifier: "RegistrationViewController") as? RegistrationViewController else { return }
            navigationController?.pushViewController(VC, animated: true)
        }
    }
    
}
//MARK: - Deep Linking Delegate
extension BaseViewController: DLProtocolV2 {
    
    func didReceive_TransactionResponse(res: String?) {
        print(">>>res",res ?? "")
    }
    
   
    func didReceiveV2Response(success: URL?) {
        DispatchQueue.main.async {
            LoaDer.hideOverlayView()
        }
        if UIApplication.shared.canOpenURL(success!) {
            UIApplication.shared.open(success!, options: [:]) {  result in
                print(">>>Bool",result)
               
            }
        } else {
            showAlert(title: Constant.Alert.rawValue, msg: Constant.iposgoNotPresentInDevice.rawValue)
        }
    }
    
    func didReceiveRespV2Error(err: String?) {
       
    }
    
}
