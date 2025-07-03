//
//  Keyin_QrPay.swift
//  IceCream
//
//  Created by Giri on 6/6/25.
//

import Foundation
import UIKit
import IposgoSDK

extension TicketViewController {
    
    
    
    @IBAction func keyin_qrPay(_ sender: UIButton) {
        // Key-in Transaction
        activityIndicator.stopAnimating()
        if tranType == .SALE || tranType == .REFUND || tranType == .PRE_AUTH {
            var payload = TxnData(amount: amtTxtFld.text ?? "", tipAmount: tip.text ?? "", currencyCode: .usd, tranType: tranType ?? .SALE,payType: .KeyIn)
            readerInstance.delegate = self
            if sender.tag == 1{
                payload.payType = .KeyIn
                payType = .KeyIn
            }else{
                payload.payType = .QR
                payType = .QR
            }
            print("External Payment Parameters: \(payload)")
            readerInstance.startTransactionExternalPayment(param: payload, hostVC: self)
        }else{
            showAlert(title: "Alert", msg: "Not applicable for Ticket and Void and Settlement")
        }
    }
}
