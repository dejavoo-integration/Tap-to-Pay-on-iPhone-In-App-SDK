//
//  MenuTableViewCell.swift
//  IceCream
//
//  Created by Giri on 2/4/25.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    @IBOutlet weak var titlelb:UILabel!
    @IBOutlet weak var imagetitle:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
