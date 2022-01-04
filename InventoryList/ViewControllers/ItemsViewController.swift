//
//  ItemsViewController.swift
//  InventoryList
//
//  Created by  Paul on 04.01.2022.
//

import UIKit

class ItemsViewController: UITableViewController {
    
    
    // MARK: - Public vars
    
    var items = [InventoryItem]()
    
    // MARK: - Lifecycle methods
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showItemInfo",
//           let item = sender as? InventoryItem,
//           let contactsInfoVC = segue.destination as? ItemInfoViewController {
//            contactsInfoVC.item = item
//        }
//    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        items.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        items[section].itemName
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        switch indexPath.row {
        case 0:
            configuration.text = items[indexPath.section].description
            configuration.image = items[indexPath.section].image
            configuration.imageProperties.maximumSize = CGSize(width: 40, height: 40)
        case 1:
            configuration.text = "Спецификация"
            configuration.secondaryText = items[indexPath.section].specification
        case 2:
            configuration.text = "Место"
            configuration.secondaryText = items[indexPath.section].location
        default:
            configuration.text = "Количество"
            configuration.secondaryText = String(items[indexPath.section].quantity)
        }
        cell.contentConfiguration = configuration
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showItemInfo", sender: items[indexPath.section])
    }

}
