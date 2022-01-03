//
//  UIViewController+.swift
//  LoginScreen
//
//  Created by  Paul on 17.12.2021.
//

import UIKit

extension UIViewController
{
    /// This is a function to get first **content** (NOT child) controller of a particular type from controller. It would look recursively inside UINavigationControllers, UITabBarControllers and UISplitViewController
    func firstContentControllerOf<T : UIViewController>(type : T.Type) -> T? {
        func getContentController(for controller: UIViewController) -> T? {
            if let controller = controller as? T {
                return controller
            }
            if let navCon = controller as? UINavigationController {
                return findIn(controllers: navCon.viewControllers)
            } else if let tabCon = controller as? UITabBarController,
                      let controllers = tabCon.viewControllers  {
                return findIn(controllers: controllers)
                
            } else if let splitCon = controller as? UISplitViewController {
                return findIn(controllers: splitCon.viewControllers)
            }
            return nil
        }
        
        func findIn(controllers: [UIViewController]) -> T? {
            for controller in controllers {
                if let contentController = getContentController(for: controller) {
                    return contentController
                }
            }
            return nil
        }
        
        return getContentController(for: self)
    }
}
