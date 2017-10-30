//
//  BoxViewController.swift
//  Shelfie
//
//  Created by iosdev on 29.9.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import UIKit
import AVFoundation

/*
 Controller for view where boxes and shelf get drawn.
 */
class BoxViewController: UIViewController, UIGestureRecognizerDelegate{
    
    
    var newestView: BoxView?;
    var currentTotalX: CGFloat = 0;
    var currentTotalY: CGFloat = 0;
    let increment: CGFloat = Tools.increment;
    var svpgr : UIPanGestureRecognizer?;
    var boxesArr : [BoxView] = [];
    var scrollView : UIScrollView = UIScrollView();
    override func viewDidLoad() {
        super.viewDidLoad()
        //make scrollview the same size as container
        let c = self.view!.frame;
        let newFrame = CGRect(x: c.origin.x, y: c.origin.y, width: c.width, height: c.height);
        scrollView.frame = newFrame;
        self.view!.addSubview(scrollView);
        //setup pan gesture recognizers for scrollview
        //allow the scrollviews native gesture to only work with 2 finger pans
        scrollView.panGestureRecognizer.minimumNumberOfTouches = 2;
        let panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(sender:)));
        //set the pan gesture delegate to self so that failure dependancies can be set
        panGesture.delegate = self;
        //only allow 1 finger pans, so that when 2 finger pans are used, the recognizer fails and allows scrollviews own recognizer to
        //handle the pan ie. scroll
        panGesture.maximumNumberOfTouches = 1;
        scrollView.addGestureRecognizer(panGesture);
        //tell the scrollviews gesturerecognizer that pangesture must first fail in order for it to be allowed to work
        scrollView.panGestureRecognizer.require(toFail: panGesture);
        
        //create a shelf for the background, change this later to be fetched from datasource
        makeBG(width: 9, height: 2);
        self.view.backgroundColor=UIColor.gray;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: PangestureRecognizerDelegate Methods
    //tells the pangesturerecognizer to disallow detection of multiple recognizers, so when moving a box, a new one deosnt get created
    //under it
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if(otherGestureRecognizer.view == scrollView){
            return true;
        }
        return false;
    }
    
    /*func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if(otherGestureRecognizer.view == scrollView){
            return true;
        }
        return false;
    }*/
    
    //tells the pangesture that it must fail before another gesture recognizer can be activated, in this case we only care about the
    //scrollviews built in one
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if(otherGestureRecognizer.view == scrollView){
            return true;
        }
        return false;    }
  
    
    //MARK: Gesture Handlind
    //Pan gesture handling when touching empty space on the scrollview
    func handlePan(sender: UIPanGestureRecognizer!) {
        switch sender.state{
        //state for when pan just started, create a new view to be maniuplated here
        case .began:
            //get coordinate on screen where pan began
            let coord = sender.location(in: sender.view);
            //create new view
            let newView = BoxView(frame: CGRect(x: Tools.roundToNearest(x:coord.x), y: Tools.roundToNearest(x:coord.y), width: increment, height: increment));
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
            let translation = sender.translation(in: scrollView)
            if newestView != nil {
                //add to total amount moved
                currentTotalX += translation.x;
                currentTotalY += translation.y;
                //if total amount moved exceeds threshold, resize view, reset total moved when done
                if(abs(currentTotalX) > increment && newestView!.frame.size.width + currentTotalX > 0){
                    //newestView!.frame.size.width += roundToNearest(x: currentTotalX);
                    if(currentTotalX > 0){
                        newestView!.increaseSizeByX(1);
                    }else {
                        newestView!.increaseSizeByX(-1);
                    }
                    currentTotalX = 0;
                }
                if(abs(currentTotalY) > increment && newestView!.frame.size.height + currentTotalY > 0){
                    if(currentTotalY > 0){
                        newestView!.increaseSizeByY(1);
                    }else {
                        newestView!.increaseSizeByY(-1);
                    }
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
        case .failed:
            print("Other state");
            break;
        default:
            print("!");
            break;
        }
        //reset translation so it doesn't accumulate
        sender.setTranslation(CGPoint.zero, in: scrollView);
        
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        print("tapped a box from VC");
        if let v = sender.view as? BoxView{
            showPopOver(sender: v);
            v.boxToData();
            v.convertToWrapper();
        }
    }
    
    //MARK: Methods
    //shows popover view for picking what the box represents
    func showPopOver(sender: BoxView) {
        //init a view from the storyboard
        let storyboard = UIStoryboard(name: "Floating", bundle: nil)
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
    
    //dismisses the tableview popover
    func dismissPopOver(ctrl: UIViewController) {
        ctrl.dismiss(animated: false, completion: nil);
    }
    
    //makes a background for drawing boxes on
    func makeBG(width: Int, height: Int) {
        let shelfCellWidth = increment*4;
        let cell = UIImage(named: "shelfCell");
        for h in 0..<height {
            for w in 0..<width{
                let cellImgView = UIImageView(frame: CGRect(x: shelfCellWidth*CGFloat(w), y: shelfCellWidth*CGFloat(h), width: shelfCellWidth, height: shelfCellWidth));
                cellImgView.image = cell;
                scrollView.addSubview(cellImgView);
            }
        }
        //SET CONTENTSIZE OF SCROLLVIEW, OTHERWISE IT WILL NOT SCROLL
        scrollView.contentSize = CGSize(width: shelfCellWidth*CGFloat(width), height: shelfCellWidth*CGFloat(height));
    }
    
    func convertAllBoxesToWrappers() -> [BoxWrapper]{
        var wrapperArr: [BoxWrapper] = [];
        for box in boxesArr {
            wrapperArr.append(box.convertToWrapper());
        }
        return wrapperArr;
    }
    
    func convertSelfToWrapper(store: Store) -> ShelfWrapper{
        let shelfWrapper = ShelfWrapper(stoure: store);
        shelfWrapper.boxes = convertAllBoxesToWrappers();
        return shelfWrapper;
    }
    
}
