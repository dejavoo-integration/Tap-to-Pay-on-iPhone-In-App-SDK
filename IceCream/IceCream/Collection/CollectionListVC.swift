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
    
    
    let readerInstance = IposgoReader()
    var currentCode: String?
    var tranType: TransType = .SALE
    var tpn: String?
    var activityView: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkoutView.clipsToBounds = true
        checkoutView.layer.cornerRadius = 40
        checkoutView.backgroundColor = .systemPurple
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
        collectionList = collectionListBase
        listTable.reloadData()
        settitlelb()
    }
    
    func settitlelb(){
        if titlename == "" || titlename == nil{
            titlelb.text = "Sale"
        }else{
            titlelb.text = titlename
        }
    }
    
    @IBAction func checkOutAc(_ sender: Any) {
        let totalAmount = collectionList.map({($0.price ?? 0) * Double($0.collectionCount ?? 0)}).reduce(0, +)
        //let AMT = calculateAmountto100_String(totalAmount.dollarString)
        let TAMT = String(format: "%.2f", totalAmount)
        if isSelectedCollection(){
            checkSaleType(amount: TAMT)
        }else{
            let alert = UIAlertController(title: "Alert", message: "Enter Amount", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func prossedOrder(amount: String, AMT: String){
        if getisRegistered(){
            print("Total Amount:\(amount),  Int Amout: \(AMT)")
            
            checkSaleType(amount: amount)
        }else {
            
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


struct TxnData : PayloadParameter {
    var amount: String
    var tipAmount: String?
    var currentCode: CurrencyCode
    var tranType: TransType
}

struct TicketTxnData : TicketPayloadParameter {
    
    var amount: String
    var tipAmount: String?
    var currentCode: CurrencyCode
    var tranType: TransType
    var rrn: String
    
}

struct VoidTxnData : VoidPayloadParameter {
    var rrn: String
    var tranType: TransType
}

//MARK: - Register [Registeration]
struct RegisterData : Register {
  var tpn: String
  var merchantCode: String
}



//MARK: ITap Delegates
@available(iOS 15.4, *)
extension CollectionListVC: IposgoDelegate {
    
    func didReceiveError(error: String?, code: Int?)  {
        
        print(">>>>Invoke App Error:",error as Any)
        DispatchQueue.main.async { [self] in
            LoaDer.hideOverlayView()
        }
        switch nullStringToEmpty(string: error) {
            
        case nullStringToEmpty(string: "Transaction canceled by the merchant/card holder"):
            return
            
        default:
            DispatchQueue.main.async { [self] in
               
                let alert = UIAlertController(title: "Alert", message: nullStringToEmpty(string: error), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.readerInstance.cleanup(delegate: self)
            }
            return
        }
        
    }
    
    func didReceiveSuccessData(message: String?, responseDict: [String : Any]?) {
        
        DispatchQueue.main.async { [self] in
            LoaDer.hideOverlayView()
            print("data....responseDict:\(String(describing: responseDict))")
            if responseDict != nil || responseDict?.count ?? 0 > 0 {
                let responseCode = responseDict?["HostResponseCode"] as? String
                let Spin_Response = responseDict?["Spin_Response"] as? [String:Any] ?? [:]
                let msg = Spin_Response["Message"] as? String ?? ""
                let extadata = Spin_Response["ExtData"] as? [String:Any] ?? [:]
                let AMT = extadata["TotalAmt"] as? String ?? ""
                if responseCode == "00"{ // 00 sucess, not equal to zero is failure response code
                    showAlert(title: msg, msg: "The transaction was completed successfully \(AMT)")
                    clerarData()
                }else{
                    showAlert(title: msg, msg: "")
                }
            } else {
                print("message:\(nullStringToEmpty(string: message))")
                let msg = nullStringToEmpty(string: message)
               // showAlert(title: "", msg: msg)
            }
        }
    }
    
    func clerarData() {
        collectionList = collectionListBase
        listTable.reloadData()
        showBottomView()
    }
}


//Alert function in shared class
extension UIViewController {
    func showAlert(title: String, msg: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

//["HostResponseMessage": "APPROVAL VTLMC1 ", "iPOSToken": "D0F8202EB44C6C4C233898B880C1A29EA2D82CFBAAAB43DF", "Spin_Response": ["AuthCode": "VTLMC1", "RespMsg": "APPROVAL VTLMC1 ", "Message": "APPROVED", "ExtData": ["DateTime": "20250210162046", "TaxState": "$1.00", "Fee": "$0.40", "AcntLast4": "6000", "EntryType": "tap-on-phone", "Tax2Label": "Local Tax", "TraceNum": "3", "TxnType": 1, "txnLabel": "sale", "BatchNum": "264", "Amount": "$10.00", "AcntFirst4": "5241", "txnId": "60718279950293705420250210162046", "FeeLabel": "Custom Fee", "networkMode": "WIFI", "TaxAmount": "$3.00", "TaxCity": "$2.00", "RRN": "504110502647", "Tip": "", "TotalAmt": "$13.40", "RespCode": "00", "Tax1Label": "State Tax", "CardType": "MASTERCARD", "HostTxnId": "60718279950293705420250210162046", "BaseAmount": "$10.00"], "RefId": "607182799502", "PaymentType": "CREDIT", "TransNum": "3", "PNRef": "504110502647", "ResultCode": "00"], "HostResponseCode": "00"]
