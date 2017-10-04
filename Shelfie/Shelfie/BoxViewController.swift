//
//  BoxViewController.swift
//  Shelfie
//
//  Created by iosdev on 29.9.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import UIKit
import AVFoundation

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
        //create a shelf for the background
        /*let shelfImage = stitchImages(cellCount: 4, isVertical: false);
        let bgShelf = UIImageView(image: shelfImage);
        self.view.addSubview(bgShelf);*/
        makeBG(width: 3, height: 2);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destinationCtrl = segue.destination;
        print("segue triggered");
    }*/
    
    
    
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
        if let v = sender.view as? BoxView{
            showPopOver(sender: v);
        }
    }
    
    //MARK: Methods
    //shows popover view for picking color
    func showPopOver(sender: BoxView) {
        //init a view from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewCtrl = storyboard.instantiateViewController(withIdentifier: "BoxPopOverIdentifier")
        viewCtrl.modalPresentationStyle = UIModalPresentationStyle.popover
        let popoverPresentationController = viewCtrl.popoverPresentationController;
        popoverPresentationController?.sourceView = sender
        present(viewCtrl, animated: true, completion: nil);
        //pass selected view to popover controller for manipulation
        if let presentedCtrl = popoverPresentationController?.presentedViewController as? BoxPopoverViewController{
            presentedCtrl.selectedBoxView = sender;
            presentedCtrl.parentCtrl = self;
        }
    }
    
    func dismisstest(ctrl: BoxPopoverViewController) {
        ctrl.dismiss(animated: false, completion: nil);
    }
    
    //stiches multiple shelfCell images into a single row
    /*func stitchImages(cellCount: Int, isVertical: Bool) -> UIImage {
        var stitchedImages : UIImage!
        var images : [UIImage] = [];
        if cellCount > 0 {
            var maxWidth = CGFloat(0), maxHeight = CGFloat(0)
            for _ in 0..<cellCount {
                print("looping images");
                if let image = UIImage(named: "shelfCell"){
                    if image.size.width > maxWidth {
                        maxWidth = image.size.width
                    }
                    if image.size.height > maxHeight {
                        maxHeight = image.size.height
                    }
                    images.append(image);
                }
            }
            var totalSize : CGSize
            let maxSize = CGSize(width: maxWidth, height: maxHeight)
            if isVertical {
                totalSize = CGSize(width: maxSize.width, height: maxSize.height * (CGFloat)(cellCount))
            } else {
                totalSize = CGSize(width: maxSize.width  * (CGFloat)(cellCount), height:  maxSize.height)
            }
            UIGraphicsBeginImageContext(totalSize)
            for image in images {
                print("looping images2");
                let offset = (CGFloat)(images.index(of: image)!)
                let rect =  AVMakeRect(aspectRatio: image.size, insideRect: isVertical ?
                    CGRect(x: 0, y: maxSize.height * offset, width: maxSize.width, height: maxSize.height) :
                    CGRect(x: maxSize.width * offset, y: 0, width: maxSize.width, height: maxSize.height))
                image.draw(in: rect)
            }
            stitchedImages = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return stitchedImages
    }*/
    
    
    func makeBG(width: Int, height: Int) {
        var shelfCellWidth = increment*4;
        let cell = UIImage(named: "shelfCell");
        for h in 0..<height {
            for w in 0..<width{
                let cellImgView = UIImageView(frame: CGRect(x: shelfCellWidth*CGFloat(w), y: shelfCellWidth*CGFloat(h), width: shelfCellWidth, height: shelfCellWidth));
                cellImgView.image = cell;
                self.view.addSubview(cellImgView);
            }
        }
    }
    
    //MARK: Convenience
    //round a float to nearest number defined by increment
    func roundToNearest(x : CGFloat) -> CGFloat {
        let jee = increment * CGFloat(round(x / increment));
        print("Rounded \(x) to \(jee)");
        return jee;
    }
    
}
