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
    var productAreaDict: [Product: Int] = [:];
    var fairShare: [Product: Double] = [:];
    var emptiesArea: Int = 0;
    var totalShelfSpace = 0;
    var totalProductsArea = 0;
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*if let shelp = Array(storesArray[indexPath.row].shelfPlans!) as? [ShelfPlan]{
         
         }*/
        let selectedStore = storesArray[indexPath.row];
        calcTotalSpaceOnShelf(selectedStore);
        calcNumberOfProducts(selectedStore);
        calcFairShare();
    }
    
    func fetchData(){
        storesArray = CoreDataSingleton.sharedInstance.fetchEntitiesFromCoreData("Store") as! [Store];
        storesTableView.reloadData();
    }
    
    //MARK: Calculations
    func calcTotalSpaceOnShelf(_ store: Store){
        //module width * single shelf height * number of shelves on module
        totalShelfSpace = Int(store.shelfWidth) * 8 * 4 * 3;
        testTextView.text = testTextView.text + "Shelf is the size of: \(totalShelfSpace)\n\n";
    }
    
    func calcNumberOfProducts(_ store: Store){
        //sort shelfplans by newest
        if let shelfPlans = store.shelfPlans!.sortedArray(using: [NSSortDescriptor(key: "date", ascending: false)]) as? [ShelfPlan]{
            if shelfPlans.count > 0{
                calcAreaOfProductsIn(shelfPlans[0]);
            }
        }
    }
    
    func calcFairShare(){
        print("TotalAreaOfProducts: \(totalProductsArea)");
        for (prod,area) in productAreaDict {
            let shareOfTotalProductSpace = Double(Double(area) / Double(totalProductsArea));
            print("Area: \(area))");
            fairShare[prod] = shareOfTotalProductSpace;
            testTextView.text = testTextView.text + "Fairshare for \(prod.name!): \(shareOfTotalProductSpace*100)%, with area of \(area)\n";
        }
    }
    
    
    
    func calcAreaOfProductsIn(_ shelfPlan: ShelfPlan){
        //empty the dict and reset emptiescount & totalProductsArea
        productAreaDict = [:];
        emptiesArea = 0;
        totalProductsArea = 0;
        //convert nsset to array of type Shelfbox
        if let boxes = Array(shelfPlan.boxes!) as? [ShelfBox]{
            //loop through all boxes
            for sb in boxes {
                //if the box has a product, proceed
                if let prod = sb.product{
                    //if the product has been encountered before, increase the area it takes up on the shelf
                    if let val = productAreaDict[prod]{
                        productAreaDict[prod] = val + Int(sb.width*sb.height);
                    }
                        //if product has not been encountered before, make a new entry and set amount to its area
                    else {
                        productAreaDict[prod] = Int(sb.width*sb.height);
                    }
                }
                    //if box doesnt have a product, it is an empty space, increase empty counter
                else{
                    emptiesArea = emptiesArea + Int(sb.width*sb.height);
                }
                totalProductsArea = totalProductsArea + Int(sb.width*sb.height);
            }
        }
        print("CALCS DONE!");
        testTextView.text = testTextView.text + "Total area of products: \(totalProductsArea)\n\n";
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
