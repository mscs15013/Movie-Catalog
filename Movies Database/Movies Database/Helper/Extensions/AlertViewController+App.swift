//
//  AlertViewController+App.swift
//  Movies Database
//
//  Created by Umair Ali on 20/04/2019.
//  Copyright © 2019 Umair Ali. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    
    public enum AlertTitle: String {
        
        case error = "Error"
        case alert = "Alert"
        case success = "Success"
        case logout = "Logout"
        
        var title: String {
            return self.rawValue
        }
    }
    
    public static func showAlertWithMessage(_ message: String, andTitle title: AlertTitle = .success) -> Bool {
        
        let alert = UIAlertController.init(title: title.title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: nil))
        
        guard let currentViewController =  UIApplication.shared.delegate?.window??.topMostViewController() else {
            return false
        }
        currentViewController.present(alert, animated: true, completion: nil)
        return true
    }
    
    public static func showAlertWithMesaage(_ message: String, Title title: AlertTitle = .alert, actionTitles: [String], actions: [(() -> Void)?]) -> Bool {
        
        guard actionTitles.count == actions.count else {
            return false
        }
        
        let alert = UIAlertController.init(title: title.title, message: message, preferredStyle: .alert)
        
        for (actionTitle, action) in zip(actionTitles, actions) {
            
            alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { _ in
                action?()
            }))
        }
        
        guard let currentViewController =  UIApplication.shared.delegate?.window??.topMostViewController() else {
            return false
        }
        currentViewController.present(alert, animated: true, completion: nil)
        return true
    }
}

