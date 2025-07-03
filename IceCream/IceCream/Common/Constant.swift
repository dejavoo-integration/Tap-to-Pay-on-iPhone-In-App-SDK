//
//  Constant.swift
//  IceCream
//
//  Created by Deepika on 6/5/25.
//

  
enum Constant : String {
    
    case appName = "DV Demo"
    case Registration = "Registration"
    case PreAuth = "Pre Auth"
    case Refund = "Refund"
    case Sale = "Sale"
    case registerAndProcessTransaction = "Please register and process the transaction."
    case contiueWithInApp =  "Are you sure you want to continue as InApp SDK? Then please do registration again."
    case batchSettleMsg = "Are you sure you want to settle the batch?"
    case contiueWithDL =  "Are you sure you want to continue as Deep linking SDK? Then please do registration again."
    case iposgoNotPresentInDevice = "App Not Installed in the Device!"
    case SelectTXN =  "Select TXN"
    case Configuration = "Configuration"
    case Alert = "Alert"
    case Ticket = "Ticket"
    case ticket = "ticket"
    case paymentSuccessMessage = "Your payment was successfully processed. Thank you!"
    case approval = "APPROVED"
    case cardCancelled = "Transaction canceled by the merchant/card holder"
    case enterTPN =  "Enter TPN"
    case merchantCode =  "Enter Merchant Code"
    case Proceed = "Proceed"
    case NoDataFound = "No Data Found"
    case ok = "OK"
    case Confirmation = "Confirmation"
    case cancel = "Cancel"
    case paymentDeclineMessage = "Your payment was decline with\n"
    case DECLINE = "DECLINE"
    case enterAmount = "Enter Amount"
}

enum ParamKey : String {
    
    case Spin_Response = "Spin_Response"
    case HostResponseCode = "HostResponseCode"
    case HostResponseMessage = "HostResponseMessage"
    case ExtData = "ExtData"
    case TotalAmt = "TotalAmt"
    case AcntLast4 = "AcntLast4"
    case CardType = "CardType"
    case TraceNum = "TraceNum"
    case DateTime = "DateTime"
    case RRN = "RRN"
    case txName = "txName"
    case txnDateTime = "txnDateTime"
    case sumAmount = "sumAmount"
    case cardMaskPan = "cardMaskPan"
    case cardType = "cardType"
    case rrnCode = "rrnCode"
    case traceNo = "traceNo"
    case invoice = "invoice"
    case message = "Message"
    case txnLabel = "txnLabel"
    
}


