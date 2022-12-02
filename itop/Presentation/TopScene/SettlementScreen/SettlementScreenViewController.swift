//
//  SettlementScreenViewController.swift
//  itop
//
//  Created by APPLE on 27/10/22.
//

import UIKit
import Alamofire
import SwiftyJSON

class SettlementScreenViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    @IBOutlet weak var batchView: UIView!
    @IBOutlet weak var summaryTitle: UILabel!
    @IBOutlet weak var settleBtn: UIButton!
    @IBOutlet weak var batchTableView: UITableView!
    @IBOutlet weak var batchNumber: UILabel!
    @IBOutlet weak var tipNumber: UILabel!
    @IBOutlet weak var withoutTip: UILabel!
    @IBOutlet weak var feeNumber: UILabel!
    @IBOutlet weak var withoutFee: UILabel!
    @IBOutlet weak var batchStackView: UIStackView!
    
    var summaryAmount : [Int] = []
    var summaryType : [String] = []
    var summaryTransaction : [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cornerRadius()
        delegateMethod()
        fetchData()
    }
        
    func delegateMethod() {
        batchTableView.delegate = self
        batchTableView.dataSource = self
    }
    
    func cornerRadius() {
        summaryTitle.addShadowToTextField(cornerRadius: 20)
        settleBtn.layer.cornerRadius = 20
        batchView.layer.cornerRadius = 10
        batchStackView.layer.cornerRadius = 10
        //batchView.dropShadow()
    }
    
    func fetchData() {
        if UserDefaults.standard.string(forKey: "batchNumber") != nil {
            batchNumber.text = "Batch" + UserDefaults.standard.string(forKey: "batchNumber")!
        }
        if UserDefaults.standard.string(forKey: "withoutFee") != nil {
            withoutFee.text = "$" + UserDefaults.standard.string(forKey: "withoutFee")!
        }
        if UserDefaults.standard.string(forKey: "Fee") != nil {
            feeNumber.text = "$" + UserDefaults.standard.string(forKey: "Fee")!
        }
        if UserDefaults.standard.string(forKey: "withoutTip") != nil {
            withoutTip.text = "$" + UserDefaults.standard.string(forKey: "withoutTip")!
        }
        if UserDefaults.standard.string(forKey: "Tip") != nil {
            tipNumber.text = "$" + UserDefaults.standard.string(forKey: "Tip")!
        }
    }
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return summaryType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = batchTableView.dequeueReusableCell(withIdentifier: "batchcell", for: indexPath) as? BatchTableViewCell
        
        cell?.batchAmount.setTitle("\(summaryAmount[indexPath.row])", for: .normal)
        
        cell?.batchTypeBtn.setTitle("\(summaryType[indexPath.row])", for: .normal)
        
        cell?.batchTRN.setTitle("\(summaryTransaction[indexPath.row])", for: .normal)
        return cell!
    }
}

extension UIView {
    
}
