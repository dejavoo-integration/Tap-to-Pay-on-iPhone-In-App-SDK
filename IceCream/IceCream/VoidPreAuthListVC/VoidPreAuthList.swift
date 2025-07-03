//
//  VoidPreAuthList.swift
//  IceCream
//
//  Created by Deepika on 5/22/25.
//

import UIKit
import Foundation
import IposgoSDK
import DeepLinking



class VoidPreAuthList: BaseViewController {

    @IBOutlet weak var noDataFound: UILabel!
    @IBOutlet weak var voidTicketBut: UIButton!
    var cardListArray = [TxDetailEntity]()
    var entity : TxDetailEntity?
    var selectedIndex = -1
    var transactionType: String?
    @IBOutlet weak var titlelb:UILabel!
    @IBOutlet weak var tableView: UITableView!
    var indexSelected = false
    let readerInstance = IposgoReader()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    var dlReaderInstance = Wrapper()
    
    override func viewDidLoad() {
        
        tableView.register(UINib(nibName: "VoidTicketTableViewCell", bundle: nil), forCellReuseIdentifier: "VoidTicketTableViewCell")
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        noDataFound.isHidden = true
        titlelb.text = transactionType?.uppercased()
        
        // Set up the activity indicator
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor.black
        activityIndicator.hidesWhenStopped = true
        
        // Add the activity indicator to the view
        self.view.addSubview(activityIndicator)
        
        
       
        
        let deepLinkKey = UserDefaults.Keys.deepLinkingVersion.rawValue

        let currentValue = UserDefaults.standard.string(forKey: deepLinkKey)

        switch currentValue  {
            
        case "1": // Deep linking
            
            if let savedData = UserDefaults.standard.dictionary(forKey:  UserDefaults.Keys.lastTransaction.rawValue) {
                
                let txnName = savedData[ParamKey.txName.rawValue] as? String ?? ""
               
                switch nullStringToEmpty(string: transactionType) {
                    
                case Constant.ticket.rawValue:
                    
                    if txnName == Constant.PreAuth.rawValue {
                        
                        loadLastTXN()
                    }
                    
                default:
                    loadLastTXN()
                }
            }
              
            default:
                
                readerInstance.delegate = self
            
                switch nullStringToEmpty(string: transactionType) {
                    
                case Constant.ticket.rawValue:
                    
                    startLoading()
                    readerInstance.getListVoid_PreAuth(transactionType: TransType.TICKET)
                default:
                    
                    startLoading()
                    readerInstance.getListVoid_PreAuth(transactionType: TransType.VOID)
                }
            }
        }
        
        
    
    //MARK:- Load last TXN from local
    func loadLastTXN() {
        
        if let savedData = UserDefaults.standard.dictionary(forKey:  UserDefaults.Keys.lastTransaction.rawValue) {
            self.cardListArray.removeAll()
            // Add more fields as needed
            let entity =  TxDetailEntity(txName: savedData[ParamKey.txName.rawValue] as? String ?? "", cardMaskPan: savedData[ParamKey.cardMaskPan.rawValue] as? String ?? "", cardType:savedData[ParamKey.cardType.rawValue] as? String ?? "", traceNo:savedData[ParamKey.traceNo.rawValue] as? String ?? "", txnDateTime: savedData[ParamKey.txnDateTime.rawValue] as? String ?? "",rrnCode:savedData[ParamKey.rrnCode.rawValue] as? String ?? "", amount:savedData[ParamKey.sumAmount.rawValue] as? String ?? "",invoice: savedData[ParamKey.traceNo.rawValue] as? String ?? "")
            self.cardListArray.append(entity)
            if self.cardListArray.count > 0 {
                noDataFound.isHidden = true
            } else {
                noDataFound.isHidden = false
            }
            tableView.reloadData()
        }
    }
    
    @IBAction func startTxn(_ sender: UIButton) {
        
   
        
        if selectedIndex != -1 {
            
            
            switch nullStringToEmpty(string: transactionType) {
                
            case Constant.ticket.rawValue:

                let VC = storyboard?.instantiateViewController(identifier: "TicketViewController") as! TicketViewController
                VC.tranType = TransType.TICKET
                VC.entity = entity
                dlTxnType = DeepLinkTransType.TICKET
                navigationController?.pushViewController(VC, animated: true)
                
            default:
            
                let deepLinkKey = UserDefaults.Keys.deepLinkingVersion.rawValue

                let currentValue = UserDefaults.standard.string(forKey: deepLinkKey)

                switch currentValue  {
                    
                case "1": // Deep linking
                    
                    deepLinkingVoidTXN()
                    
                    
                default:
                    let payload = VoidTxnData(rrn: entity?.rrnCode ?? "",tranType: .VOID)
                    startLoading()
                    readerInstance.delegate = self
                    readerInstance.startVoid(param: payload)
                }
                
               
                
            }
            
        } else {
            
            showAlert(title: Constant.Alert.rawValue, msg: Constant.SelectTXN.rawValue)
            
        }
     
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
    
}


extension VoidPreAuthList : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardListArray.count > 0 ?  cardListArray.count : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "VoidTicketTableViewCell", for: indexPath) as! VoidTicketTableViewCell
        cell.selectionStyle = .none

        let getdetails = cardListArray[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        cell.trantypelb.text = getdetails.txName?.uppercased() ?? ""
        
        switch  getdetails.txName?.uppercased() ?? "" {
            
        case  "refund":
            cell.AmountLbl.text = "($" +  (getdetails.amount ?? "") + ")"
        default:
            cell.AmountLbl.text = "$" +  (getdetails.amount ?? "")
        }
        
        let cardNum = (getdetails.cardMaskPan?.suffix(4))
        
        cell.last4cardNumlb.text = "**** **** **** \(cardNum ?? "")"
        
        cell.tranidlb.text = "#" + (getdetails.invoice ?? "")
        
        if getdetails.cardType?.lowercased() == "visa"{
            cell.cardImg.image = UIImage(named: "visa")
        }else if getdetails.cardType?.uppercased() == "MASTERCARD"{
            cell.cardImg.image = UIImage(named: "mastercard")
        }else if getdetails.cardType?.uppercased() == "AMEX"{
            
            cell.cardImg.image = UIImage(named: "AMEX")
        }else if getdetails.cardType?.lowercased() == "discover"{
            
            cell.cardImg.image = UIImage(named: "DISCOVER")
            
        } else{
            cell.cardImg.image = UIImage(named: "card")
        }
        
        
        if selectedIndex == indexPath.row{
            cell.MainView.backgroundColor = UIColor(red: 203/255, green: 195/255, blue: 227/255, alpha: 1)
            cell.circleimg.image = UIImage(named: "radiochecked")
            
        } else {
            cell.circleimg.image = UIImage(named: "radio")
            cell.MainView.backgroundColor = .white
           
        }
        

        
        if  getdetails.txnDateTime ?? "" != "" {
            let date = convertDateFormater(getdetails.txnDateTime ?? "")
            cell.TimeLbl.text = date
        } else {
            cell.TimeLbl.text = ""
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndex = indexPath.row
        entity = cardListArray[indexPath.row]
        tableView.reloadData()
        
    }
    
}

//MARK: ITap Delegates
@available(iOS 15.4, *)
extension VoidPreAuthList: IposgoDelegate {
    
    func didReceiveError(error: String?, code: Int?)  {
        
        print(">>>>Invoke App Error:",error as Any)
        DispatchQueue.main.async { [self] in
            stopLoading()
        }
        switch nullStringToEmpty(string: error) {
            
        case nullStringToEmpty(string: Constant.NoDataFound.rawValue):
            noDataFound.isHidden = false
            noDataFound.text = nullStringToEmpty(string: error)
            return
            
        default:
            DispatchQueue.main.async { [self] in
                
                let alert = UIAlertController(title: Constant.Alert.rawValue, message: nullStringToEmpty(string: error), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: Constant.ok.rawValue, style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.readerInstance.cleanup(delegate: self)
            }
            return
        }
        
    }
    
    func didReceiveSuccessData(message: String?, responseDict: [String : Any]?) {
        
        
        print(">>> Invoke App Success:  \(String(describing: message))")
        print(">>>RESponse",responseDict as Any)
        DispatchQueue.main.async { [self] in
           
            print("data....responseDict:\(String(describing: responseDict))")
            
            if responseDict != nil || responseDict?.count ?? 0 > 0 {
                stopLoading()
                noDataFound.isHidden = true
                if selectedIndex == -1 {
                    
             
                    self.cardListArray.removeAll()
                    
                    if let dataArray = responseDict?["data"] as? [[String: Any]] {
                        
                        let entities = dataArray.map { dict -> TxDetailEntity in
                            let txName = dict["txName"] as? String ?? ""
                            let txnDateTime = dict["txnDateTime"] as? String ?? ""
                            let amount = dict["sumAmount"] as? Double ?? 0.0
                            let sumamt = String(format: "%.2f",amount)
                            let cardMaskPan = dict["cardMaskPan"] as? String ?? ""
                            let cardType = dict["cardType"] as? String ?? ""
                            let rrnCode = dict["rrnCode"] as? String ?? ""
                            let traceNo = dict["traceNo"] as? String ?? ""
                            let invoice = dict["invoice"] as? String ?? ""
                            
                            
                          
                            // Add more fields as needed
                            return TxDetailEntity(txName: txName, cardMaskPan: cardMaskPan, cardType:cardType, traceNo:traceNo, txnDateTime: txnDateTime,rrnCode:rrnCode, amount:sumamt,invoice:invoice)
                        }
                        
                        self.cardListArray = entities
                        
                        switch nullStringToEmpty(string: transactionType) {
                            
                        case Constant.ticket.rawValue:
                            let lastTXN = self.cardListArray.sorted(by: { nullStringToEmpty(string: $0.txnDateTime) > nullStringToEmpty(string:  nullStringToEmpty(string: $1.txnDateTime)) })
                            self.cardListArray = lastTXN
                           
                            
                        default:
                            let lastTXN = self.cardListArray.sorted(by: { nullStringToEmpty(string: $0.txnDateTime) > nullStringToEmpty(string:  nullStringToEmpty(string: $1.txnDateTime)) })
                            self.cardListArray.removeAll()
                            self.cardListArray.append(lastTXN.first!)
                        }
                      
                        print(">>>>dataArray",cardListArray.count)
                    }
                    
                    tableView.reloadData()
                } else {
                    
                    let VC = storyboard?.instantiateViewController(identifier: "CustomerCopyViewController") as! CustomerCopyViewController
                    VC.responseDict = responseDict
                    navigationController?.pushViewController(VC, animated: true)
                }
                
            } else {
                print("message:\(nullStringToEmpty(string: message))")
                
            }
        }
    }
}


extension VoidPreAuthList {
    
    
    func deepLinkingVoidTXN() {
        
     
        let approvalScreen = UserDefaults.standard.string(forKey: UserDefaults.Keys.isEnableShowApprovalScreen.rawValue) == "1" ? true : false
        let payload = DLVoidTxnData(rrn: nullStringToEmpty(string: entity?.rrnCode), tranType: .VOID, showApprovalScreen: approvalScreen)
        print(">>>payload",payload)
        UserDefaults.standard.set(true, forKey: UserDefaults.Keys.isFromVoidPreAuthList.rawValue)
        dlReaderInstance.startVoid(params: payload, delegate: self)
        
    }
  
}

