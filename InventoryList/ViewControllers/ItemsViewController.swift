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
    
    // MARK: - Private vars
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var filteredItems = [InventoryItem]()
    private var itemsInTable : [InventoryItem] { // A subset of items to display in tableView
        return (searchController.isActive && searchController.searchBar.text != "") ? filteredItems : storage.items
    }
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
        setupSearchController(placeholder: NSLocalizedString("Search items", comment: "placeholder"), hideWhenAppear: true)
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
        return itemsInTable.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        let item = itemsInTable[indexPath.row]
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
    //        //        let sku = itemsInTable[indexPath.row].sku
    //        //        performSegue(withIdentifier: "showItemInfo", sender: sku)
    //    }
    
    // MARK: - Private funcs
    
//    private func reloadCell(at indexPath: IndexPath) {
//        tableView.beginUpdates()
//        tableView.reloadRows(at: [indexPath], with: .automatic)
//        tableView.endUpdates()
//    }
    
    // MARK: SearchController for filtering items
    private func setupSearchController(placeholder: String = "", hideWhenAppear: Bool = true) {
        definesPresentationContext = true
        // searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        // searchController.searchBar.barTintColor = UIColor(white: 0.9, alpha: 0.4)
        searchController.searchBar.placeholder = placeholder
        searchController.hidesNavigationBarDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        if hideWhenAppear {
            tableView.contentOffset = CGPoint(x: 0, y: searchController.searchBar.frame.height)
        }
    }
    
    private func filterRows(for searchText: String) {
        filteredItems = storage.items.filter{
            // TODO: add more fields to include in search
            $0.itemName.lowercased().contains(searchText.lowercased()) ||
            $0.location.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
}

extension ItemsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterRows(for: searchText)
        }
    }
    
}
