//
//  ListTableViewCell.swift
//  IceCream
//
//  Created by Giri on 2/3/25.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionName:UILabel!
    @IBOutlet weak var collectionPrice:UILabel!
    @IBOutlet weak var backgroundview: UIView?
    @IBOutlet weak var collectionImg:UIImageView!
    @IBOutlet weak var stepperview: UIView?
    @IBOutlet weak var addCollectionbut:UIButton!
    @IBOutlet weak var minusCollectionbut:UIButton!
    @IBOutlet weak var collectioncounttext:UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundview?.layer.cornerRadius = 9
        backgroundview?.dropShadow(scale: true)
        collectionImg.layer.cornerRadius = 9
        collectionImg.layer.borderWidth = 1
        collectionImg.layer.borderColor = UIColor.lightGray.cgColor
        stepperview?.layer.borderWidth = 0.5
        stepperview?.layer.cornerRadius = 4
        stepperview?.layer.borderColor = UIColor.systemPurple.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 1
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
