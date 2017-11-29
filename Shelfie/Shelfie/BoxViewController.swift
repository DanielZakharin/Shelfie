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
class BoxViewController: UIView, UIGestureRecognizerDelegate, UIScrollViewDelegate{
    
    
    var newestView: BoxView?;
    var currentTotalX: CGFloat = 0;
    var currentTotalY: CGFloat = 0;
    let increment: CGFloat = Tools.increment;
    var svpgr : UIPanGestureRecognizer?;
    var boxesArr : [BoxView] = [];
    var scrollView : UIScrollView = UIScrollView();
    var parentCtrl: UIViewController?;
    var innerView : UIView?;
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        initialize();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        initialize();
    }
    
    func initialize(){
        scrollView.delegate = self;
        //uncomment to enable zooming, zooming however breaks adding boxes, as the coordinates do not match on the zoomed shelf
//        scrollView.maximumZoomScale = 2;
//        scrollView.minimumZoomScale = 0.5;
        //make scrollview the same size as container
        //set this, or adding constraints doesnt work!
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView);
        scrollView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true;
        scrollView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true;
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true;
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true;
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
    @objc func handlePan(sender: UIPanGestureRecognizer!) {
        if(innerView != nil){
            switch sender.state{
            //state for when pan just started, create a new view to be maniuplated here
            case .began:
                //get coordinate on screen where pan began
                let coord = sender.location(in: sender.view);
                makeBoxAtLocation(coord.x, coord.y);
                break;
                
            //state when a pan movement has occured
            case .changed:
                //translation is the amount of movement that occured
                let translation = sender.translation(in: innerView!)
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
            sender.setTranslation(CGPoint.zero, in: innerView!);
            
            
        }
        
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if let v = sender.view as? BoxView{
            showPopOver(sender: v);
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return innerView;
    }
    
    //MARK: Methods
    //shows popover view for picking what the box represents
    func showPopOver(sender: BoxView) {
        //init a view from the storyboard
        let storyboard = UIStoryboard(name: "Floating", bundle: nil)
        let viewCtrl = storyboard.instantiateViewController(withIdentifier: "BoxPopOverIdentifier")
        viewCtrl.modalPresentationStyle = UIModalPresentationStyle.popover
        let popoverPresentationController = viewCtrl.popoverPresentationController;
        popoverPresentationController?.sourceView = sender;
        parentCtrl?.present(viewCtrl, animated: true, completion: nil);
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
    func makeBG(width: Int) {
        if (innerView == nil){
            innerView = UIView();
        }
        for v in scrollView.subviews{
            if(v is UIImageView){
                v.removeFromSuperview();
            }
        }
        let offset = increment * 2;
        let shelfCellWidth = increment*8;
        let shelfCellHeight = increment*4;
        let cell = UIImage(named: "shelfCell");
        for h in 0..<3 {
            for w in 0..<width{
                let frame = CGRect(x: shelfCellWidth*CGFloat(w) + offset, y: shelfCellHeight*CGFloat(h) + offset, width: shelfCellWidth, height: shelfCellHeight)
                let cellImgView = UIImageView(frame: frame);
                cellImgView.image = cell;
                innerView!.addSubview(cellImgView);
                sendSubview(toBack: cellImgView);
            }
        }
        //SET CONTENTSIZE OF SCROLLVIEW, OTHERWISE IT WILL NOT SCROLL
        
        let contentSize = CGSize(width: shelfCellWidth*CGFloat(width) + offset*2, height: shelfCellWidth*CGFloat(3) + offset*2);
        innerView!.frame = CGRect(origin: CGPoint(x:0,y:0), size: contentSize);
        scrollView.addSubview(innerView!);
        scrollView.contentSize = innerView!.frame.size;
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
    
    func makeBoxAtLocation(_ x : CGFloat, _ y : CGFloat, width:CGFloat = Tools.increment, height: CGFloat = Tools.increment) -> BoxView?{
        if(innerView != nil){
            //create new view
            let newView = BoxView(frame: CGRect(x: Tools.roundToNearest(x:x), y: Tools.roundToNearest(x:y), width: width, height: height));
            //add a tap gesture recognizer
            let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)));
            newView.addGestureRecognizer(tapGesture);
            //add view to superview
            innerView!.addSubview(newView);
            newestView = newView;
            boxesArr.append(newView);
            return newView;
        }else {
            return nil;
        }
    }
    
    func populateShelfFromPlan(_ shelf: ShelfPlan){
        clearShelf();
        let boxes:[ShelfBox] = Array(shelf.boxes!) as! [ShelfBox];
        for sb in boxes {
            let newBox = makeBoxAtLocation(Tools.intToIncrement(int: sb.coordX), Tools.intToIncrement(int: sb.coordY), width: Tools.intToIncrement(int: sb.width), height: Tools.intToIncrement(int: sb.height));
            if let p = sb.product{
                newBox!.setProducForBox(p);
            }
        }
    }
    
    func clearShelf(){
        if(innerView != nil){
            for v in innerView!.subviews{
                if(v is BoxView){
                    v.removeFromSuperview();
                }
            }
        }
        boxesArr = [];
    }
    
}
