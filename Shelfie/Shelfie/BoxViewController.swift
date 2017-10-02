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
    
    @IBAction func tappedAnywhere(_ sender: Any) {
        print("I tapped ur mama");
    }
    
    @IBAction func handlePan(_ sender: UIPanGestureRecognizer) {
        switch sender.state{
        case .began:
            
            let coord = sender.location(in: sender.view);
            //print("\(coord.x) : \(coord.y)");
            //create new view
            let newView=UIView(frame: CGRect(x: coord.x, y: coord.y, width: 0, height: 0));
            newView.backgroundColor = UIColor.blue;
            sender.view!.addSubview(newView);
            newestView = newView;
            break;
        case .changed:
            let translation = sender.translation(in: self.view)
            if newestView != nil {
                currentTotalX += translation.x;
                currentTotalY += translation.y;
                if(abs(currentTotalX) > increment && newestView!.frame.size.width + currentTotalX > 0){
                    newestView!.frame.size.width += roundToNearest(x: currentTotalX);
                    currentTotalX = 0;
                }
                if(abs(currentTotalY) > increment && newestView!.frame.size.height + currentTotalY > 0){
                    newestView!.frame.size.height += roundToNearest(x: currentTotalY);
                    currentTotalY = 0;
                }
                /*
                let newWidth = newestView!.frame.size.width+translation.x;
                let newHeight = newestView!.frame.size.height + translation.y;
                print("NewWidth \(newWidth) NewHeight \(newHeight)");
                if(newWidth > 0.5){
                    newestView!.frame.size.width=roundToNearest(x:newWidth);
                }
                if(newHeight > 0.5){
                    
                    newestView!.frame.size.height = roundToNearest(x: newHeight);
                }
                print("NewWidth2 \(newestView!.frame.size.width) NewHeight2 \(newestView!.frame.size.height)");*/
                //print("\(newestView!.frame.origin.x) : \(newestView!.frame.origin.y)");
                //newestView!.frame = CGRect(x: newestView!.frame.origin.x, y: newestView!.frame.origin.y, width: newestView!.frame.width + translation.x, height: newestView!.frame.height + translation.y);
            }
            break;
        case .ended:
            newestView!.removeFromSuperview();
            newestView = nil;
            break;
        default:
            print("Other state");
        }
        if(sender.state == .began){
            
            
        }else{
            
        }
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    func roundToNearest(x : CGFloat) -> CGFloat {
        let jee = increment * CGFloat(round(x / increment));
        print("Rounded \(x) to \(jee)");
        return jee;
    }

}
