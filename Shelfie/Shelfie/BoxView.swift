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
    var cornerDragView: UIImageView;
    var boxNameLabel: UILabel;
    let cornerSize = Double(Tools.increment);
    var currentTotalX:CGFloat = 0;
    var currentTotalY:CGFloat = 0;
    let increment:CGFloat = Tools.increment;
    var incrementX : Int = 1;
    var incrementY : Int = 1;
    var product : Product?;
    
    //MARK: Init
    
    override init(frame: CGRect) {
        //programatical init
        cornerDragView = UIImageView();
        boxNameLabel = UILabel();
        super.init(frame: frame);
        initialize();
    }
    
    required init?(coder aDecoder: NSCoder) {
        //storyboard init
        cornerDragView = UIImageView();
        boxNameLabel = UILabel();
        super.init(coder: aDecoder)
        initialize();
    }
    
    //initialize BoxView and add cornerDragView to it
    func initialize(){
        //default color of the box is gray, meaning an empty space
        self.backgroundColor = UIColor.darkGray;
        self.layer.borderWidth = 3;
        self.layer.borderColor = UIColor.black.cgColor;
        //set the userinteraction to enabled, uiimageviews have this set to disabled as default
        cornerDragView.isUserInteractionEnabled = true;
        //set the size of the corner piece, it is at minimum 1x1 increments, so that if the box is at its smallest size, it can still be resized
        cornerDragView.frame = CGRect(x: Double(self.frame.width-CGFloat(cornerSize)), y: Double(self.frame.height-CGFloat(cornerSize)), width: cornerSize, height: cornerSize);
        cornerDragView.image = UIImage(named: "rescale")!;
        cornerDragView.contentMode = .scaleAspectFit;
        self.addSubview(cornerDragView);
        //bring views to front of the main view
        self.bringSubview(toFront: cornerDragView);
        self.superview?.bringSubview(toFront: self);
        //add  pan gesture to box
        let boxPan : UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleBoxPan(sender:)));
        //set maximum number of touches so that scrolling of the scrollview can still occur when using two fingers on the box
        boxPan.maximumNumberOfTouches = 1;
        self.addGestureRecognizer(boxPan);
        //add a pan gesture to cornerView
        let cornerPan : UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleCornerPan(sender:)));
        cornerPan.maximumNumberOfTouches = 1;
        self.addGestureRecognizer(cornerPan);
        cornerDragView.addGestureRecognizer(cornerPan);
        initLabel();
    }
    
    func initLabel(){
        //add label for product name
        boxNameLabel.text = "None";
        boxNameLabel.textColor = UIColor.red;
        boxNameLabel.adjustsFontSizeToFitWidth = true;
        boxNameLabel.isUserInteractionEnabled = false;
        boxNameLabel.textAlignment = .center;
        self.addSubview(boxNameLabel);
        boxNameLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100);
        boxNameLabel.center = CGPoint(x: self.frame.width/2, y: self.frame.height/2);//self.convert(self.center, to: self.superview);
        self.bringSubview(toFront: boxNameLabel);
    }
    
    //MARK: Resizing
    //Triggered on frame resize, move cornerDragView accordingly, redraw label to new center
    override var frame: CGRect{
        didSet{
            cornerDragView.frame.origin.x = self.frame.width-CGFloat(cornerSize);
            cornerDragView.frame.origin.y = self.frame.height-CGFloat(cornerSize);
            //boxNameLabel.center = self.convert(self.center, to: self.superview);
            boxNameLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 50);
            boxNameLabel.center = CGPoint(x: self.frame.width/2, y: self.frame.height/2);
        }
    }
    
    //MARK: Gestures
    //triggered when corner is panned, resizes box
    @objc func handleCornerPan(sender: UIPanGestureRecognizer) {
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
//                print("currentTotalX = \(currentTotalX)");
                if(currentTotalX > 0){
                    increaseSizeByX(1);
                }else {
                    increaseSizeByX(-1);
                }
                //print("increment = \(incrementX)");
                currentTotalX = 0;
            }
            if(abs(currentTotalY) > increment && self.frame.size.height + currentTotalY > 0){
                if(currentTotalY > 0){
                    increaseSizeByY(1);
                }else {
                    increaseSizeByY(-1);
                }
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
    
    //triggered when box view itself is panned, moves box around
    @objc func handleBoxPan(sender: UIPanGestureRecognizer){
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
                self.frame.origin.x += Tools.roundToNearest(x: currentTotalX);//+(roundToNearest(x: currentTotalX)/4);
                currentTotalX = 0;
            }
            if(abs(currentTotalY) > increment){
                self.frame.origin.y += Tools.roundToNearest(x: currentTotalY);//+(roundToNearest(x: currentTotalY)/4);
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
    func boxToData() {
        print("Size off this box is \(incrementX) x \(incrementY)");
    }
    
    
    //helper methods for resizing consistantly
    func increaseSizeByX(_ xIncrements: CGFloat){
        self.frame.size.width += CGFloat(xIncrements)*increment;
        incrementX += Int(xIncrements);
    }
    
    func increaseSizeByY(_ yIncrements: CGFloat){
        self.frame.size.height += CGFloat(yIncrements)*increment;
        incrementY += Int(yIncrements);
    }
    
    func increaseSizeBy(_ xIncrements: CGFloat, _ yIncrements: CGFloat){
        increaseSizeByX(xIncrements);
        increaseSizeByY(yIncrements);
        incrementY += Int(yIncrements);
        incrementX += Int(xIncrements);
    }
    
    func resetXY() {
        currentTotalX = 0;
        currentTotalY = 0;
    }
    
    //converts self to a wrapper
    func convertToWrapper() -> BoxWrapper{
        let wrapper = BoxWrapper();
        wrapper.size = convertSizeToIncrements();
        wrapper.product = product;
        return wrapper;
    }
    
    //converts coordinates and size to a multiple of increments, since actual size and place may differ
    //depending on device screen size
    //this is then used to reconvert to increments sizes when loaded from memeory
    func convertCoordinatesToIncrements() -> CGPoint{
        let x = Int(self.frame.origin.x/increment);
        let y = Int(self.frame.origin.y/increment);
        return CGPoint(x: x, y: y);
    }
    
    
    func convertSizeToIncrements() -> CGRect{
        let w = Int(self.frame.width/increment);
        let h = Int(self.frame.height/increment);
        return CGRect(origin: convertCoordinatesToIncrements(), size: CGSize(width: w, height: h));
    }
    
    //sets a product for a box and styles it accordingly
    func setProducForBox(_ to: Product){
        self.product = to;
        let bg = Tools.categoryColorDict[Int(to.category)];//UIColor(patternImage:Tools.categoryImageDict[Int(to.category)]!);
        self.backgroundColor = bg;
        self.boxNameLabel.text = to.name;
    }
    
}
