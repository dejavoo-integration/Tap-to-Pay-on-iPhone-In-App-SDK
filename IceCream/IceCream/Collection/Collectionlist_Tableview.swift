//
//  collectionlist_Tableview.swift
//  IceCream
//
//  Created by Giri on 2/10/25.
//

import Foundation
import UIKit


extension CollectionListVC: UITableViewDataSource,UITableViewDelegate {
    func cellRegister(){
        listTable.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "listcell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTable.dequeueReusableCell(withIdentifier: "listcell", for: indexPath) as! ListTableViewCell
        cell.collectionName.text = collectionList[indexPath.row].collectionName
        cell.collectionImg.image = UIImage(named: collectionList[indexPath.row].collectionImage ?? "")
        cell.addCollectionbut.tag = indexPath.row
        cell.addCollectionbut.addTarget(self, action: #selector(addcollectionAC(sender:)), for: .touchUpInside)
        cell.minusCollectionbut.tag = indexPath.row
        cell.minusCollectionbut.addTarget(self, action: #selector(minuscollectionAC(sender:)), for: .touchUpInside)
        cell.collectioncounttext.text = "\(collectionList[indexPath.row].collectionCount ?? 0)"
        cell.collectionPrice.text = "$ \(collectionList[indexPath.row].price ?? 0)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(collectionList)
    }
    
    @objc func addcollectionAC(sender:UIButton){
        collectionList[sender.tag].collectionCount!  += 1
        collectionList[sender.tag].isSelected = true
        listTable.reloadData()
        showCheckoutPrice()
    }
    
    @objc func minuscollectionAC(sender:UIButton){
        if collectionList[sender.tag].collectionCount ?? 0 > 0
        {
            collectionList[sender.tag].collectionCount! -= 1
            listTable.reloadData()
            
            if collectionList[sender.tag].collectionCount == 0{
                collectionList[sender.tag].isSelected = false
            }
        }
        showCheckoutPrice()
    }
    
    func showCheckoutPrice(){
        let totalPrice:Double = self.totalprice()
        print("總共花費:\(totalPrice)")
        checkoutPrice.text = "Total Price: $ \(totalPrice)"
        showBottomView()
    }
    
    func showBottomView(){
        if isSelectedCollection(){
            chechoutHeightContrain.constant = 120
        }else{
            chechoutHeightContrain.constant = 0
        }
    }
    
    
    func totalprice() -> Double {
        var total:Double = 0
        for item in collectionList {
            total += (item.price ?? 0) * Double(item.collectionCount ?? 0)
        }
        return total
    }
    
    func getisRegistered() -> Bool{
        if UserDefaults.standard.bool(forKey: "isRegistered"){
            return true
        }else{
            return false
        }
        
    }
    
    func isSelectedCollection() -> Bool{
        if collectionList.filter({$0.isSelected == true}).count > 0{
            return true
        }else{
            return false
        }
    }
    
}

struct CollectionList {
    let collectionName:String?
    let collectionImage:String?
    var collectionCount:Int?
    var price:Double?
    var isSelected:Bool?
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
