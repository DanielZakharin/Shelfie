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
        setDataCount(10, range: 20, chartView: bar1);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setDataCount(_ count: Int, range: UInt32, chartView: BarChartView) {
        let start = 1
        
        let yVals = (start..<start+count+1).map { (i) -> BarChartDataEntry in
            let mult = range + 1
            let val = Double(arc4random_uniform(mult))
            if arc4random_uniform(100) < 25 {
                return BarChartDataEntry(x: Double(i), y: val, icon: UIImage(named: "icon"))
            } else {
                return BarChartDataEntry(x: Double(i), y: val)
            }
        }
        
        var set1: BarChartDataSet! = nil
        if let set = chartView.data?.dataSets.first as? BarChartDataSet {
            set1 = set
            set1.values = yVals
            chartView.data?.notifyDataChanged()
            chartView.notifyDataSetChanged()
        } else {
            set1 = BarChartDataSet(values: yVals, label: "The year 2017")
            set1.colors = ChartColorTemplates.material()
            set1.drawValuesEnabled = false
            
            let data = BarChartData(dataSet: set1)
            data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
            data.barWidth = 0.9
            chartView.data = data
        }
        
                chartView.setNeedsDisplay()
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
