//
//  BoxCategoryViewController.swift
//  Shelfie
//
//  Created by iosdev on 21.10.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import UIKit

class BoxCategoryViewController: BoxViewController {

    
    override func showPopOver(sender: BoxView) {
        //init a view from the storyboard
        let storyboard = UIStoryboard(name: "Floating", bundle: nil)
        let viewCtrl = storyboard.instantiateViewController(withIdentifier: "BoxPopOverCategoryIdentifier")
        viewCtrl.modalPresentationStyle = UIModalPresentationStyle.popover
        let popoverPresentationController = viewCtrl.popoverPresentationController;
        popoverPresentationController?.sourceView = sender
        //present(viewCtrl, animated: true, completion: nil);
        //pass selected view to popover controller for manipulation
        if let presentedCtrl = popoverPresentationController?.presentedViewController as? BoxPopOverCategoryOnlyViewController{
            presentedCtrl.selectedBoxView = sender;
            presentedCtrl.parentCtrl = self;
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
