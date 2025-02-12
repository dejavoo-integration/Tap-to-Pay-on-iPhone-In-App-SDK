//
//  ViewController.swift
//  IceCream
//
//  Created by Giri on 2/3/25.
//

import UIKit
import IposgoSDK

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
    var currentCode: String?
    var tranType: TransType = .SALE
    var tpn: String?
    var activityView: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearButton.isHidden = true
        checkoutView.clipsToBounds = true
        checkoutView.layer.cornerRadius = 15
        checkoutView.layer.borderColor = UIColor(red: 203/255, green: 195/255, blue: 227/255, alpha: 1).cgColor
        checkoutView.layer.borderWidth = 0.5
        
        checkoutView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        collectionList = [CollectionList(collectionName: "Bat", collectionImage: "bat", collectionCount: 0,price: 10),
                          CollectionList(collectionName: "Bike", collectionImage: "bike", collectionCount: 0,price: 20),
                          CollectionList(collectionName: "Car", collectionImage: "car", collectionCount: 0,price: 30),
                          CollectionList(collectionName: "Laptop", collectionImage: "loptop", collectionCount: 0,price: 50),
                          CollectionList(collectionName: "Ring", collectionImage: "ring", collectionCount: 0,price: 10),
                          CollectionList(collectionName: "Mobile", collectionImage: "mobile", collectionCount: 0,price: 20),
        ]
        collectionListBase = collectionList
        currentCode = "USD"
        tranType = .SALE
        cellRegister()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tranType = tranTypee
        chechoutHeightContrain.constant = 0
        clearData()
        setTitlelb()
    }
    
    func setTitlelb(){
        if titlename == "" || titlename == nil{
            titlelb.text = "Sale"
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
            prossedOrder(amount: TAMT, AMT: AMT)
        }else{
            showAlert(title: "Alert", msg: "Enter Amount")
        }
    }
    
    func prossedOrder(amount: String, AMT: String){
        if getisRegistered(){
            print("Total Amount:\(amount),  Int Amout: \(AMT)")
            checkSaleType(amount: amount)
        }else {
            showAlert(title: "Alert", msg: "Please register and process the transaction.")
        }
    }
    
    func checkSaleType(amount: String){
        readerInstance.delegate = self
        let payload = TxnData(amount: amount, tipAmount: "", currentCode: .usd, tranType: tranType)
        print(">>>payload",payload)
        LoaDer.showOverlay(view: self.view)
        readerInstance.startTransaction(param: payload)
    }
    
}

//MARK: ITap Delegates
@available(iOS 15.4, *)
extension CollectionListVC: IposgoDelegate {
    
    func didReceiveError(error: String?, code: Int?)  {
        
        print("&&&Invoke App Error Collectio vc:",error as Any)
        DispatchQueue.main.async {
            LoaDer.hideOverlayView()
        }
        switch nullStringToEmpty(string: error) {
            
        case nullStringToEmpty(string: "Transaction canceled by the merchant/card holder"):
            return
            
        default:
            DispatchQueue.main.async { [self] in
               
                showAlert(title: "Alert", msg: nullStringToEmpty(string: error))
                self.readerInstance.cleanup(delegate: self)
            }
            return
        }
        
    }
    
    func didReceiveSuccessData(message: String?, responseDict: [String : Any]?) {
        print("&&&didReceiveSuccessData Collectio vc")
        DispatchQueue.main.async { [self] in
            LoaDer.hideOverlayView()
            print("data....responseDict:\(String(describing: responseDict))")
            if responseDict?.count ?? 0 > 0 {
                let responseCode = responseDict?["HostResponseCode"] as? String
                let Spin_Response = responseDict?["Spin_Response"] as? [String:Any] ?? [:]
                let msg = Spin_Response["Message"] as? String ?? ""
               
                if responseCode == "00"{ // 00 sucess, not equal to zero is failure response code
                    showAlertAction(title: msg, message: String(describing: responseDict))
                }else{
                    showAlert(title: msg, msg: String(describing: responseDict))
                }
            } else {
                print("message:\(nullStringToEmpty(string: message))")
               
            }
        }
    }
    
}

