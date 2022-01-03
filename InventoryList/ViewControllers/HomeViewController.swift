//
//  HomeViewController.swift
//  ContactsTableView
//
//  Created by  Paul on 28.12.2021.
//

import UIKit

class HomeViewController: UITabBarController {
    
    
    let storage = Storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try storage.addNewItem(item: InventoryItem(name: "Звезда", quantity: 2, location: "home", image: UIImage(systemName: "star.fill")!))
        } catch {
            print("товар с таким именем существует, добавить не возможно")
        }
        
    }
    
}

