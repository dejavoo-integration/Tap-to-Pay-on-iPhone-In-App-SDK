//
//  UpgradeAppViewController.swift
//  itop
//
//  Created by APPLE on 17/11/22.
//

import UIKit

class UpgradeAppViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tpnNumber: UILabel!
    @IBOutlet weak var textOne: UITextField!
    @IBOutlet weak var textTwo: UITextField!
    @IBOutlet weak var textThree: UITextField!
    @IBOutlet weak var textFour: UITextField!
    @IBOutlet weak var keyPad: KeyBoardPad!
    @IBOutlet weak var closeImage: UIImageView!
    
    var otpCode : String = ""
    var runningNumber  = "" 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCard()
        cornerRadius()
        otpSelector()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tapGesture()
    }
    
    
    func cornerRadius() {
        passwordView.layer.cornerRadius  = 15
        passwordView.layer.borderWidth = 2.0
        passwordView.layer.borderColor = UIColor.white.cgColor
        passwordView.layer.borderColor = UIColor(hexString: "#256373").cgColor
        passwordLabel.layer.cornerRadius = 10
        passwordLabel.layer.masksToBounds = true
        UserDefaults.standard.set(true, forKey: "upgradeApp")
        closeImage.setImageColor(color: UIColor.white)
    }
    
    func tapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
           closeImage.isUserInteractionEnabled = true
           closeImage.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.dismiss(animated: true)
    }
    
    func keyPadLogic() {
        runningNumber = ""
        keyPad.clear()
        textOne.text = ""
    }
    
    func setUpCard() {
        [keyPad].forEach {
            $0?.onClickNumberBlock = {
                self.blockNumberPad()
            }
        }
    }
    
    private func blockNumberPad() {
//        textOne.text = keyPad.runningnumber
//        textTwo.becomeFirstResponder()
        otpSelector()
       
    }
   
    
     func otpSelector() {
        textOne.delegate = self
        textTwo.delegate = self
        textThree.delegate = self
        textFour.delegate = self
        textOne.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        textTwo.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        textThree.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        textFour.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange(textField: UITextField){
       var text = textField.text
        text = keyPad.runningnumber
        print(text)
        
        let finalOutput = "\(textOne.text!)\(textTwo.text!)\(textThree.text!)\(textFour.text!)"
        otpCode = finalOutput
        
        
        if  text?.count == 1 {
        switch textField{
        case textOne:
              textTwo.becomeFirstResponder()
        case textTwo:
              textThree.becomeFirstResponder()
        case textThree:
              textFour.becomeFirstResponder()
        case textFour:
              textFour.resignFirstResponder()
                default:
                    break
                }
            }
        else if text?.count == 0 {
                switch textField{
                case textFour:
                    textThree.becomeFirstResponder()
                case textThree:
                    textTwo.becomeFirstResponder()
                case textTwo:
                    textOne.becomeFirstResponder()
                default:
                    break
                }
            }
            else{

            }
        
        }
    
    @IBAction func closeBtn(_ sender: UIButton) {
        
        
    }
}
