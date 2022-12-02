//
//  PageViewController.swift
//  itop
//
//  Created by APPLE on 11/11/22.
//

import UIKit

class PageViewController: UIViewController {
 
    var pageNavigationViewController  : UIPageViewController!
    lazy var viewControllers : [UIViewController] = {
        
        var redVC = UIViewController()
        
        var greenVC = UIViewController()
        
        let storyboard = UIStoryboard(name: "SettlementScreenViewController", bundle: nil)
        let settlementVC = storyboard.instantiateViewController(withIdentifier: "SettlementScreenViewController")
      
        let blueVC = UIViewController()
        blueVC.view.backgroundColor = .blue
        
        if UserDefaults.standard.bool(forKey: "cash_payment") != nil {
            redVC = UIViewController()
            redVC.view.backgroundColor = .red
        }
        
        
        if UserDefaults.standard.bool(forKey: "alter_payments") != nil {
            greenVC = UIViewController()
            greenVC.view.backgroundColor = .green
        }
        
        
        return [settlementVC , blueVC, redVC, greenVC ]
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        paginationMethod()
        
    }
    
    
    func paginationMethod() {
        pageNavigationViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        pageNavigationViewController.setViewControllers([viewControllers[0]], direction: .forward, animated: true,completion:  nil)
        
        pageNavigationViewController.dataSource = self
        
        self.addChild(pageNavigationViewController)
        self.view.addSubview(pageNavigationViewController.view)
        pageNavigationViewController.view.frame = self.view.frame
        pageNavigationViewController.didMove(toParent: self)
    }


}


extension PageViewController : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let index = viewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let reducedIndex = index - 1
        
        guard reducedIndex >= 0 else {
            return nil
        }
        
        guard viewControllers.count > reducedIndex else {
            return nil
        }
        
        return viewControllers[reducedIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        
        guard let index = viewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let reducedIndex = index + 1
        
        guard reducedIndex >= 0 else {
            return nil
        }
        
        guard viewControllers.count > reducedIndex else {
            return nil
        }
        
        return viewControllers[reducedIndex]

    }
    
    
}
