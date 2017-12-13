//
//  DataBarChartViewController.swift
//  Shelfie
//
//  Created by iosdev on 23.11.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import UIKit
import Charts

class DataBarChartViewController: UIViewController {
    
    var dataz : [ShelfBox] = [];
    var category:Int16 = 0;
    var store: Store = Store();
    
    @IBOutlet weak var bar1: BarChartView!
    @IBOutlet weak var bar2: BarChartView!
    @IBOutlet weak var bar3: BarChartView!
    @IBOutlet weak var bar4: BarChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        var l = BarChartView(frame: self.view.bounds);
//        var i = BarChartDataEntry(x: 1.0, yValues: [1.0,2.0]);
//        var asd = BarChartDataSet(values: [i], label: "test");
//        var jjj = BarChartData(dataSet: asd);
//        l.data = jjj;
//        l.leftAxis.drawAxisLineEnabled = false;
//        l.leftAxis.drawGridLinesEnabled = false;
//        l.rightAxis.drawAxisLineEnabled = false;
//        l.rightAxis.drawGridLinesEnabled = false;
//        l.xAxis.drawAxisLineEnabled = false;
//        l.xAxis.drawGridLinesEnabled = false;
//        l.xAxis.drawAxisLineEnabled = false;
//        l.xAxis.drawGridLinesEnabled = false;
        
        //self.view.addSubview(l);
        formatBars(bar1, "Brand Shares of Most Recent Entry");
        formatBars(bar2, "Total Share in all Stores");
        formatBars(bar3, "Overall Share in this Store");
        formatBars(bar4, "Share in All Recorded Stores");
        setDataForBar(bar1, data: sortByBrand(dataz));
        fetchAllBoxesForCategory();
        let shelfPlans = Array(store.shelfPlans!) as! [ShelfPlan];
        setDataForBar(bar3, data: sortCategoriesFromShelfPlans(shelfPlans));
        setDataForBar(bar4, data: sortFromAllAStores());
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func formatBars(_ chartView: BarChartView, _ descriptionLabel: String){
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        //xAxis.valueFormatter = DayAxisValueFormatter(chart: chartView)
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        leftAxisFormatter.negativeSuffix = " %"
        leftAxisFormatter.positiveSuffix = " %"
        
        let leftAxis = chartView.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.labelCount = 8
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisMinimum = 0 // FIXME: HUH?? this replaces startAtZero = YES
        
        let rightAxis = chartView.rightAxis
        rightAxis.enabled = false;
        
        let l = chartView.legend
        l.enabled = false;
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .circle
        l.formSize = 9
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4
        
        chartView.chartDescription?.text = descriptionLabel;
    }

    func sortByBrand(_ boxes: [ShelfBox], appendTo: [ProductBrand:Double]? = nil) -> [ProductBrand:Double] {
        var tempDict : [ProductBrand:Double] = [:];
        if(appendTo != nil) {
            tempDict = appendTo!;
        }
        for box in boxes {
            if let prod = box.product {
                if let brand = prod.brand {
                    if var i = tempDict[brand] {
                        print("current area for \(brand.name): \(i)");
                        print("adding area with \(box.width) * \(box.height)")
                        i += Double(box.width*box.height);
                        tempDict[brand] = i;
                        print("new area for \(brand.name): \(i)")
                    }else {
                        print("NEW BRAND DETECTED ALERT ALERT");
                        tempDict[brand] = Double(box.width*box.height);
                    }
                }
            }
        }
        for (brand, value) in tempDict {
            print("brand: \(brand.name) value: \(value)");
        }
        return tempDict;
    }
    
    func setDataForBar(_ chart: BarChartView, data: [ProductBrand:Double]){
        var i: Double = 0;
        let set = BarChartDataSet(values: [], label: "");
        var colors: [UIColor] = [];
        var labelStrings:[String] = [];
        var total:Double = 0;
        for (brand, value ) in data {
            total += value;
        }
        for (brand, value) in data {
            print("\(brand.name): \(value)" );
            let brandi = brand as! ProductBrand
            let entry = BarChartDataEntry(x: i, y: (value/total)*100);
            set.addEntry(entry);
            
            colors.append(Tools.generateRandomColor());
            labelStrings.append(brandi.name!);
            i+=1;
        }
        set.colors = colors;
        i = 0;
        chart.xAxis.valueFormatter = IndexAxisValueFormatter(values:labelStrings);
        let dattaz = BarChartData(dataSet: set);
        dattaz.barWidth = 0.9;
        chart.data = dattaz;
        //let dataSet = BarChartDataSet(values: set, label: "Test");
    }
    
    func fetchAllBoxesForCategory()->[ShelfBox]{
        let pred = NSPredicate(format: "ANY product.category == %i", category);
        let all = Array(CoreDataSingleton.sharedInstance.fetchEntitiesWithCustomPredicate("ShelfBox", predicate: pred)) as! [ShelfBox];
        print("all \(all.count)")
        for a in all {
            print("\(category) <- category, gotten category ->\(a.product?.category)");
            print("\(a.width) * \(a.height)");
        }
        setDataForBar(bar2, data: sortByBrand(all));
        return all;
    }
    
    func sortCategoriesFromShelfPlans(_ plans: [ShelfPlan], appendTo : [ProductBrand:Double]? = nil) -> [ProductBrand:Double] {
        var tempDict: [ProductBrand:Double] = [:];
        if(appendTo != nil){
            tempDict = appendTo!;
        }
        for plan in plans {
            var b = Array(plan.boxes!) as! [ShelfBox];
            for box in b {
                if (box.product?.category != category) {
                    if let index = b.index(of: box) {
                        b.remove(at: index)
                    }
                }
            }
            tempDict = sortByBrand(b, appendTo: tempDict);
        }
        return tempDict;
    }
    
    func sortFromAllAStores() -> [ProductBrand:Double]{
        var tempDict: [ProductBrand:Double] = [:];
        let allStores = Array(CoreDataSingleton.sharedInstance.fetchEntitiesFromCoreData("Store")) as! [Store];
        print("size of fetch \(allStores.count)");
        for storez in allStores {
            let shelfPlansz = Array(storez.shelfPlans!) as! [ShelfPlan];
            tempDict = sortCategoriesFromShelfPlans(shelfPlansz, appendTo: tempDict);
        }
        print("\(tempDict.count) <-- Size of allstores dict");
        return tempDict;
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
