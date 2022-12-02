///
//  KeyBoardPad.swift
//  iTop
//
//  Created by meganathan on 08/08/22.
//

import UIKit

class KeyBoardPad: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet var contentView: UIView!
    
    var onClickNumberBlock:(() -> ())?
    var onClickOKBlock:(() -> ())?
    var onClickBackBlock:(() -> ())?
    @IBOutlet weak var btnnumber: RoundButton!
    @IBOutlet weak var btnAmountBack: RoundButton!
    @IBOutlet weak var btnOk: RoundButton!
    var runningnumber = ""
    var inum = ""
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        commonInit()
    }
    required init(coder aDecoder:NSCoder)
    {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    @IBAction func numberPressed(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "upgradeApp") == true {
            runningnumber = "\(sender.tag)"
            print(runningnumber)
        }
        else {
            if runningnumber.count <= 10
            {
                runningnumber += "\(sender.tag)"
                inum = "\(Double(Float(runningnumber)!))"
                print ("Value:" + "\(inum)")
                
            }
        }
        onClickNumberBlock?()
    
    }
    
    private func commonInit()
    {
        Bundle.main.loadNibNamed("KeyBoardPad", owner: self, options: nil)
       // setupUI()
        clear()
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        
    }
    
    
    public func clear()
    {
        runningnumber = ""
        inum = ""
    }
    
    @IBAction func btnActionBack(_ sender: Any) {
        onClickBackBlock?()
    }
    
    @IBAction func btnActionOk(_ sender: Any) {
        onClickOKBlock?()
    }
    
//    private func setupUI(){
//        [self.btnnumber].forEach{
//            $0?.addTarget(self, action: #selector(BtnNumberAction), for: .touchUpInside)
//
//        }
//    }
    
    @IBAction func btnNumber() {
        onClickNumberBlock?()
    }
    
    @objc private func BtnNumberAction()
    {
        onClickNumberBlock?()
    }
}
