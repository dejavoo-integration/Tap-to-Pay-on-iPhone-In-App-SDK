//
//  SMSReceiptViewController.swift
//  itop
//
//  Created by APPLE on 21/10/22.
//

import UIKit
import CountryPickerView

class SMSReceiptViewController: UIViewController,CountryPickerViewDelegate,CountryPickerViewDataSource {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var smsBackBtn: UIButton!
    @IBOutlet weak var saleLbl: UILabel!
    @IBOutlet weak var backImg: UIImageView!
    @IBOutlet weak var smsBackImage: UIImageView!
    @IBOutlet weak var countryPicker: CountryPickerView!
    @IBOutlet weak var phoneNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cornerRadius()
        delegates()
    }


    func delegates() {
        countryPicker.delegate = self
        countryPicker.dataSource = self
    }
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        let selectedCountry = countryPickerView.selectedCountry
        print(selectedCountry)
    }

    func cornerRadius() {
        headerLabel.addShadowToTextField(color: .gray,cornerRadius:20)
        backButton.layer.cornerRadius  = 10
        smsBackBtn.layer.cornerRadius = 10
        backImg.setImageColor(color: UIColor.white)
        smsBackImage.setImageColor(color: UIColor.white)
    }
}
