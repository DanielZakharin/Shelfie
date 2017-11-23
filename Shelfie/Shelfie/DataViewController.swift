//
//  DataViewController.swift
//  Shelfie
//
//  Created by iosdev on 12.11.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import UIKit
import CoreData
import PieCharts
import ChartLegends

class DataViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PieChartDelegate{
    
    @IBOutlet weak var pie1: PieChart!
    @IBOutlet weak var pie2: PieChart!
    @IBOutlet weak var pie3: PieChart!
    
    @IBOutlet weak var pietestlegend: ChartLegendsView!
    
    @IBOutlet weak var storesTableView: UITableView!
    var storesArray: [Store] = [];
    //    var productAreaDict: [Product: Int] = [:];
    //    var fairShare: [Product: Double] = [:];
    //    var emptiesArea: Int = 0;
    var totalShelfSpace = 0;
    //    var totalProductsArea = 0;
    
    var wcPapers: [ShelfBox] = [];
    var hoPapers: [ShelfBox] = [];
    var hankies: [ShelfBox] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        storesTableView.delegate = self;
        storesTableView.dataSource = self;
        fetchData();
        
        formatPieChart(pie1);
        formatPieChart(pie2);
        formatPieChart(pie3);
        
        //pietestlegend.setLegends([("jeeben",UIColor.red)]);
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
        let selectedStore = storesArray[indexPath.row];
        clearCharts();
        configPieCharts(selectedStore);
    }
    
    func fetchData(){
        storesArray = CoreDataSingleton.sharedInstance.fetchEntitiesFromCoreData("Store") as! [Store];
        storesTableView.reloadData();
    }
    
    func configPieCharts(_ selectedStore: Store){
        calcTotalSpaceOnShelf(selectedStore);
        //sort by type of product
        sortByCategories(selectedStore);
        //sort by brand
        //populate pies with sorted arrays
        populatePieChart(wcPapers, pie: pie1);
        populatePieChart(hoPapers, pie: pie2);
        populatePieChart(hankies, pie: pie3);
    }
    
    func sortByCategories(_ store: Store){
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
                        }
                    }
                }
            }
        }
//        print("Hankies \(hankies.count) ho: \(hoPapers.count) wc: \(wcPapers.count)");
    }
    
    func sortByBrand(_ boxes: [ShelfBox]) -> [ProductBrand:Double] {
        var tempDict : [ProductBrand:Double] = [:];
        for box in boxes {
            if let prod = box.product {
                if let brand = box.product?.brand {
                    if var i = tempDict[brand] {
                        i += Double(box.width*box.height);
                    }else {
                        tempDict[brand] = Double(box.width*box.height);
                    }
                }
            }
        }
        return tempDict;
    }
    
    func populatePieChart(_ boxes : [ShelfBox], pie: PieChart){
        let dict = sortByBrand(boxes);
        var models: [PieSliceModel] = []
        var cols = [UIColor.red,UIColor.blue, UIColor.green, UIColor.brown, UIColor.yellow, UIColor.cyan];
        var i = 0;
        for (brand, value) in dict {
            models.append(PieSliceModel(value: value, color: cols[i]))
            i += 1;
            //todo make legend for each brand
        }
        pie.models = models;
    }
    
    //MARK: Calculations
    func calcTotalSpaceOnShelf(_ store: Store){
        //module width * single shelf height * number of shelves on module
        totalShelfSpace = Int(store.shelfWidth) * 8 * 4 * 3;
    }
    
    //    func calcNumberOfProducts(_ store: Store){
    //        //sort shelfplans by newest
    //        if let shelfPlans = store.shelfPlans!.sortedArray(using: [NSSortDescriptor(key: "date", ascending: false)]) as? [ShelfPlan]{
    //            if shelfPlans.count > 0{
    //                calcAreaOfProductsIn(shelfPlans[0]);
    //            }
    //        }
    //    }
    
    func calcFairShare(_ boxes : [ShelfBox]){
        //        print("TotalAreaOfProducts: \(totalProductsArea)");
        //        var col = [UIColor.blue, UIColor.red, UIColor.yellow, UIColor.brown];
        //        var i = 0;
        //        var
        //        var modelData: [PieSliceModel] = [];
        //        for (prod,area) in productAreaDict {
        //            let shareOfTotalProductSpace = Double(Double(area) / Double(totalProductsArea));
        //            print("Area: \(area)) + \(i)");
        //            fairShare[prod] = shareOfTotalProductSpace;
        //            modelData.append(PieSliceModel(value: shareOfTotalProductSpace, color: col[i]));
        //            i = i + 1;
        //        }
        //        pie2.models = modelData;
        let totalArea = calcAreaOfBoxes(boxes);
        
    }
    
    
    
    //    func calcAreaOfProducts(_ boxes: [ShelfBox]) -> [Product:Int]{
    //        //empty the dict and reset emptiescount & totalProductsArea
    //        var productAreaDictionary:[Product:Int] = [:];
    //        emptiesArea = 0;
    //        var totalProductsArea = 0;
    //        //loop through all boxes
    //        for sb in boxes {
    //            //if the box has a product, proceed
    //            if let prod = sb.product{
    //                //if the product has been encountered before, increase the area it takes up on the shelf
    //                if let val = productAreaDict[prod]{
    //                    productAreaDictionary[prod] = val + Int(sb.width*sb.height);
    //                }
    //                    //if product has not been encountered before, make a new entry and set amount to its area
    //                else {
    //                    productAreaDictionary[prod] = Int(sb.width*sb.height);
    //                }
    //            }
    //                //if box doesnt have a product, it is an empty space, increase empty counter
    //            else{
    //                emptiesArea = emptiesArea + Int(sb.width*sb.height);
    //            }
    //            totalProductsArea = totalProductsArea + Int(sb.width*sb.height);
    //        }
    //
    //    }
    
    func calcAreaOfBoxes(_ boxes : [ShelfBox]) -> Double{
        var area:Double = 0;
        for box in boxes {
            area += Double(box.width * box.height);
        }
        return area;
    }
    
    func formatPieChart(_ pieChart: PieChart) {
        pieChart.outerRadius = (min(pieChart.frame.height, pieChart.frame.width) - 10)/2.2;
        pieChart.innerRadius = 0;
        let textLayerSettings = PiePlainTextLayerSettings();
        textLayerSettings.viewRadius = pie2.outerRadius/2;
        textLayerSettings.hideOnOverflow = false;
        
        let formatter = NumberFormatter();
        formatter.maximumFractionDigits = 0;
        textLayerSettings.label.textGenerator = {slice in
            return formatter.string(from: slice.data.percentage * 100 as NSNumber).map{"\($0)%"} ?? ""
        }
        
        let textLayer = PiePlainTextLayer();
        //textLayer.animator = AlphaPieViewLayerAnimator();
        textLayer.settings = textLayerSettings;
        pieChart.layers = [textLayer];
        pieChart.setNeedsDisplay();
        pieChart.delegate = self;
    }
    
    //MARK: pie delegate
    func onSelected(slice: PieSlice, selected: Bool) {
        print(slice.data.percentage);
    }
    
    func clearCharts(){
        pie1.models = [];
        pie2.models = [];
        pie3.models = [];
        
        pie1.removeSlices();
        pie2.removeSlices();
        pie3.removeSlices();
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
