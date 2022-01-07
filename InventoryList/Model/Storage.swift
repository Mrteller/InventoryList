//
//  Storage.swift
//  InventoryList
//
//  Created by ILYA BILARUS on 03.01.2022.
//

import UIKit

class Storage {
    
    var items: [InventoryItem] = [InventoryItem(name: "macbook", quantity: 1, location: "home", image: UIImage(named: "macbook")!, sku: "00001"),
                                  InventoryItem(name: "arduino nano", quantity: 30, location: "work", image: UIImage(named: "arduino-nano")!, sku: "00002"),
                                  InventoryItem(name: "esp32", quantity: 50, location: "work", image: UIImage(named: "esp32")!,sku: "00003"),
                                  InventoryItem(name: "raspberry pi 4", quantity: 1, location: "home", image: UIImage(named: "raspberry_pi_4")!, sku: "00004"),
                                  InventoryItem(name: "iphone 13", quantity: 1, location: "home", image: UIImage(named: "iphone_13")!,sku: "00005")
    ]
    
    
    var trashItems: [InventoryItem] = []
    
    // add new item
    func addNewItem(item: InventoryItem) throws {
        if items.contains(where: { $0.sku == item.sku }) {
            throw NSError(domain: "на складе уже есть предмет с таким SKU", code: 2)
        } else {
            items.append(item)
        }
    }
    
    //get item from SKU
    func getItem(sku: String) -> InventoryItem? {
        if let index = items.firstIndex(where: { $0.sku == sku }) {
            let item = items[index]
            return item
        } else if let index = trashItems.firstIndex(where: { $0.sku == sku }) {
            let item = trashItems[index]
            return item
        }
        return nil
    }
    
    //get item from SKU
    func editItem(sku: String, editedItem: InventoryItem) {
        if let index = items.firstIndex(where: { $0.sku == sku }) {
            items[index] = editedItem
        } else if let index = trashItems.firstIndex(where: { $0.sku == sku }) {
            trashItems[index] = editedItem
        }
    }
    
    // get quantity by SKU
    func removeQuantity(sku: String, quantity: Int) throws {
        guard let itemIndex = items.firstIndex(where: { $0.sku == sku}) else {
            throw NSError(domain: "нет предмета с таким SKU на складе", code: 3)
        }
        if items[itemIndex].quantity < quantity {
            let missingPositions = abs(items[itemIndex].quantity - quantity)
            throw NSError(domain: "нехватает \(missingPositions) шт", code: 1, userInfo: ["missingPositions": missingPositions])
        }
        items[itemIndex].quantity = items[itemIndex].quantity - quantity
    }
    
    // add quattity by SKU
    func addQuantity(sku: String, quantity: Int) throws {
        if let itemIndex = items.firstIndex(where: { $0.sku == sku}) {
            items[itemIndex].quantity = items[itemIndex].quantity + quantity
        } else {
            throw NSError(domain: "нет предмета с таким SKU на складе", code: 3)
        }
        
    }
    
    // delete item by SKU
    func deleteItem(sku: String) throws {
        if let itemIndex = items.firstIndex(where: { $0.sku == sku }) {
            trashItems.append(items[itemIndex])
            items.remove(at: itemIndex)
        } else {
            throw NSError(domain: "нет предмета с таким SKU на складе", code: 3)
        }
        
    }
    
    // restore item from trash by SKU
    func restoreItem(sku: String) throws {
        if let itemIndex = trashItems.firstIndex(where: { $0.sku == sku }) {
            items.append(trashItems[itemIndex])
            trashItems.remove(at: itemIndex)
        } else {
            throw NSError(domain: "нет предмета с таким SKU в корзине", code: 4)
        }
        
    }
    
    func deleteItemFromTrash(sku: String) throws {
        if let itemIndex = trashItems.firstIndex(where: { $0.sku == sku }) {
            trashItems.remove(at: itemIndex)
        } else {
            throw NSError(domain: "нет предмета с таким SKU в корзине", code: 3)
        }
        
    }
    
}


