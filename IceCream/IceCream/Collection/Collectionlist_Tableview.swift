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
        if collectionList[indexPath.row].isSelected == true{
            cell.backgroundview?.backgroundColor = UIColor(red: 203/255, green: 195/255, blue: 227/255, alpha: 1)
        }else {
            cell.backgroundview?.backgroundColor = .white
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if isSelectedCollection(){
            return 30  // Adjust height for better spacing
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear  // Custom background color
        if isSelectedCollection(){
            return footerView
        }else {
            return nil
        }
    }
    
    @objc func addcollectionAC(sender:UIButton){
        collectionList[sender.tag].collectionCount!  += 1
        collectionList[sender.tag].isSelected = true
        let indexpath = IndexPath(row: sender.tag, section: 0)
        listTable.reloadRows(at: [indexpath], with: .automatic)
        showCheckoutPrice()
    }
    
    @objc func minuscollectionAC(sender:UIButton){
        let indexpath = IndexPath(row: sender.tag, section: 0)
        if collectionList[sender.tag].collectionCount ?? 0 > 0
        {
            collectionList[sender.tag].collectionCount! -= 1
            if collectionList[sender.tag].collectionCount == 0{
                collectionList[sender.tag].isSelected = false
            }
            listTable.reloadRows(at: [indexpath], with: .fade)
        }else{
            collectionList[sender.tag].isSelected = false
        }
        showCheckoutPrice()
    }
    
    func showCheckoutPrice(){
        let totalPrice:Double = self.totalprice()
        let TAMT = String(format: "%.2f", totalPrice)
        checkoutPrice.text = "Total Price: $ \(TAMT)"
        showBottomView()
    }
    
    func showBottomView(){
        if isSelectedCollection(){
            clearButton.isHidden = false
            viewAnimation(constant: 120)
        }else{
            clearButton.isHidden = true
            viewAnimation(constant: 0)
        }
    }
    
    func viewAnimation(constant:CGFloat){
        chechoutHeightContrain.constant = constant
        UIView.animate(withDuration: 0.30, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded() // Animates constraint change
        })
    }
    
    func totalprice() -> Double {
        var total:Double = 0
        for item in collectionList {
            total += (item.price ?? 0) * Double(item.collectionCount ?? 0)
        }
        return total
    }
    
    func getisRegistered() -> Bool{
        if UserDefaults.standard.bool(forKey: UserDefaults.Keys.isRegistered.rawValue){
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
    
    func showAlertAction(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: Constant.ok.rawValue, style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            self.clearData()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
