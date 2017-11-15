//
//  DataViewController.swift
//  Shelfie
//
//  Created by iosdev on 12.11.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import UIKit
import CoreData

class DataViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var testTextView: UITextView!
    @IBOutlet weak var storesTableView: UITableView!
    var storesArray: [Store] = [];
    var productCountDict: [Product: Int] = [:];
    var emptiesCount: Int = 0;
    var totalShelfSpace = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        storesTableView.delegate = self;
        storesTableView.dataSource = self;
        fetchData();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: TableView Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BoxStoreSelect", for: indexPath) as? BoxStoreSelectTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        // Configure the cell...
        cell.labelUpper.text = storesArray[indexPath.row].storeName;
        var label2Text = "Unknown Store Chain";
        if let storeChainForRow = storesArray[indexPath.row].storeChain {
            label2Text = storeChainForRow.storeChainName!;
        }
        cell.labelLower.text = label2Text;
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storesArray.count;
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let shelp = Array(storesArray[indexPath.row].shelfPlans!) as? [ShelfPlan]{
            //calcTest(shelp[0]);
        }
    }
    
    func fetchData(){
        storesArray = CoreDataSingleton.sharedInstance.fetchEntitiesFromCoreData("Store") as! [Store];
        storesTableView.reloadData();
    }
    
    //MARK: Calculations
    func calcTotalSpaceOnShelf(){
        
    }
    
    /*func calcTest(_ shelfPlan: ShelfPlan){
        //convert nsset to array of type Shelfbox
        if let boxes = Array(shelfPlan.boxes!) as? [ShelfBox]{
            //loop through all boxes
            for sb in boxes {
                //if the box has a product, proceed
                if let prod = sb.product{
                    //if the product has been encountered before, increase count
                    if let val = productCountDict[prod]{
                        productCountDict[prod] = val + 1;
                    }
                    //if product has not been encountered before, make a new entry and set amount to 1
                    else {
                        productCountDict[prod] = 1;
                    }
                }
                //if box doesnt have a product, it is an empty space, increase empty counter
                else{
                    emptiesCount+=1;
                }
            }
        }
        print("CALCS DONE!");
    }*/
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
