//
//  SideMenuTableViewCell.swift
//  itop
//
//  Created by APPLE on 19/10/22.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {


    @IBOutlet weak var paymentImage: UIImageView!
    
    @IBOutlet weak var paymentOptions: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
