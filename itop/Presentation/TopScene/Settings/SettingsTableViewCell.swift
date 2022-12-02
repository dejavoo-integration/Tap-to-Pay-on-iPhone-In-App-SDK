//
//  SettingsTableViewCell.swift
//  itop
//
//  Created by APPLE on 21/11/22.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var settingsIcon: UIImageView!
    @IBOutlet weak var settingOptions: UILabel!
    @IBOutlet weak var forwardButton: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
