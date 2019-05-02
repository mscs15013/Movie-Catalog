//
//  AppViewController.swift
//  Movies Database
//
//  Created by Umair Ali on 20/04/2019.
//  Copyright © 2019 Umair Ali. All rights reserved.
//

import UIKit
import JGProgressHUD

class AppViewController: UIViewController {
    private var progressView: JGProgressHUD?
}


extension AppViewController {
    
    open func showActivityIndicator(style: JGProgressHUDStyle = .dark, text: String = "Loading") -> Bool {
        
        if progressView == nil {
            progressView = JGProgressHUD(style: style)
            progressView?.textLabel.text = text
            progressView?.show(in: self.view, animated: true)
            return true
        }
        return false
    }
    
    open func showProgressView(style: JGProgressHUDStyle = .dark, withMessage text: String = "Loading", progress: Float) -> Bool {
        
        if progressView == nil {
            progressView = JGProgressHUD(style: .dark)
            progressView?.progress = 10
            progressView?.textLabel.text = text
            progressView?.show(in: self.view, animated: true)
            return true
        }
        return false
    }
    
    open func dismissActivityIndicator() -> Bool {
        
        if progressView != nil {
            progressView?.dismiss(animated: true)
            progressView = nil
            return true
        }
        return false
    }
}
