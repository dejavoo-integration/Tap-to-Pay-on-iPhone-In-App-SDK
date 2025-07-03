//
//  VoidTicketTableViewCell.swift
//  IPOSGO
//
//  Created by Deepika on 19/11/23.
//

import UIKit

class VoidTicketTableViewCell: UITableViewCell {

    
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var AmountLbl: UILabel!
    @IBOutlet weak var TimeLbl: UILabel!
  
    @IBOutlet weak var circleimg: UIImageView!
    
    
    @IBOutlet weak var trantypelb: UILabel!
    @IBOutlet weak var last4cardNumlb: UILabel!
    @IBOutlet weak var cardImg: UIImageView!
    @IBOutlet weak var tranidlb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       // MainView.layer.shadowOpacity = 1
        //MainView.layer.shadowOffset = .zero
        //MainView.layer.shadowRadius = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
