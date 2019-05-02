//
//  UIViewController+App.swift
//  Movies Database
//
//  Created by Umair Ali on 20/04/2019.
//  Copyright © 2019 Umair Ali. All rights reserved.
//


import UIKit

extension UIViewController {
    
    private var titleOK: String {
        return "Ok"
    }
    
    public func showAlertWithTitle(_ title: UIAlertController.AlertTitle, andMessage message: String, style: UIAlertController.Style = UIAlertController.Style.alert) {
        let alert = UIAlertController.init(title: title.title, message: message, preferredStyle: style)
        alert.addAction(UIAlertAction.init(title: titleOK , style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
