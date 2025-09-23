//
//  ViewController.swift
//  IceCream
//
//  Created by Giri on 2/3/25.
//

import UIKit
import IposgoSDK
import DeepLinking

class CollectionListVC: BaseViewController {
    
    @IBOutlet weak var listTable:UITableView!
    @IBOutlet weak var titlelb:UILabel!
    @IBOutlet weak var checkoutPrice:UILabel!
    var collectionList = [CollectionList]()
    var collectionListBase = [CollectionList]()
    @IBOutlet weak var chechoutHeightContrain: NSLayoutConstraint!
    @IBOutlet weak var checkoutView: UIView!
    @IBOutlet weak var clearButton:UIButton!
    
    let readerInstance = IposgoReader()
    var tranType: IposgoSDK.TransType = .SALE
    var tpn: String?
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    let dLReaderInstance = Wrapper()
    var dLTranType: DeepLinkTransType = .SALE
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearButton.isHidden = true
        checkoutView.clipsToBounds = true
        checkoutView.layer.cornerRadius = 15
        checkoutView.layer.borderColor = UIColor(red: 203/255, green: 195/255, blue: 227/255, alpha: 1).cgColor
        checkoutView.layer.borderWidth = 0.5
        
        checkoutView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        collectionList = [CollectionList(collectionName: "Mint Chocolate Chip", collectionImage: "Item1", collectionCount: 0,price: 0.25),
                          CollectionList(collectionName: "Cookies and Cream", collectionImage: "Item2", collectionCount: 0,price: 10.00),
                          CollectionList(collectionName: "Strawberry Swirl", collectionImage: "Item3", collectionCount: 0,price: 0.02),
                          CollectionList(collectionName: "Rocky Road", collectionImage: "Item4", collectionCount: 0,price: 0.03),
                          CollectionList(collectionName: "Salted Caramel", collectionImage: "Item5", collectionCount: 0,price: 0.04),
                          CollectionList(collectionName: "Butter Pecan", collectionImage: "Item6", collectionCount: 0,price : 15.00),
        ]
        collectionListBase = collectionList
        tranType = .SALE
        dLTranType = .SALE
        cellRegister()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tranType = txnType
        self.dLTranType = dlTxnType
        chechoutHeightContrain.constant = 0
        clearData()
        setTitlelb()
        
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
    
    func setTitlelb(){
        
        if titlename == "" || titlename == nil{
            titlelb.text = Constant.Sale.rawValue
        }else{
            titlelb.text = titlename
        }
    }
    
    @IBAction func closeAc(_ sender: Any) {
        clearData()
    }
    
    func clearData() {
        collectionList = collectionListBase
        listTable.reloadData()
        showBottomView()
    }
    
    @IBAction func checkOutAc(_ sender: Any) {
        let totalAmount = collectionList.map({($0.price ?? 0) * Double($0.collectionCount ?? 0)}).reduce(0, +)
        let AMT = calculateAmountto100_String(totalAmount.dollarString) ?? ""
        let TAMT = String(format: "%.2f", totalAmount)
        if isSelectedCollection(){
            proceedOrder(amount: TAMT, AMT: AMT)
        }else{
            showAlert(title: Constant.Alert.rawValue, msg: Constant.enterAmount.rawValue)
        }
    }
    
    func proceedOrder(amount: String, AMT: String) {
       
        if getisRegistered() {
           
            let deepLinkKey = UserDefaults.Keys.deepLinkingVersion.rawValue

            let currentValue = UserDefaults.standard.string(forKey: deepLinkKey)

            switch currentValue { //Deep Linking SDK
                
            case "1":
                    
                let VC = storyboard?.instantiateViewController(identifier: "TicketViewController") as! TicketViewController
                
                switch dLTranType {
                   
                case .PREAUTH:
                    
                    VC.tranType = TransType.PRE_AUTH
                    VC.saleAmt = amount
                    dlTxnType = DeepLinkTransType.PREAUTH
                    titlename = Constant.PreAuth.rawValue
                    
                case .REFUND:
                    
                    VC.tranType = TransType.REFUND
                    VC.saleAmt = amount
                    dlTxnType = DeepLinkTransType.REFUND
                    titlename =  Constant.Refund.rawValue
                    
                default:
                    VC.tranType = TransType.SALE
                    VC.saleAmt = amount
                    dlTxnType = DeepLinkTransType.SALE
                    titlename =  Constant.Sale.rawValue
                }
                    
                navigationController?.pushViewController(VC, animated: true)
                    
            default: // InApp SDK
                
                switch tranType {
                    
                case .SALE:
                    let VC = storyboard?.instantiateViewController(identifier: "TicketViewController") as! TicketViewController
                    VC.tranType = TransType.SALE
                    VC.saleAmt = amount
                    titlename = Constant.Sale.rawValue
                    navigationController?.pushViewController(VC, animated: true)
                case .REFUND:
                    let VC = storyboard?.instantiateViewController(identifier: "TicketViewController") as! TicketViewController
                    VC.tranType = TransType.REFUND
                    VC.saleAmt = amount
                    titlename = Constant.Refund.rawValue
                    navigationController?.pushViewController(VC, animated: true)
                case .PRE_AUTH:
                    let VC = storyboard?.instantiateViewController(identifier: "TicketViewController") as! TicketViewController
                    VC.tranType = TransType.PRE_AUTH
                    VC.saleAmt = amount
                    titlename = Constant.PreAuth.rawValue
                    navigationController?.pushViewController(VC, animated: true)
                case .TICKET:
                    let VC = storyboard?.instantiateViewController(identifier: "TicketViewController") as! TicketViewController
                    VC.tranType = TransType.TICKET
                    VC.saleAmt = amount
                    titlename = Constant.ticket.rawValue
                    navigationController?.pushViewController(VC, animated: true)
                default:
                    let VC = storyboard?.instantiateViewController(identifier: "TicketViewController") as! TicketViewController
                    VC.tranType = TransType.SALE
                    VC.saleAmt = amount
                    titlename = Constant.Sale.rawValue
                    navigationController?.pushViewController(VC, animated: true)
                }
            }
          
        } else {
            showAlert(title: Constant.Alert.rawValue, msg: Constant.registerAndProcessTransaction.rawValue)
        }
    }
    
}


//MARK: ITap Delegates
@available(iOS 15.4, *)
extension CollectionListVC: IposgoDelegate {
    
    func didReceiveError(error: String?, code: Int?)  {
    
        DispatchQueue.main.async { [self] in
            stopLoading()
        }
        switch nullStringToEmpty(string: error) {
            
        case nullStringToEmpty(string: Constant.cardCancelled.rawValue):
            return
            
        default:
            DispatchQueue.main.async { [self] in
               
                showAlert(title: Constant.Alert.rawValue, msg: nullStringToEmpty(string: error))
                self.readerInstance.cleanup(delegate: self)
            }
            return
        }
        
    }
    
    func didReceiveSuccessData(message: String?, responseDict: [String : Any]?) {
       
       
        
        DispatchQueue.main.async { [self] in
            
            print("data....responseDict:\(String(describing: responseDict))")
           
            if responseDict?.count ?? 0 > 0 {
                stopLoading()
                let VC = storyboard?.instantiateViewController(identifier: "CustomerCopyViewController") as! CustomerCopyViewController
                VC.responseDict = responseDict
                navigationController?.pushViewController(VC, animated: true)
                
                
            } else {
                
                print("message:\(nullStringToEmpty(string: message))")
            }
        }
    }
    
}

