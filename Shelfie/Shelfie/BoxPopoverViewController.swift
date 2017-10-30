//
//  BoxPopoverViewController.swift
//  Shelfie
//
//  Created by iosdev on 3.10.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import UIKit

class BoxPopoverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var selectedBoxView : BoxView?;
    var parentCtrl : BoxViewController?;
    @IBOutlet weak var popoverTable: UITableView!
    @IBOutlet weak var delBtn: UIButton!
    var productsArr : [Product] = [];
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        popoverTable.delegate = self;
        popoverTable.dataSource = self;
        fetchProducts();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchProducts();
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
        cell.titleLabel.text = productsArr[indexPath.row].name;
        let b = productsArr[indexPath.row].brand;
        cell.subtitleLabel.text = b?.name;
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //temporary dataset, change to products / categories later
        return productsArr.count;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //change selected box color to matching color from list
        if(selectedBoxView != nil){
            let bg = UIColor(patternImage:Tools.categoryImageDict[Int(productsArr[indexPath.row].category)]!);
            selectedBoxView!.backgroundColor = bg;
            selectedBoxView?.boxNameLabel.text = productsArr[indexPath.row].name;
            selectedBoxView?.product = productsArr[indexPath.row];
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
    
    func fetchProducts(){
        productsArr = CoreDataSingleton.sharedInstance.fetchEntitiesFromCoreData("Product") as! [Product];
        popoverTable.reloadData();
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
