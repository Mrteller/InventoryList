//
//  UIAlertController+.swift
//  InventoryList
//
//  Created by  Paul on 08.01.2022.
//

import UIKit

extension UIAlertController {
    
    convenience init(title: String, message: String, style: UIAlertAction.Style = .default) {
        self.init(title: title, message: message, preferredStyle: .alert)
        switch style {
        case .cancel:
            self.addAction(title: "Cancel", style: .cancel) //.cancel action will always be at the end
        case .`default`:
            self.addAction(title: "OK", style: .default)
        case .destructive:
            self.addAction(title: "OK", style: .destructive)
        @unknown default:
            self.addAction(title: "OK", style: .default)
        }
    }
    
    func addAction(image: UIImage? = nil, title: String, color: UIColor? = .tintColor, style: UIAlertAction.Style = .default, isEnabled: Bool = true, handler: ((UIAlertAction) -> Void)? = nil) {
        
        let action = UIAlertAction(title: title, style: style, handler: handler)
        action.isEnabled = isEnabled
        
        action.setValue(image, forKey: "image")
        action.setValue(color, forKey: "titleTextColor")
  
        addAction(action)
    }
    
}
