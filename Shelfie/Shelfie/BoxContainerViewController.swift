//
//  BoxContainerViewController.swift
//  Shelfie
//
//  Created by iosdev on 4.10.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import UIKit

/*
 View Where BoxViewController is a subview, also has store selection
 */

class BoxContainerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var editingModeSelector: UISegmentedControl!
    @IBOutlet weak var boxViewCont: BoxViewController!
    
    @IBOutlet weak var storeSelectTable: UITableView!
    @IBOutlet weak var datesPickerView: UIPickerView!
    var storesArray:[Store] = [];
    var shelfPlans:[ShelfPlan] = [];
    var lastSelectedRow: Int = 0;
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        boxViewCont.parentCtrl = self;
        storeSelectTable.delegate = self;
        storeSelectTable.dataSource = self;
        datesPickerView.delegate = self;
        datesPickerView.dataSource = self;
        fetchData();
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        storesArray = CoreDataSingleton.sharedInstance.fetchEntitiesFromCoreData("Store") as! [Store];
        storeSelectTable.reloadData();
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
        lastSelectedRow = indexPath.row;
        //TODO: load selected stores shelfplans
        loadShelfPlansIntoPicker();
        datesPickerView.reloadAllComponents();
    }
    
    //MARK: PickerView Methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let formatter = DateFormatter();
        let format = "dd.MM.yyyy hh.mm";
        formatter.dateFormat = format;
        let date = shelfPlans[row].date! as Date;
        return formatter.string(from: date);
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return shelfPlans.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    @IBAction func loadButtonAction(_ sender: UIButton) {
        let selectedPlan = shelfPlans[datesPickerView.selectedRow(inComponent: 0)];
        boxViewCont.populateShelfFromPlan(selectedPlan);
    }
    
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        saveShelf();
        fetchData();
    }
    @IBAction func newButtonAction(_ sender: UIButton) {
        boxViewCont.clearShelf();
    }
    
    func saveShelf(){
        if(boxViewCont.boxesArr.count > 0){
            let shelfWrapper = boxViewCont.convertSelfToWrapper(store: storesArray[lastSelectedRow]);
            CoreDataSingleton.sharedInstance.createShelfPlan(shelfWrapper);
        }else {
            let confirmAlert = UIAlertController(title: "Shelf is empty", message: "The shelf is empty, save anyway?", preferredStyle: UIAlertControllerStyle.alert)
            
            confirmAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                let shelfWrapper = self.boxViewCont.convertSelfToWrapper(store: self.storesArray[self.lastSelectedRow]);
                CoreDataSingleton.sharedInstance.createShelfPlan(shelfWrapper);
            }))
            
            confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil));
            
            present(confirmAlert, animated: true, completion: nil)
        }
    }
    
    func fetchData(){
        storesArray = CoreDataSingleton.sharedInstance.fetchEntitiesFromCoreData("Store") as! [Store];
        storeSelectTable.reloadData();
        loadShelfPlansIntoPicker();
    }
    
    func loadShelfPlansIntoPicker(){
        let s = storesArray[lastSelectedRow];
        if let plansArray = s.shelfPlans{
            let sortedarr = plansArray.sortedArray(using: [NSSortDescriptor(key: "date", ascending: false)]) as! [ShelfPlan];
            self.shelfPlans = sortedarr;//Array(plansArray) as! [ShelfPlan];
        }
        datesPickerView.reloadAllComponents();
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
