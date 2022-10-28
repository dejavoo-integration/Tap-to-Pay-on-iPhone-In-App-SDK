//
//  SideMenuViewController.swift
//  itop
//
//  Created by APPLE on 19/10/22.
//

import UIKit
import SideMenu


class SideMenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var closeImage: UIImageView!
    
    var paymentMethod = ["VOID","REFUND", "PREAUTH", "TICKET"]
    var payementImage = ["void","refund","preauth","ticket"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate()
        subViews()
    }
    
    func delegate() {
        tableView.delegate = self
        tableView.dataSource = self
        closeImage.setImageColor(color: UIColor.white)
        closeButton.roundedButton()
    }
    
    func subViews() {
        self.view.bringSubviewToFront(closeButton)
        self.view.bringSubviewToFront(closeImage)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentMethod.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SideMenuTableViewCell
        cell.paymentImage.image = UIImage(named: payementImage[indexPath.row])
        cell.paymentImage.setImageColor(color: UIColor.white)
        cell.paymentOptions.text = paymentMethod[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0;
    }

    
    @IBAction func closeBtnPressed(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
}
