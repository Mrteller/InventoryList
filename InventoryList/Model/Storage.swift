//
//  Storage.swift
//  InventoryList
//
//  Created by ILYA BILARUS on 03.01.2022.
//

import UIKit

class Storage {
    
    var items: [InventoryItem] = [InventoryItem(name: "macbook", quantity: 1, location: "home", image: UIImage(named: "macbook")!),
                                  InventoryItem(name: "arduino nano", quantity: 30, location: "work", image: UIImage(named: "arduino-nano")!),
                                  InventoryItem(name: "esp32", quantity: 50, location: "work", image: UIImage(named: "esp32")!),
                                  InventoryItem(name: "raspberry pi 4", quantity: 1, location: "Home", image: UIImage(named: "raspberry_pi_4")!),
                                  InventoryItem(name: "iphone 13", quantity: 1, location: "Home", image: UIImage(named: "iphone_13")!)
    ]
    
    
    // add new item
    func addNewItem(item: InventoryItem) throws {
        if items.contains(where: { $0.itemName == item.itemName }) {
            throw NSError(domain: "на складе уже есть предмет с таким именем", code: 2)
        } else {
            items.append(item)
        }
    }
    
    //get item from name
    func getItem(name: String) -> InventoryItem? {
        if let index = items.firstIndex(where: { $0.itemName == name }) {
            let item = items[index]
            return item
        }
        return nil
    }
    
    
    // get quantity by name
    func removeQuantity(itemName: String, quantity: Int) throws {
        if let itemIndex = items.firstIndex(where: { $0.itemName == itemName}) {
            if items[itemIndex].quantity < quantity {
                let missingPositions = abs(items[itemIndex].quantity - quantity)
                throw NSError(domain: "нехватает \(missingPositions) шт", code: 1, userInfo: ["missingPositions": missingPositions])
            }
            items[itemIndex].quantity = items[itemIndex].quantity - 1
        } else {
            throw NSError(domain: "нет предмета с таким именем на складе", code: 3)
        }
        
    }
    
    // add quattity by name
    func addQuantity(itemName: String, quantity: Int) throws {
        if let itemIndex = items.firstIndex(where: { $0.itemName == itemName}) {
            items[itemIndex].quantity = items[itemIndex].quantity + 1
        } else {
            throw NSError(domain: "нет предмета с таким именем на складе", code: 3)
        }
        
    }
    
}


