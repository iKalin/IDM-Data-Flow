//
//  Extensions.swift
//  IDMDataFlow
//
//  Created by FOLY on 8/15/16.
//  Copyright © 2016 NGUYEN CHI CONG. All rights reserved.
//

import Foundation
import MBProgressHUD
import IDMCore

extension UIView: CanPresentLoadingView {
    public func presentLoadingView() {
        MBProgressHUD.showAdded(to: self, animated: true)
    }
    
    public func dismissLoadingView() {
        MBProgressHUD.hide(for: self, animated: true)
    }
}

extension UIViewController : CanPresentErrorAlert {
    public func presentErrorAlert(_ error: Error?) {
        let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
