//
//  DataViewController.swift
//  Shelfie
//
//  Created by iosdev on 12.11.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

/*
 Controller that calculates fair share percentages for a store based on its newest shelfplan
 Displays data in piecharts that when tapped take the user to a more detailed view
 */

import UIKit
import CoreData
import Charts

class DataViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var pie1: PieChartView!
    @IBOutlet weak var pie2: PieChartView!
    @IBOutlet weak var pie3: PieChartView!
    var selectionActive = false;
    @IBOutlet weak var storesTableView: UITableView!
    @IBOutlet weak var emptySpaceLabel: MetsaLabel!
    var storesArray: [Store] = [];
    //    var productAreaDict: [Product: Int] = [:];
    //    var fairShare: [Product: Double] = [:];
    //    var emptiesArea: Int = 0;
    var totalShelfSpace = 0;
    var totalProductsArea: Double = 0;
    
    var wcPapers: [ShelfBox] = [];
    var hoPapers: [ShelfBox] = [];
    var hankies: [ShelfBox] = [];
    var empties: [ShelfBox] = [];
    var selectedCat: Int16 = 0;
    var selectedStore: Store = Store();
    
    var dataToPass : [ShelfBox] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        storesTableView.delegate = self;
        storesTableView.dataSource = self;
        formatPieCharts();
        fetchData();
        clearCharts();
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
        selectedStore = storesArray[indexPath.row];
        clearCharts();
        displayData(selectedStore);
        selectionActive = true;
    }
    
    func fetchData(){
        storesArray = CoreDataSingleton.sharedInstance.fetchEntitiesFromCoreData("Store") as! [Store];
        storesTableView.reloadData();
    
    }
    
    func displayData(_ selectedStore: Store){
        calcTotalSpaceOnShelf(selectedStore);
        //sort by type of product
        sortByCategories(selectedStore);
        //sort by brand
        //populate pies with sorted arrays
        populatePieChart(hankies, pie: pie3, label:"Hankies");
        populatePieChart(wcPapers, pie: pie1, label:"WC-Papers");
        populatePieChart(hoPapers, pie: pie2, label: "Household Papers");
        
        emptySpaceLabel.text = "Percentage of shelf empty:\n\(Int((calcEmptySpace(boxes: empties)/Double(totalProductsArea))*100))%"
    }
    
    func sortByCategories(_ store: Store){
        hoPapers = [];
        wcPapers = [];
        hankies = [];
        empties = [];
        if let shelfPlans = store.shelfPlans!.sortedArray(using: [NSSortDescriptor(key: "date", ascending: false)]) as? [ShelfPlan]{
            if shelfPlans.count > 0{
                if let boxes = Array(shelfPlans[0].boxes!) as? [ShelfBox]{
                    for box in boxes {
                        if let product = box.product{
                            switch product.category {
                            case 0:
                                hankies.append(box);
                                break;
                            case 1:
                                wcPapers.append(box);
                                break;
                            case 2:
                                hoPapers.append(box);
                                break;
                            default:
                                break;
                            }
                        }else {
                            empties.append(box);
                        }
                        totalProductsArea += Double(box.width + box.height);
                    }
                }
            }
        }
        //        print("Hankies \(hankies.count) ho: \(hoPapers.count) wc: \(wcPapers.count)");
    }
    
    func sortByManufacturer(_ boxes: [ShelfBox]) -> [Manufacturer:Double] {
        var tempDict : [Manufacturer:Double] = [:];
        for box in boxes {
            if let prod = box.product {
                if let manu = box.product?.brand?.manufacturer {
                    if var i = tempDict[manu] {
                        i += Double(box.width*box.height);
                        tempDict[manu] = i;
                    }else {
                        tempDict[manu] = Double(box.width*box.height);
                    }
                }
            }else {
                
            }
        }
        return tempDict;
    }
    
    func calcEmptySpace(boxes: [ShelfBox])-> Double {
        var emptySpace: Double = 0;
        for box in boxes {
            if let product = box.product {
            }else {
                print("found empty space");
                emptySpace += Double(box.width * box.height);
            }
        }
        return emptySpace;
    }
    
    func populatePieChart(_ boxes : [ShelfBox], pie: PieChartView, label: String){
        let dict = sortByManufacturer(boxes);
        var entries:[PieChartDataEntry] = [];
        var colors:[NSUIColor] = [];
        for (brand, value) in dict {
            if(brand.name?.lowercased() == "metsä" || brand.name?.lowercased() == "metsa"){
                colors.append(Tools.colors.metsaGreenPrimary);
            }else {
                colors.append(Tools.generateRandomColor());
            }
            entries.append(PieChartDataEntry(value: value,
                                             label: brand.name,
                                             icon: nil));
        }
        
        let set = PieChartDataSet(values: entries, label: "")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        set.colors = colors;
//        set.colors = ChartColorTemplates.vordiplom()
//            + ChartColorTemplates.joyful()
//            + ChartColorTemplates.colorful()
//            + ChartColorTemplates.liberty()
//            + ChartColorTemplates.pastel()
//            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        let data = PieChartData(dataSet: set);
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        pie.data = data
        pie.chartDescription?.enabled = true;
        pie.chartDescription?.text = label;
    }
    
    //MARK: Calculations
    func calcTotalSpaceOnShelf(_ store: Store){
        //module width * single shelf height * number of shelves on module
        totalShelfSpace = Int(store.shelfWidth) * 8 * 4 * 3;
    }
    
    func calcAreaOfBoxes(_ boxes : [ShelfBox]) -> Double{
        var area:Double = 0;
        for box in boxes {
            area += Double(box.width * box.height);
        }
        return area;
    }
    
    /*
     Styles the  piecharts and adds a tap gesture to each one
     */
    func formatPieCharts() {
        pie1.drawHoleEnabled = false;
        pie1.usePercentValuesEnabled = true;
        pie1.chartDescription?.text = "WC-Papers";
        pie1.setNeedsDisplay();
        pie2.drawHoleEnabled = false;
        pie2.usePercentValuesEnabled = true;
        pie2.chartDescription?.text = "Household Papers";
        pie2.setNeedsDisplay();
        pie3.drawHoleEnabled = false;
        pie3.usePercentValuesEnabled = true;
        pie3.chartDescription?.text = "Hankies";
        pie3.setNeedsDisplay();
        
        //each pie needs its own gesture recognizer because apple
        pie1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePieTap(sender:))));
        pie2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePieTap(sender:))));
        pie3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePieTap(sender:))));

    }
    
    /*
     Clears and resets the piecharts
     */
    func clearCharts(){
        pie1.data = nil;
        pie2.data = nil;
        pie3.data = nil;
        
        pie1.data = PieChartData(dataSet: PieChartDataSet(values: nil, label: nil));
        pie2.data = PieChartData(dataSet: PieChartDataSet(values: nil, label: nil));
        pie3.data = PieChartData(dataSet: PieChartDataSet(values: nil, label: nil));
        
        pie1.notifyDataSetChanged();
        pie2.notifyDataSetChanged();
        pie3.notifyDataSetChanged();
    }
    
    /*
     Tap handler for piecharts, switches screen to a detailed view, sets the passed data and other parameters
     for the receiving controller
     */
    @objc func handlePieTap(sender: UITapGestureRecognizer) {
        let v = sender.view;
        if(v == pie1){
            print("pie1");
            dataToPass = wcPapers;
            selectedCat = 1;
        }
        else if (v == pie2){
            print("pie2");
            dataToPass = hoPapers;
            selectedCat = 2;
        }
        else if (v == pie3){
            dataToPass = hankies;
            print("pie3");
            selectedCat = 0;
        }
        if(selectionActive){
            self.performSegue(withIdentifier: "BarChartsSegue", sender: self);
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "BarChartsSegue"){
            let destinationCont = segue.destination as! DataBarChartViewController;
            destinationCont.dataz = dataToPass;
            destinationCont.category = selectedCat;
            destinationCont.store = selectedStore;
        }
    }
}
