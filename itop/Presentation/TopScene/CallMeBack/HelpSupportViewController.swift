//
//  HelpSupportViewController.swift
//  itop
//
//  Created by APPLE on 20/11/22.
//

import UIKit
import CountryPickerView

class HelpSupportViewController: UIViewController,CountryPickerViewDelegate,CountryPickerViewDataSource {
    
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var frontButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleTag: UILabel!
    @IBOutlet weak var countryPicker: CountryPickerView!
    
    @IBOutlet weak var backImage: UIImageView!
    
    @IBOutlet weak var frontImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(titleTag.tag)
        cornerRadius()
        delegates()
        fetchData()
       // TapGesture()
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        TapGesture()
    }
    
    func fetchData() {
        if titleTag.tag == 0 {
            titleTag.text = "Help/Support"
        }
        
        else if titleTag.tag == 1 {
            titleTag.text = "Demo Required"
        }
        
        else if titleTag.tag == 2 {
            titleTag.text = "Network/Sim Issue"
        }
        
        else if titleTag.tag == 3 {
            titleTag.text = "Card Issue"
        }
        
        else if titleTag.tag == 4 {
            titleTag.text = "Settlement Issue"
        }
        
        
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
        frontButton.layer.cornerRadius = 20
        backButton.layer.cornerRadius = 20
        headerLabel.addShadowToTextField(color: .gray,cornerRadius:20)
    }
    
    func TapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        backImage.addGestureRecognizer(tap)
        frontImage.addGestureRecognizer(tap)
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
         
        self.dismiss(animated: true)
    }
    
    
    
    @IBAction func backPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true)
    }
    

}
