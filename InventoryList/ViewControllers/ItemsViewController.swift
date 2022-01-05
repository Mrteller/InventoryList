//
//  ItemsViewController.swift
//  InventoryList
//
//  Created by  Paul on 04.01.2022.
//

import UIKit

class ItemsViewController: UITableViewController {
    
    
    // MARK: - Public vars
    
    var storage = Storage()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editItem",
           let sku = sender as? String,
           let editVC = segue.destination as? EditViewController {
            editVC.sku = sku
            editVC.storage = storage
            editVC.title = "Edit"
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storage.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        let item = storage.items[indexPath.row]
        cell.itemImageView.image = item.image
        cell.nameLabel.text = item.itemName
        cell.quantityLabel.text = String("Количество: \(item.quantity) шт")
        cell.locationLabel.text = "Место: " + item.location
        cell.skuLabel.text = "SKU: " + String(item.sku)
        cell.sku = item.sku
        cell.storage = storage
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            print("Delete Pressed", action)
            guard let cell = tableView.cellForRow(at: indexPath) as? ItemCell else { return }
            do {
                try self.storage.deleteItem(sku: cell.sku)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                print(error.localizedDescription)
            }
        }
        delete.backgroundColor =  UIColor.red
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
            print("Edit Pressed", action)
            guard let cell = tableView.cellForRow(at: indexPath) as? ItemCell else { return }
            self.performSegue(withIdentifier: "editItem", sender: cell.sku)
        }
        edit.backgroundColor = UIColor.green
        
        let config = UISwipeActionsConfiguration(actions: [delete, edit])
        config.performsFirstActionWithFullSwipe = false
        
        return config
    }
    
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        tableView.deselectRow(at: indexPath, animated: true)
    //        //        let sku = storage.items[indexPath.row].sku
    //        //        performSegue(withIdentifier: "showItemInfo", sender: sku)
    //    }
    
    // MARK: - Private funcs
    
//    private func reloadCell(at indexPath: IndexPath) {
//        tableView.beginUpdates()
//        tableView.reloadRows(at: [indexPath], with: .automatic)
//        tableView.endUpdates()
//    }
}
