//
//  InventoryObject.swift
//  InventoryList
//
//  Created by ILYA BILARUS on 03.01.2022.
//

import UIKit

class InventoryItem: CustomStringConvertible {
    
    var description: String {
        String("item name: \(itemName), quantity: \(quantity), location: \(location)")
    }

    let itemName: String
    var quantity: Int
    var location: String
    let image: UIImage
    
    
    init(name: String, quantity: Int, location: String, image: UIImage) {
        itemName = name
        self.quantity = quantity
        self.location = location
        self.image = image
    }
    
}
