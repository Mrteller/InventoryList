//
//  InventoryObject.swift
//  InventoryList
//
//  Created by ILYA BILARUS on 03.01.2022.
//

import UIKit

class InventoryItem: CustomStringConvertible {
    
    var description: String {
        String("item name: \(itemName), quantity: \(quantity), location: \(location), sku: \(sku)")
    }

    let itemName: String
    var quantity: Int
    var location: String
    let image: UIImage
    var specification: String?
    var sku: String
    
    init(name: String, quantity: Int, location: String, image: UIImage, sku: String) {
        itemName = name
        self.quantity = quantity
        self.location = location
        self.image = image
        self.sku = sku
    }
    
}
