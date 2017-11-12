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
    
    func addViewWithAnimation(viewNew: UIView) {/*
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
         viewNew.frame = CGRect(x: 0, y: 0, width: 100, height: 100);//self.creationContainer.frame;
         viewNew.alpha = 0;
         // Fade in new View
         UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
         viewNew.alpha = 1.0
         }, completion: nil);*/
        /*if let oldView = currentView{
            self.creationContainer.addSubview(viewNew);
            /*viewNew.addConstraints([
                NSLayoutConstraint(item: viewNew, attribute: .top, relatedBy: .equal, toItem: storeProductSegment, attribute: .bottom, multiplier: 1.0, constant: 16),
                NSLayoutConstraint(item: viewNew, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottomMargin, multiplier: 1.0, constant: 8),
                NSLayoutConstraint(item: viewNew, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 8),
                NSLayoutConstraint(item: viewNew, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 8)
                ]);*/
            viewNew.frame = oldView.frame;
            oldView.removeFromSuperview();
            currentView = viewNew;
        }*/
        
        print("CC dimension before: \(viewNew.frame.width) x \(viewNew.frame.height)");
        for sv in creationContainer.subviews {
            sv.removeFromSuperview();
        }
        //viewNew.autoresizingMask = [.flexibleWidth, .flexibleHeight];
        creationContainer.addSubview(viewNew);
        constrainViewEqual(holderView: creationContainer, view: viewNew);
        
        /*
        creationContainer.addConstraints([
            NSLayoutConstraint(item: viewNew, attribute: .height, relatedBy: .equal, toItem: creationContainer, attribute: .height, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: viewNew, attribute: .width, relatedBy: .equal, toItem: creationContainer, attribute: .width, multiplier: 1.0, constant: 0)
            ]);
       
        print("CC dimension after: \(viewNew.frame.width) x \(viewNew.frame.height)");
        */
 
        /*let testView = UIView();
        testView.backgroundColor = UIColor.green;
        creationContainer.addSubview(testView);
        creationContainer.addConstraints([
            NSLayoutConstraint(item: testView, attribute: .height, relatedBy: .equal, toItem: creationContainer, attribute: .height, multiplier: 0.5, constant: 0),
            NSLayoutConstraint(item: testView, attribute: .width, relatedBy: .equal, toItem: creationContainer, attribute: .width, multiplier: 0.5, constant: 0)
            ])*/
    }
    
    @IBAction func storeProductSwitch(_ sender: UISegmentedControl) {
        switchView(i: sender.selectedSegmentIndex);
        
    }
    
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


