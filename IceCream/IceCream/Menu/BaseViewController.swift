//
//  BaseViewController.swift
//  IceCream
//
//  Created by Giri on 2/5/25.
//

import UIKit
import IposgoSDK

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
var titlename:String?
var tranTypee: TransType = .SALE
class BaseViewController: UIViewController, isClickMenuPassData {
    
    var topView: UIView?
    var menuViewController: MenuViewController!
    var menuView: UIView!
    
    var passdata1:isClickMenuPassData?
    @IBOutlet var shadowView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
       // titlename = "Sale"
        
    }
    
    func passData(data: MenuItem) {
        if  data.title == "Ticket" || data.title == "Void" {
            routeToPreAuth(title: data.title)
        }else if data.title == "Registration"{
            routeToRegistration(title: data.title)
        }else if data.title == "Logout"{
            routeToSale_Refund(title: "Sale")
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


extension BaseViewController{
    func initmenuView(){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        menuViewController = (storyBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController)
        menuView = menuViewController.view
        menuViewController.menuDelegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.close_menu))
        menuViewController.shadowView.addGestureRecognizer(tapGesture)
    }
    
    func routeToPreAuth(title: String) {
        titlename = title
        if title == "Ticket" {
            tranTypee = .TICKET
        }else{
            tranTypee = .VOID
        }
            
        
        if let targetVC = navigationController?.viewControllers.first(where: { $0 is TicketViewController }) {
            navigationController?.popToViewController(targetVC, animated: true)
            targetVC.viewWillAppear(true)
        }else{
            let VC = storyboard?.instantiateViewController(identifier: "TicketViewController") as! TicketViewController
            VC.tranType = tranTypee
            navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    func routeToSale_Refund(title: String) {
        titlename = title
        if title == "Sale" {
            tranTypee = .SALE
        }else if title == "Refund" {
            tranTypee = .REFUND
        }else if title == "PreAuth" {
            tranTypee = .PRE_AUTH
        }else{
            tranTypee = .SALE
        }
        if let targetVC = navigationController?.viewControllers.first(where: { $0 is CollectionListVC }) {
            navigationController?.popToViewController(targetVC, animated: true)
            titlename = title
            targetVC.viewWillAppear(true)
        }else{
            let VC = storyboard?.instantiateViewController(identifier: "CollectionListVC") as! CollectionListVC
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
            let VC = storyboard?.instantiateViewController(identifier: "RegistrationViewController") as! RegistrationViewController
            navigationController?.pushViewController(VC, animated: true)
        }
    }
    
}
