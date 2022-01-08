//
//  TrashViewController.swift
//  InventoryList
//
//  Created by ILYA BILARUS on 07.01.2022.
//

import UIKit

class TrashViewController: UITableViewController {
    
    @IBOutlet weak var selectButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    // MARK: - Public vars
    weak var storage: Storage!

    
    // MARK: - Private vars
    private var restoreSelectionIsActivate = false
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var filteredItems = [InventoryItem]()
    private var itemsInTable : [InventoryItem] { // A subset of items to display in tableView
        return (searchController.isActive && searchController.searchBar.text != "") ? filteredItems : storage.trashItems
    }
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
        setupSearchController(placeholder: NSLocalizedString("Search items", comment: "placeholder"), hideWhenAppear: true)
        
        //set UIContextualAction Image to black color
        UIImageView.appearance(whenContainedInInstancesOf: [UITableView.self]).tintColor = .black
        
        tableView.allowsSelection = false
        tableView.allowsMultipleSelection = false
        
        cancelButton.isEnabled = false
        cancelButton.tintColor = UIColor.clear
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTrashItem",
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
        cell.selectionStyle = .default
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "") { (action, view, completion) in
            print("Delete Pressed", action)
            guard let cell = tableView.cellForRow(at: indexPath) as? ItemCell else { return }
            do {
                try self.storage.deleteItemFromTrash(sku: cell.sku)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                print(error.localizedDescription)
            }
        }
        delete.backgroundColor =  UIColor.init(red: 225/255, green: 20/255, blue: 0/255, alpha: 1)
        delete.image = UIImage(systemName: "trash")
        
        
        let edit = UIContextualAction(style: .normal, title: "") { (action, view, completion) in
            print("Edit Pressed", action)
            guard let cell = tableView.cellForRow(at: indexPath) as? ItemCell else { return }
            self.performSegue(withIdentifier: "editTrashItem", sender: cell.sku)
        }
        edit.backgroundColor = UIColor.init(red: 60/255, green: 206/255, blue: 55/255, alpha: 1)
        edit.image = UIImage(systemName: "doc.badge.gearshape")
        
        let config = UISwipeActionsConfiguration(actions: [delete, edit])
        config.performsFirstActionWithFullSwipe = false
        
        return config
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            selectButton.isEnabled = true
    }
    
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let _ = tableView.indexPathsForSelectedRows else {
            selectButton.isEnabled = false
            return
        }
    }
    
    
    // MARK: IBActions
    
    
    @IBAction func selectButtonPressed(_ sender: UIBarButtonItem) {
        if restoreSelectionIsActivate {
            restoreSelectionIsActivate = false
            //Restore functions
            guard let indexPathSelectedRows = tableView.indexPathsForSelectedRows else { return }
            for indexPath in indexPathSelectedRows {
                guard let cell = tableView.cellForRow(at: indexPath) as? ItemCell else { return }
                do {
                    try self.storage.restoreItem(sku: cell.sku)
                } catch {
                    print(error.localizedDescription)
                }
            }
            tableView.deleteRows(at: indexPathSelectedRows, with: .automatic)
            cancelButtonPressed(cancelButton)
        } else {
            restoreSelectionIsActivate = true
            
            tableView.allowsSelection = true
            tableView.allowsMultipleSelection = true
            
            selectButton.title = "Restore"
            selectButton.isEnabled = false
            selectButton.tintColor = .green
            
            cancelButton.isEnabled = true
            cancelButton.tintColor = .systemBlue
            
            
        }
        
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        restoreSelectionIsActivate = false
        
        tableView.allowsSelection = false
        tableView.allowsMultipleSelection = false
        
        cancelButton.isEnabled = false
        cancelButton.tintColor = .clear
        selectButton.title = "Select Items"
        selectButton.isEnabled = true
        selectButton.tintColor = .systemBlue
        
        guard let indexPathSelectedRows = tableView.indexPathsForSelectedRows else { return }
        for indexPath in indexPathSelectedRows {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    
    // MARK: SearchController for filtering items
    private func setupSearchController(placeholder: String = "", hideWhenAppear: Bool = true) {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = placeholder
        searchController.hidesNavigationBarDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        if hideWhenAppear {
            tableView.contentOffset = CGPoint(x: 0, y: searchController.searchBar.frame.height)
        }
    }
    
    private func filterRows(for searchText: String) {
        filteredItems = storage.trashItems.filter{
            // TODO: add more fields to include in search
            $0.itemName.lowercased().contains(searchText.lowercased()) ||
            $0.location.lowercased().contains(searchText.lowercased()) ||
            $0.sku.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
}

extension TrashViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterRows(for: searchText)
        }
    }
    
    
}
