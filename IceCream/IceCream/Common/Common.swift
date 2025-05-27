//
//  CommonStruct.swift
//  IceCream
//
//  Created by Giri on 2/11/25.
//

import Foundation
import UIKit
import IposgoSDK

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
var titlename:String?
var txnType: TransType = .SALE


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

//MARK: - Register Param
struct RegisterData : Register {
  var tpn: String
  var merchantCode: String
}

//MARK: -Sale param
struct TxnData : PayloadParameter {
  
    var amount: String
    var tipAmount: String?
    var currencyCode: CurrencyCode
    var tranType: TransType
    var email: String?
    var phoneNo: String?
}

//MARK: -Ticket param
struct TicketTxnData : TicketPayloadParameter {
    
    var amount: String
    var tipAmount: String?
    var currencyCode: CurrencyCode
    var tranType: TransType
    var rrn: String
    var email: String?
    var phoneNo: String?
    
}
//MARK: - VOID Param
struct VoidTxnData : VoidPayloadParameter {
    var rrn: String
    var tranType: TransType
    var email: String?
    var phoneNo: String?
}

//MARK: - StatusCheckPayload [Status check of TXN]
struct ReceiptParam: Receipt {
    
    var txId: String
    var phoneNo: String?
    var email: String?
    
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

