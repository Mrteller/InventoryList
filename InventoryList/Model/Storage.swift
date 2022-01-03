//
//  Storage.swift
//  InventoryList
//
//  Created by ILYA BILARUS on 03.01.2022.
//

import UIKit

class Storage {

    var items: [String: InventoryItem] = [
        "macbook": InventoryItem(name: "macbook", quantity: 1, location: "home", image: UIImage(named: "macbook")!),
        "arduino-nano" :InventoryItem(name: "arduino nano", quantity: 30, location: "work", image: UIImage(named: "arduino-nano")!),
        "esp32": InventoryItem(name: "esp32", quantity: 50, location: "work", image: UIImage(named: "esp32")!),
        "raspberry_pi_4": InventoryItem(name: "raspberry pi 4", quantity: 1, location: "Home", image: UIImage(named: "raspberry_pi_4")!),
        "iphone_13": InventoryItem(name: "iphone 13", quantity: 1, location: "Home", image: UIImage(named: "iphone_13")!)
    ]
    
    
    func addNewItem(item: InventoryItem) throws {
        if let _ = items[item.itemName] {
            throw StorageError.storageHasThisItemName
        } else {
            items[item.itemName] = item
        }
    }
    
    
    func removeQuantity(itemName: String, quantity: Int) throws {
        if let oldItem = items[itemName] {
            oldItem.quantity = oldItem.quantity - quantity
            if oldItem.quantity < 0 {
                throw StorageError.itemsLessThan(deficiency: abs(oldItem.quantity))
            }
            items.updateValue(oldItem, forKey: oldItem.itemName)
        } else {
            throw StorageError.notFindItem
        }
    }
    
    func addQuantity(itemName: String, quantity: Int) throws {
        if let oldItem = items[itemName] {
            oldItem.quantity = oldItem.quantity + quantity
            items.updateValue(oldItem, forKey: oldItem.itemName)
        } else {
            throw StorageError.notFindItem
        }
    }
    
}


enum StorageError: Error {
    case itemsLessThan(deficiency: Int)
    case notFindItem
    case storageHasThisItemName
}
