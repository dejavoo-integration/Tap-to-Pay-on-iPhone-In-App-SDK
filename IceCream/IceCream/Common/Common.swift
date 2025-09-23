//
//  CommonStruct.swift
//  IceCream
//
//  Created by Giri on 2/11/25.
//

import Foundation
import UIKit
import IposgoSDK
import DeepLinking

//This typealias is not required when you intergrate Anyone version of SDK in your Name. You can directly access the struct as per mentioned in intergration Documents.
//https://docs.ipospays.com/tap-to-pay-on-iphone
typealias InAppRegisterData = IposgoSDK.Register
typealias DLRegisterData = DeepLinking.Register

typealias DeepLinkTransType = DeepLinking.TransType
typealias InAppTransType = IposgoSDK.TransType


typealias InAppPayloadParameter = IposgoSDK.PayloadParameter
typealias InAppPayTicketPayloadParameter = IposgoSDK.TicketPayloadParameter
typealias InAppVoidPayloadParameter = IposgoSDK.VoidPayloadParameter

typealias DLPayloadParameter = DeepLinking.PayloadParameter
typealias DLTicketPayloadParameter = DeepLinking.TicketPayloadParameter
typealias DLVoidPayloadParameter = DeepLinking.VoidPayloadParameter


let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
var titlename:String?
var txnType: InAppTransType = .SALE
var dlTxnType: DeepLinkTransType = .SALE






struct CollectionList {
    let collectionName:String?
    let collectionImage:String?
    var collectionCount:Int?
    var price:Double?
    var isSelected:Bool?
}

struct MenuItem {
    var title: String
    var image: String?
}

//MARK: - In App Register Param
struct RegisterData : InAppRegisterData {
  var tpn: String
  var merchantCode: String
}

//MARK: - DL Register Param
struct DeepLinkingRegisterData : DLRegisterData {
  var tpn: String
  var merchantCode: String
}



//MARK: -In App Sale param
struct TxnData : InAppPayloadParameter {
    var Linkexpiry: IposgoSDK.LinkExpiry?
    
  
    var amount: String
    var tipAmount: String?
    var currencyCode: IposgoSDK.CurrencyCode
    var tranType: IposgoSDK.TransType
    var email: String?
    var phoneNo: String?
    var payType: PaymentMethod?
    var description: String?
    var referenceNo: String?
}

//MARK: - DL Sale param
struct DLTxnData : DLPayloadParameter {
    var amount: String
    var feeAmount: String?
    var tipAmount: String?
    var currencyCode:DeepLinking.CurrencyCode
    var tranType: DeepLinking.TransType
    var showTipScreen: Bool?
    var showBreakUpScreen: Bool?
    var showApprovalScreen: Bool?
}

//MARK: -InApp Ticket param
struct TicketTxnData : InAppPayTicketPayloadParameter {
    var Linkexpiry: IposgoSDK.LinkExpiry?
    
    var amount: String
    var tipAmount: String?
    var currencyCode: IposgoSDK.CurrencyCode
    var tranType: IposgoSDK.TransType
    var rrn: String
    var email: String?
    var phoneNo: String?
    var payType: PaymentMethod?
    var description: String?
    var expiryLinkDate: String?
    var referenceNo: String?
    
}

//MARK: - DL Ticket param
struct DLTicketTxnData : DLTicketPayloadParameter {
    var amount: String?
    var feeAmount: String?
    var tipAmount: String?
    var currencyCode: DeepLinking.CurrencyCode
    var tranType: DeepLinking.TransType
    var rrn: String
    var showTipScreen: Bool?
    var showBreakUpScreen: Bool?
    var showApprovalScreen: Bool?
}

//MARK: - VOID Param
struct VoidTxnData : InAppVoidPayloadParameter {
    var rrn: String
    var tranType: IposgoSDK.TransType
    var email: String?
    var phoneNo: String?
    var description: String?
    var expiryLinkDate: String?
    var referenceNo: String?
    var Linkexpiry: IposgoSDK.LinkExpiry?
}

//MARK: - VOID Param
struct DLVoidTxnData : DLVoidPayloadParameter {
    var rrn: String
    var tranType: DeepLinking.TransType
    var showApprovalScreen: Bool?
}



//Alert function in shared class
extension UIViewController {
    func showAlert(title: String, msg: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Constant.ok.rawValue, style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

public func calculateAmountto100_String(_ value:String) -> String?{
    let amountdoble = Double(value) ?? 0.0
    let roundvalue = String(format: "%.2f", amountdoble).doubleValue
    let amount = roundvalue * 100
    let damount = amount.rounded(digits: 2).nextUp
    
    return "\(damount.toInt() ?? 0)"
}

extension String {
    var doubleValue: Double {
        return (self as NSString).doubleValue
    }
}

extension Double {
    func rounded(digits: Int) -> Double {
        let multiplier = pow(10.0, Double(digits))
        return (self * multiplier).rounded() / multiplier
    }
}

extension Double {
    func toInt() -> Int? {
        if self >= Double(Int.min) && self < Double(Int.max) {
            return Int(self)
        } else {
            return nil
        }
    }
    
}

extension Double {
    var dollarString:String {
        return String(format: "%.2f", self)
    }
}

public func convertDateFormater(_ date: String) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYYMMddHHmmss"
    guard let date = dateFormatter.date(from: date) else { return "" }
    dateFormatter.dateFormat = "MM dd YYYY HH:mm:ss"
    return  dateFormatter.string(from: date)

}

struct TxDetailEntity {
  var txName : String?
  var txnCode : Int?
  var txnType : Int?
  var cardMaskPan : String?
  var cardType : String?
  var traceNo : String?
  var batchNo : String?
  var txnDateTime : String?
  var rrnCode : String?
  var amount : String?
  var txnId : String?
  var host_txn_id : String?
  var invoice : String?
    var imagebase64:String?
    var feedbackQustion:String?
    var itemDetails:String?
    var customField:String?
    var inventoryItems:String?
    var isibs:Bool?
}


//MARK:- Defaults Keys
extension UserDefaults {
    
    enum Keys : String, CaseIterable {
       
        case inAppSDKVersion = "inAppSDKVersion"
        case deepLinkingVersion = "deepLinkingVersion"
        case isEnableShowApprovalScreen = "isEnableShowApprovalScreen"
        case isEnableShowBreakupScreen = "isEnableShowBreakupScreen"
        case isEnableShowTipScreen = "isEnableShowTipScreen"
        case lastTransaction = "lastTransaction"
        case termsConditionsAccepted = "termsConditionsAccepted"
        case isRegistered = "isRegistered"
        case deviceReadyStatus = "Device is ready for tap to pay now"
        case isFromVoidPreAuthList = "isFromVoidPreAuthList"
        case tpn = "tpn"
        case merchantCode = "merchantCode"
    }
   
    //MARK:- Deleting all the values from the UserDefaults
    func reset() {
        Keys.allCases.forEach { removeObject(forKey: $0.rawValue) }
    }

}

//MARK:- Checking nil from given string
public func nullStringToEmpty(string: String?) -> String {
    
    if string == nil {
        return ""
    }
    else {
        return string ?? ""
    }
}

