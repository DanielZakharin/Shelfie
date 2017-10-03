//
//  BoxViewController.swift
//  Shelfie
//
//  Created by iosdev on 29.9.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import UIKit

class BoxViewController: UIViewController {
    
    var newestView: UIView?;
    var currentTotalX: CGFloat = 0;
    var currentTotalY: CGFloat = 0;
    let increment: CGFloat = 50.0;
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(sender:)));
        self.view.addGestureRecognizer(panGesture);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    //MARK: Gesture Handlind
    //Pan gesture handling when touching empty space
    func handlePan(sender: UIPanGestureRecognizer!) {
        switch sender.state{
        //state for when pan just started, create a new view to be maniuplated here
        case .began:
            //get coordinate on screen where pan began
            let coord = sender.location(in: sender.view);
            //create new view
            let newView=BoxView(frame: CGRect(x: roundToNearest(x:coord.x), y: roundToNearest(x:coord.y), width: increment, height: increment));
            //add a tap gesture recognizer
            let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)));
            newView.addGestureRecognizer(tapGesture);
            //add view to superview
            sender.view!.addSubview(newView);
            newestView = newView;
            
            break;
            
        //state when a pan movement has occured
        case .changed:
            //translation is the amount of movement that occured
            let translation = sender.translation(in: self.view)
            if newestView != nil {
                //add to total amount moved
                currentTotalX += translation.x;
                currentTotalY += translation.y;
                //if total amount moved exceeds threshold, resize view, reset total moved when done
                if(abs(currentTotalX) > increment && newestView!.frame.size.width + currentTotalX > 0){
                    newestView!.frame.size.width += roundToNearest(x: currentTotalX);
                    currentTotalX = 0;
                }
                if(abs(currentTotalY) > increment && newestView!.frame.size.height + currentTotalY > 0){
                    newestView!.frame.size.height += roundToNearest(x: currentTotalY);
                    currentTotalY = 0;
                }
            }
            break;
            
        //state when pan action has ended
        case .ended:
            /*newestView!.removeFromSuperview();
             newestView = nil;*/
            currentTotalX = 0;
            currentTotalY = 0;
            break;
        default:
            print("Other state");
        }
        //reset translation so it doesn't accumulate
        sender.setTranslation(CGPoint.zero, in: self.view);
        
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        print("tapped a box from VC");
        showPopOver(sender: sender.view!);
    }
    
    //MARK: Methods
    func showPopOver(sender: UIView) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewCtrl = storyboard.instantiateViewController(withIdentifier: "BoxPopOverIdentifier")
        viewCtrl.modalPresentationStyle = UIModalPresentationStyle.popover
        
        present(viewCtrl, animated: true, completion: nil)
        
        let popoverPresentationController = viewCtrl.popoverPresentationController
        popoverPresentationController?.sourceView = sender
    }
    
    //MARK: Convenience
    //round a float to nearest number defined by increment
    func roundToNearest(x : CGFloat) -> CGFloat {
        let jee = increment * CGFloat(round(x / increment));
        print("Rounded \(x) to \(jee)");
        return jee;
    }
    
}