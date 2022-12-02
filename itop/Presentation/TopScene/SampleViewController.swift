//
//  SampleViewController.swift
//  itop
//
//  Created by APPLE on 07/11/22.
//

import UIKit

class SampleViewController: UIViewController {
    @IBOutlet weak var btnOne: UIButton!
    @IBOutlet weak var btnTwo: UIButton!
    @IBOutlet weak var btnThree: UIButton!
    @IBOutlet weak var btnFour: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var mainViewBtn: UIButton!
    
    var timer : Timer = Timer()
    var countNumber = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
    }
    
    func TapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        mainViewBtn.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
    }
    
    func startTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(runTimeCode), userInfo: nil, repeats: true)
    }
    
    @objc func runTimeCode() -> Void {
        countNumber = countNumber + 1
        print(countNumber)
        timerLabel.text = "\(countNumber)"
    }
    

    @IBAction func btnOneClicked(_ sender: UIButton) {
        timer.invalidate()
        countNumber = 0
        startTimer()
    }
    
    
    
    @IBAction func btnTwoClicked(_ sender: UIButton) {
        timer.invalidate()
        countNumber = 0
        startTimer()
    }
    
    @IBAction func btnThreeClicked(_ sender: UIButton) {
        timer.invalidate()
        countNumber = 0
        startTimer()
    }
    
    
    @IBAction func btnFourClicked(_ sender: UIButton) {
        timer.invalidate()
        countNumber = 0
        startTimer()


    }
    
    
    @IBAction func mainViewBtnClicked(_ sender: UIButton) {
        timer.invalidate()
        countNumber = 0
        startTimer()
    }
    
}
