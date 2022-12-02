//
//  SummaryReportTableViewCell.swift
//  itop
//
//  Created by APPLE on 03/11/22.
//

import UIKit

class SummaryReportTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var checkBoxButton: UIButton!
    
    @IBOutlet weak var summaryReportList: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
