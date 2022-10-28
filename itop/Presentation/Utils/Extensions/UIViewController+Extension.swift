//
//  UIViewController+Extension.swift
//  itop
//
//  Created by meganathan on 27/07/22.
//  Copyright © 2022 meganathan. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    typealias Parameters = [String: Any]
    
    /*Dismiss or Pop back*/
    func dismissVC(){
        if (self.presentingViewController != nil){
            self.dismiss(animated: true, completion: nil)
        }else{
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    func addChildViewControllerWithView(_ childViewController: UIViewController, toView view: UIView? = nil) {
        let view: UIView = view ?? self.view
        childViewController.removeFromParent()
        childViewController.willMove(toParent: self)
        addChild(childViewController)
        childViewController.didMove(toParent: self)
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(childViewController.view)
        view.addConstraints([
            NSLayoutConstraint(item: childViewController.view!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: -10),
            NSLayoutConstraint(item: childViewController.view!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: childViewController.view!, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: childViewController.view!, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        ])
        view.layoutIfNeeded()
    }
    
    func removeChildViewController(_ childViewController: UIViewController) {
        childViewController.removeFromParent()
        childViewController.willMove(toParent: nil)
        childViewController.removeFromParent()
        childViewController.didMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        view.layoutIfNeeded()
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: Nav bar related
extension UIViewController {
    func setupNavBar() {
        let backImage = #imageLiteral(resourceName: "back_icon")
        let backBarButton = UIBarButtonItem.init(image: backImage, style: .plain, target: self, action: #selector(navigateToPreviousViewController))
        navigationItem.leftBarButtonItem = backBarButton
        //navigationController?.navigationBar.tintColor = UIColor.setColour(colour: .green)
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func hideUnhideNavBar(isHidden: Bool) {
        navigationController?.setNavigationBarHidden(isHidden, animated: true)
        navigationController?.navigationBar.isHidden = isHidden
    }
    
    @objc func navigateToPreviousViewController() {
        navigationController?.popViewController(animated: true)
    }
}

/*Extension of Controller to present Alert*/
extension UIViewController {

    /*Generic class for Alert*/
    func alertWithNoAction(title : String = "Error"){
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            self.present(alertController, animated: true) {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5){
                    alertController.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}

//MARK: Generic Alert
/** Extension to show Generic Message Alert Controller throughout the App **/
extension UIViewController{
    enum AlertTitle: String{
        case Success = "Success"
        case Error = "Error"
        case Alert = "Alert"
        case AppName = "TOP"
    }
    
    func showMessageAlert(title: String = AlertTitle.AppName.rawValue, message: String?, showRetry: Bool = true, retryTitle: String? = nil, showCancel: Bool = true, cancelTitle: String? = nil, onRetry: (() -> ())?, onCancel: (() -> ())?){
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            if showRetry{
                alertController.addAction(UIAlertAction(title: retryTitle ?? "Retry", style: .default, handler: { (retry) in
                    guard let onRetry = onRetry else{
                        return
                    }
                    onRetry()
                }))
            }
            if showCancel{
                alertController.addAction(UIAlertAction(title: cancelTitle ?? "Cancel", style: .cancel, handler: { (cancel) in
                    guard let onCancel = onCancel else{
                        return
                    }
                    onCancel()
                }))
            }
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension Notification.Name {
    static let appTimeout = Notification.Name("appTimeout")
}
