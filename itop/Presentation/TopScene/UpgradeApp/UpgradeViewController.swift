//
//  UpgradeViewController.swift
//  itop
//
//  Created by APPLE on 10/11/22.
//

import UIKit
import Alamofire
import SwiftyJSON

class UpgradeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var downloadApp: UIButton!
    @IBOutlet weak var downloadParameter: UIButton!
    @IBOutlet weak var tpnNumber: UITextField!
    @IBOutlet weak var upgradeStackView: UIStackView!
    @IBOutlet weak var keyPad: KeyBoardPad!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cornerRadius()
        tpnNumber.delegate = self
        //setUpCardUI()
        fetchTPN()
    }
    
    
//    private func setUpCardUI() {
//        [keyPad].forEach{
//            $0?.onClickNumberBlock = {
//                //UnBlock Button Action
//                 self.blockNumberPad()
//            }
//            $0?.onClickOKBlock = {
//               //UnBlock Button Action
//                self.blockOKpad()
//           }
//            
//            $0?.onClickBackBlock = {
//               //UnBlock Button Action
//                self.blockBackPad()
//           }
//            
//        }
//    }
    
    private func blockNumberPad() {
        tpnNumber.text = keyPad.inum
    }
    
    
    
    func keyboard() {
        tpnNumber.text = keyPad.inum
        print(tpnNumber.text)
    }
    
    func fetchTPN() {
    
        let url = "https://steam.denovosystem.tech/v1/value-json"
        
        let header : HTTPHeaders = ["Authorization": "api-key QHBwLWRPd25sb0BkLVRlbXA9VDBrZW4tcGhhc2UtMQ=="]
        
        let parameter : Parameters = [
            "serialNumber": "001D0309260050",
              "manufacturerId": "Android Phone",
              "deviceModelId": "Tap On Phone",
              "applicationSignatureId": "CRDT",
              "buildNumber": 10062,
            "tpn": tpnNumber.text
            
        ]
        print(parameter)
        AF.request(url,method: .post, parameters: parameter,encoding:JSONEncoding.default ,headers: header).responseJSON { [self] response in
            print("isiLagi: \(response)")
            switch response.result {
            case .success(let data):
                print("isi: \(data)")
                let json = JSON(data)
                print(json)
      
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func cornerRadius() {
        downloadParameter.layer.cornerRadius = 20
        downloadApp.layer.cornerRadius = 20
        tpnNumber.layer.cornerRadius = 20
    }
    


}
