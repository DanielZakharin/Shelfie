//
//  BoxView.swift
//  Shelfie
//
//  Created by iosdev on 3.10.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import UIKit

class BoxView: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    //MARK: Variables
    var cornerDragView: UIView;
    let cornerSize = 15;
    var currentTotalX:CGFloat = 0;
    var currentTotalY:CGFloat = 0;
    let increment:CGFloat = 50.0;
    
    //MARK: Init
    
    override init(frame: CGRect) {
        //programatically init
        cornerDragView = UIView();
        super.init(frame: frame);
        initialize();
    }
    
    required init?(coder aDecoder: NSCoder) {
        //storyboard init
        cornerDragView = UIView();
        super.init(coder: aDecoder)
        initialize();
    }
    
    //initialize BoxView and add cornerDragView to it
    func initialize(){
        self.backgroundColor = UIColor(patternImage: UIImage(named: "roll1")!);
        cornerDragView=UIView(frame: CGRect(x: Int(self.frame.width-CGFloat(cornerSize)), y: Int(self.frame.height-CGFloat(cornerSize)), width: cornerSize, height: cornerSize));
        cornerDragView.backgroundColor = UIColor.cyan;
        self.addSubview(cornerDragView);
        //bring views to front of the main view
        self.bringSubview(toFront: cornerDragView);
        self.superview?.bringSubview(toFront: self);
        //add a tap gesture to main boxview
        //let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(action:)));
        //self.addGestureRecognizer(tapGesture);
        //add  pan gesture to box
        let boxPan : UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleBoxPan(sender:)));
        //need to set maximum number of touches so that scrolling of the scrollview can still occur when using two fingers on the box
        boxPan.maximumNumberOfTouches = 1;
        self.addGestureRecognizer(boxPan);
        //add a pan gesture to cornerView
        let cornerPan : UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleCornerPan(sender:)));
        cornerPan.maximumNumberOfTouches = 1;
        self.addGestureRecognizer(cornerPan);
        cornerDragView.addGestureRecognizer(cornerPan);
    }
    
    //MARK: Resizing
    //Triggered on frame resize, move cornerDragView accordingly
    override var frame: CGRect{
        didSet{
            cornerDragView.frame.origin.x = self.frame.width-CGFloat(cornerSize);
            cornerDragView.frame.origin.y = self.frame.height-CGFloat(cornerSize);
        }
    }
    
    //MARK: Gestures
    func handleTap(action: UITapGestureRecognizer) {
    }
    
    func handleCornerPan(sender: UIPanGestureRecognizer) {
        switch sender.state{
        //state for when pan just started, create a new view to be maniuplated here
        case .began:
            resetXY();
            break;
            
        //state when a pan movement has occured
        case .changed:
            //translation is the amount of movement that occured
            let translation = sender.translation(in: self)                //add to total amount moved
            currentTotalX += translation.x;
            currentTotalY += translation.y;
            //if total amount moved exceeds threshold, resize view, reset total moved when done
            if(abs(currentTotalX) > increment && self.frame.size.width + currentTotalX > 0){
                self.frame.size.width += roundToNearest(x: currentTotalX);
                currentTotalX = 0;
            }
            if(abs(currentTotalY) > increment && self.frame.size.height + currentTotalY > 0){
                self.frame.size.height += roundToNearest(x: currentTotalY);
                currentTotalY = 0;
                
            }
            break;
            
        //state when pan action has ended
        case .ended:
            resetXY();
            break;
        default:
            print("Other state");
        }
        //reset translation so it doesn't accumulate
        sender.setTranslation(CGPoint.zero, in: self);
        
    }
    
    func handleBoxPan(sender: UIPanGestureRecognizer){
        switch sender.state{
        //state for when pan just started, create a new view to be maniuplated here
        case .began:
            resetXY();
            break;
            
        //state when a pan movement has occured
        case .changed:
            //translation is the amount of movement that occured
            let translation = sender.translation(in: self)                //add to total amount moved
            currentTotalX += translation.x;
            currentTotalY += translation.y;
            //if total amount moved exceeds threshold, move view, reset total moved when done
            if(abs(currentTotalX) > increment){
                self.frame.origin.x += roundToNearest(x: currentTotalX);//+(roundToNearest(x: currentTotalX)/4);
                currentTotalX = 0;
            }
            if(abs(currentTotalY) > increment){
                self.frame.origin.y += roundToNearest(x: currentTotalY);//+(roundToNearest(x: currentTotalY)/4);
                currentTotalY = 0;
                
            }
            break;
            
        //state when pan action has ended
        case .ended:
            resetXY();
            break;
        default:
            print("Other state");
        }
        //reset translation so it doesn't accumulate
        sender.setTranslation(CGPoint.zero, in: self);

    }
    
    //MARK: Methods
    func viewToData() {
        
    }
    
    //MARK: Convenience
    //TODO: DUPLICATE CODE FROM BOXVIEWCONTROLLER, MAKE A COMMON FUNCTIONS CLASS
    func roundToNearest(x : CGFloat) -> CGFloat {
        let jee = increment * CGFloat(round(x / increment));
        //print("Rounded \(x) to \(jee)");
        return jee;
    }
    
    func resetXY() {
        currentTotalX = 0;
        currentTotalY = 0;
    }
    
}
