//
//  DailyReportTableViewCell.swift
//  itop
//
//  Created by APPLE on 03/11/22.
//

import UIKit

class DailyReportTableViewCell: UITableViewCell {

    @IBOutlet weak var dailyReportCheckBox: UIButton!
    
    @IBOutlet weak var dailyReportList: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
