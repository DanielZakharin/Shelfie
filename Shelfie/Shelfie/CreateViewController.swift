//
//  CreateViewController.swift
//  Shelfie
//
//  Created by iosdev on 5.10.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController {
    
    @IBOutlet weak var storeProductSegment: UISegmentedControl!
    @IBOutlet weak var creationContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        switchView(i: 0);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Methods
    func switchView(i:Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        //removes all subviews from container
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
        
    }
    
    
    
    
    @IBAction func storeProductSwitch(_ sender: UISegmentedControl) {
        switchView(i: sender.selectedSegmentIndex);
        
    }
    
    func addViewWithAnimation(viewNew: UIView) {
        if (self.creationContainer.subviews.count > 0){
            let viewInitial = self.creationContainer.subviews[0];
            if viewInitial != nil{
                // Fade out to set the text
                UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    viewInitial.alpha = 0.0
                }, completion: {
                    (finished: Bool) -> Void in
                    //When fully faded, remove the view
                    viewInitial.removeFromSuperview();
                });
            }
            
        }
        //add new view, set view to invisible
        self.creationContainer.addSubview(viewNew);
        viewNew.alpha = 0;
        // Fade in new View
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            viewNew.alpha = 1.0
        }, completion: nil);
        
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


