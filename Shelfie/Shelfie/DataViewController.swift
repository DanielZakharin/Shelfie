//
//  DataViewController.swift
//  Shelfie
//
//  Created by iosdev on 12.11.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import UIKit
import CoreData
import Charts

class DataViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var pie1: PieChartView!
    @IBOutlet weak var pie2: PieChartView!
    @IBOutlet weak var pie3: PieChartView!
    var selectionActive = false;
    
    
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
    var selectedCat: Int16 = 0;
    
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
        let selectedStore = storesArray[indexPath.row];
        clearCharts();
        configPieCharts(selectedStore);
        selectionActive = true;
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
        populatePieChart(hankies, pie: pie3, label:"Hankies");
        populatePieChart(wcPapers, pie: pie1, label:"WC-Papers");
        populatePieChart(hoPapers, pie: pie2, label: "Household Papers");
    }
    
    func sortByCategories(_ store: Store){
        hoPapers = [];
        wcPapers = [];
        hankies = [];
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
    
    func sortByManufacturer(_ boxes: [ShelfBox]) -> [Manufacturer:Double] {
        var tempDict : [Manufacturer:Double] = [:];
        for box in boxes {
            if let prod = box.product {
                if let manu = box.product?.brand?.manufacturer {
                    if var i = tempDict[manu] {
                        i += Double(box.width*box.height);
                    }else {
                        tempDict[manu] = Double(box.width*box.height);
                    }
                }
            }
        }
        return tempDict;
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
        }
    }
}
