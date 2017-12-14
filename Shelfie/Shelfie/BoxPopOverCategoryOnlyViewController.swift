//
//  BoxPopOverCategoryOnlyViewController.swift
//  Shelfie
//
//  Created by iosdev on 21.10.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import UIKit

/*
 Popover for unfinished category only boxviewcontroller, would display a list of only categories
 */

class BoxPopOverCategoryOnlyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var selectedBoxView : BoxView?;
    var parentCtrl : BoxViewController?;
    @IBOutlet weak var popoverTable: UITableView!
    @IBOutlet weak var delBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        popoverTable.delegate = self;
        popoverTable.dataSource = self;
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: TableView methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BoxPopoverTableCell", for: indexPath) as? BoxPopOverTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        // Configure the cell...
        cell.titleLabel.text = Tools.categoryNameDict[indexPath.row];
        cell.subtitleLabel.text = "";
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //temporary dataset, change to products / categories later
        return 3;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //change selected box color to matching color from list
        if(selectedBoxView != nil){
            selectedBoxView!.backgroundColor = Tools.categoryColorDict[indexPath.row];
            selectedBoxView?.boxNameLabel.text = Tools.categoryNameDict[indexPath.row];
        }
        parentCtrl!.dismissPopOver(ctrl: self);
        //need to manually deselect row
        tableView.deselectRow(at: indexPath, animated: false);
    }
    
    
    @IBAction func delBtnAction(_ sender: UIButton) {
        //delete the view from here
        selectedBoxView!.removeFromSuperview();
        selectedBoxView = nil;
        parentCtrl?.dismissPopOver(ctrl: self);
    }
    

}
