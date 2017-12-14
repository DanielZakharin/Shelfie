//
//  CreateViewController.swift
//  Shelfie
//
//  Created by iosdev on 5.10.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

/*
 Controller that displays and switches between product and store creation screens
 */

import UIKit

class CreateViewController: UIViewController {
    
    @IBOutlet weak var storeProductSegment: UISegmentedControl!
    @IBOutlet weak var creationContainer: UIView!
    var currentView: UIView?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //currentView = creationContainer;
        switchView(i: 0);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Methods
    //Switches between displaying create view for product and store
    func switchView(i:Int) {
        let storyboard = UIStoryboard(name: "Floating", bundle: nil);
        var viewCtrl: UIViewController? = nil;
        if(i == 0){
            //change to store creation view
            viewCtrl = storyboard.instantiateViewController(withIdentifier: "CreateStoreView");
            self.addChildViewController(viewCtrl!);
            //creationContainer.addSubview(viewCtrl.view);
        }else if (i == 1){
            //change to product creation view
            viewCtrl = storyboard.instantiateViewController(withIdentifier: "CreateProductView");
            self.addChildViewController(viewCtrl!);
            //creationContainer.addSubview(viewCtrl.view);
        }else {
            
        }
        addViewWithAnimation(viewNew: viewCtrl!.view);
        print(self.childViewControllers.count);
        
    }
    
    func addViewWithAnimation(viewNew: UIView) {
        //clear container of views
        for sv in creationContainer.subviews {
            sv.removeFromSuperview();
        }
        //add the new view
        creationContainer.addSubview(viewNew);
        //constrain the added view to be same size as container
        constrainViewEqual(holderView: creationContainer, view: viewNew);
        
    }
    
    @IBAction func storeProductSwitch(_ sender: UISegmentedControl) {
        switchView(i: sender.selectedSegmentIndex);
    }
    
    //function that adds constraints so that a view is the same size as a superview and in the middle
    func constrainViewEqual(holderView: UIView, view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        //pin 100 points from the top of the super
        let pinTop = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal,
                                        toItem: holderView, attribute: .top, multiplier: 1.0, constant: 0)
        let pinBottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal,
                                           toItem: holderView, attribute: .bottom, multiplier: 1.0, constant: 0)
        let pinLeft = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal,
                                         toItem: holderView, attribute: .left, multiplier: 1.0, constant: 0)
        let pinRight = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal,
                                          toItem: holderView, attribute: .right, multiplier: 1.0, constant: 0)
        
        holderView.addConstraints([pinTop, pinBottom, pinLeft, pinRight])
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


