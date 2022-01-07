//
//  HomeViewController.swift
//  InventoryList
//
//  Created by  Paul on 28.12.2021.
//

import UIKit

class HomeViewController: UITabBarController {
    // MARK: - Public vars
    
    var storage = Storage()
    
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataIntoControllers()
    }
    
    // MARK: - Private funcs
    
    private func loadDataIntoControllers() {
        guard let viewControllers = viewControllers else {return }
        for viewController in viewControllers {
            if let navigationVC = viewController as? UINavigationController {
                if let itemsVC = navigationVC.topViewController as? ItemsViewController {
                    itemsVC.storage = storage
                } else if let trashVC = navigationVC.topViewController as? TrashViewController {
                    trashVC.storage = storage
                }
            }
        }
    }
}

//guard let tabBarController = segue.destination as? UITabBarController else { return }
//guard let viewControllers = tabBarController.viewControllers else { return }
//
//for viewController in viewControllers {
//    if let welcomeVC = viewController as? WelcomeViewController {
//        welcomeVC.user = user
//    } else if let navigationVC = viewController as? UINavigationController {
//        let aboutUserVC = navigationVC.topViewController as! AboutMeViewController
//        aboutUserVC.user = user
//    }
//}
