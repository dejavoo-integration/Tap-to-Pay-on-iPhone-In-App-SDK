//
//  ConfigurationCell.swift
//  IceCream
//
//  Created by Deepika on 5/28/25.
//

import UIKit

class ConfigurationCell: UITableViewCell {

    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
