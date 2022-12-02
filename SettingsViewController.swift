//
//  SettingsViewController.swift
//  itop
//
//  Created by APPLE on 21/11/22.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var settings = ["NFC Zone", "SPIN", "Comm Setup","Host Setup","Keyboard", "Language & Theme", "Change Password", "About App"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewDelegate()
        
    }
    
    func tableViewDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "settings") as? SettingsTableViewCell
        cell?.settingOptions.text = settings[indexPath.row]
        return cell!
        
    }
}
