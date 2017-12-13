//
//  ViewCtrlExtension.swift
//  Shelfie
//
//  Created by iosdev on 29.11.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import Foundation
import UIKit
/*
 Simple extension that allows easily showing simple alerts
 */
extension UIViewController {
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
