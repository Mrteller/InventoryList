//
//  HomeViewController.swift
//  InventoryList
//
//  Created by  Paul on 28.12.2021.
//

import UIKit

class HomeViewController: UITabBarController {
    
    // MARK: - Private vars
    
    private let storage = Storage()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataIntoControllers()
        
        // получаем предмет по имени
        if let item = storage.getItem(name: "macbook") {
            print (item)
        }
        
        // пытаемся взять со склада 6 макбуков, хотя на складе только 1 шт, выведет ошибку, что не хватает 5 шт
        do {
            try storage.removeQuantity(itemName: "macbook", quantity: 6)
        } catch {
            let error = (error as NSError)
            print(error.localizedDescription)
            print(error.userInfo["missingPositions"] as! Int) // можно получить недостающее количество
        }
        
        // пытаемся добавить новый предмет на склад в количестве 1000 штук
        do {
        try storage.addNewItem(item: InventoryItem(name: "star", quantity: 1000, location: "home", image: UIImage(systemName: "star.fill")!))
        } catch {
            print(error.localizedDescription)
        }
        
        // получаем предмет по имени
        if let item = storage.getItem(name: "star") {
            print (item)
        }
        
        //добавляем больше макбуков на склад
        do {
            try storage.addQuantity(itemName: "macbook", quantity: 10)
        } catch {
            print(error.localizedDescription)
        }
        
        
        
    }
    
    // MARK: - Private funcs
    
    private func loadDataIntoControllers() {
        if let itemsController = firstContentControllerOf(type: ItemsViewController.self)  {
            itemsController.items = storage.items
        }
    }
    
}

