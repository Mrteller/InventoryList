//
//  EditViewController.swift
//  InventoryList
//
//  Created by ILYA BILARUS on 05.01.2022.
//

import UIKit
import AVFoundation

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
        navigationItem.hidesBackButton = true
        specificationTextView.layer.cornerRadius = 10
        specificationTextView.layer.borderWidth = 0.5
        specificationTextView.layer.borderColor = UIColor.lightGray.cgColor
        itemImageView.layer.cornerRadius = specificationTextView.layer.cornerRadius
        itemImageView.layer.borderWidth = specificationTextView.layer.borderWidth
        itemImageView.layer.borderColor = specificationTextView.layer.borderColor
        updateUI()
        hideKeyboardOnTapAround()
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
    
    @IBAction func changeImage(sender: UIButton) {
        let picker = UIImagePickerController()
        if sender.tag == 2 {
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
            let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
            
            switch cameraAuthorizationStatus {
            case .notDetermined:
                requestCameraPermission()
                return
            case .authorized:
                break
            case .restricted, .denied:
                alertCameraAccessNeeded()
                return
            @unknown default:
                return
            }
            picker.sourceType = .camera
        }
        
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        if updateItem() { navigationController?.popViewController(animated: true) }
    }
    
    
    // MARK: - Private funcs
    
    private func updateItem() -> Bool {
        let item = InventoryItem(name: nameTextField.text ?? "",
                                 quantity: Int(quantityStepper.value),
                                 location: locationTextField.text ?? "home",
                                 image: itemImageView.image ?? UIImage(systemName: "doc.text.image")!,
                                 sku: skuTextField.text ?? "")
        if let text = specificationTextView.text {
            item.specification = text
        }
        if sku.isEmpty {
            if case let .invalid(reason) = storage.validateNew(item) {
                let alert = UIAlertController(title: "Invalid Item", message: reason, style: .default)
                present(alert, animated: true)
                return false
            }
            try? storage.addNew(item) // TODO: catch gracefully
        } else {
            storage.edit(sku: sku, editedItem: item)
        }
        return true
    }
    
    private func updateUI() {
        guard let item = storage.getItem(sku: sku) else { return }
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
    
    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] accessGranted in
            if !accessGranted {
                DispatchQueue.main.async {
                    self?.alertCameraAccessNeeded()
                }
            }
        }
    }
    
    private  func alertCameraAccessNeeded() {
        guard let settingsAppURL = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(settingsAppURL) else { return } // This should never happen
        let alert = UIAlertController(
            title: "Need Camera Access",
            message: "Camera access is required to take pictures of item.",
            style: .cancel
        )
        alert.addAction(UIAlertAction(title: "Allow Camera", style: .default) { _ in
            UIApplication.shared.open(settingsAppURL, options: [:])
        })
        present(alert, animated: true)
    }
    
    
}
