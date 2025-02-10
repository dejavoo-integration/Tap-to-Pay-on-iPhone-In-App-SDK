//
//  MenuViewController.swift
//  IceCream
//
//  Created by Giri on 2/4/25.
//

import UIKit

protocol isClickMenuPassData{
    func passData(data:MenuItem)
}
class MenuViewController: UIViewController {
var MenuItems : [MenuItem] = []
    @IBOutlet weak var tableview:UITableView!
    @IBOutlet var shadowView: UIView!
    var menuDelegate : isClickMenuPassData?
    override func viewDidLoad() {
        super.viewDidLoad()
        MenuItems = [MenuItem(title: "Registration",image: "list.clipboard.fill"),
                     MenuItem(title: "Sale",image: "dollarsign.circle.fill"),
                     MenuItem(title: "Refund",image: "dollarsign.circle.fill"),
                     MenuItem(title: "PreAuth",image: "dollarsign.circle.fill"),
                     MenuItem(title: "Void",image: "ticket.fill"),
                     MenuItem(title: "Ticket",image: "ticket.fill"),
                     MenuItem(title: "Logout",image: "rectangle.portrait.and.arrow.right.fill")]
    }
    
    @IBAction func closeAc(_ sender: Any){
        removeview()
    }
    
    func removeview(selectedEntity:MenuItem? = nil){
        dismiss(animated: true) {
            
            UIView.animate(withDuration: 0.3, animations: { ()->Void in
                self.view.frame = CGRect(x: -screenWidth, y: 0, width: screenWidth, height: screenHeight)
            })  {(finisheh) in
                self.view.removeFromSuperview()
                self.menuDelegate?.passData(data: selectedEntity ?? MenuItem(title: ""))
            }
        }
    }

}

extension MenuViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "menucell", for: indexPath) as! MenuTableViewCell
        cell.titlelb.text = MenuItems[indexPath.row].title
        cell.imagetitle.image = UIImage(systemName: MenuItems[indexPath.row].image ?? "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        removeview(selectedEntity: MenuItems[indexPath.row])
    }
    
}


struct MenuItem {
    var title: String
    var image: String?
}
