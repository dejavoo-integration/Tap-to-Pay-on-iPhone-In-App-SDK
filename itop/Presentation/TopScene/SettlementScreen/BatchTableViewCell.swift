//
//  BatchTableViewCell.swift
//  itop
//
//  Created by APPLE on 15/11/22.
//

import UIKit

class BatchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var batchType: UIStackView!
    
    @IBOutlet weak var batchTRN: UIButton!
    
    @IBOutlet weak var batchTypeBtn: UIButton!
    
    @IBOutlet weak var batchAmount: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
