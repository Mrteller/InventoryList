//
//  EditViewController.swift
//  InventoryList
//
//  Created by ILYA BILARUS on 05.01.2022.
//

import UIKit

class EditViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - @IBOutlets
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var skuTextField: UITextField!
    @IBOutlet weak var specificationTextView: UITextView!
    @IBOutlet weak var quantityStepper: UIStepper! // sourth of truth for quantity
    
    // MARK: - Public vars

    var sku: String = ""
    weak var storage: Storage!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        specificationTextView.layer.cornerRadius = 5
        specificationTextView.layer.borderWidth = 0.5
        specificationTextView.layer.borderColor = UIColor.lightGray.cgColor
        updateUI()
        hideKeyboardOnTapAround()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateItem()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        itemImageView.image = image
        picker.dismiss(animated: true)
    }
    
    // MARK: - @IBActions
    
    @IBAction func quantityStepperValueChanged(_ sender: UIStepper) {
        quantityTextField.text = String(Int(quantityStepper.value))
    }
    
    @IBAction func quantityDidEndEditing(_ sender: UITextField) {
        if let text = sender.text, let value = Int(text) {
            quantityStepper.value = Double(value)
        } else {
            sender.text = String(Int(quantityStepper.value))
        }
    }
    
    @IBAction func changeImage() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    
    // MARK: - Private funcs
    
    private func updateItem() {
        let item = InventoryItem(name: nameTextField.text ?? "",
                                 quantity: Int(quantityStepper.value),
                                 location: locationTextField.text ?? "home",
                                 image: itemImageView.image ?? UIImage(systemName: "doc.text.image")!,
                                 sku: skuTextField.text ?? "")
        if let text = specificationTextView.text {
            item.specification = text
            
        }
        guard let itemIndex = storage.items.firstIndex(where: { $0.sku == sku }) else { return }
        storage.items[itemIndex] = item
    }
    
    private func updateUI() {
        guard let item = storage.items.first(where: { $0.sku == sku }) else { return }
        nameTextField.text = item.itemName
        quantityTextField.text = String(item.quantity)
        quantityStepper.value = Double(item.quantity)
        itemImageView.image = item.image
        locationTextField.text = item.location
        skuTextField.text = item.sku
        specificationTextView.text = item.specification
        specificationTextView.heightAnchor.constraint(equalToConstant: specificationTextView.contentSize.height + 40).isActive = true
    }
    
    private func hideKeyboardOnTapAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
}
