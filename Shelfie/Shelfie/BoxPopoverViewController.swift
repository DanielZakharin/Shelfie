//
//  BoxPopoverViewController.swift
//  Shelfie
//
//  Created by iosdev on 3.10.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import UIKit

class BoxPopoverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let colorsList = [UIColor.red, UIColor.blue, UIColor.green, UIColor.brown];
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
        cell.titleLabel.text = "Color \(indexPath.row)";
        cell.backgroundColor = colorsList[indexPath.row];
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colorsList.count;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(selectedBoxView != nil){
            selectedBoxView!.backgroundColor = colorsList[indexPath.row];
        }
        parentCtrl!.dismisstest(ctrl: self);
        tableView.deselectRow(at: indexPath, animated: false);
    }
    
    
    @IBAction func delBtnAction(_ sender: UIButton) {
        //delete the view from here
        selectedBoxView!.removeFromSuperview();
        selectedBoxView = nil;
        parentCtrl?.dismisstest(ctrl: self);
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
