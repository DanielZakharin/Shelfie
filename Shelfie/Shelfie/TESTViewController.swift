//
//  TESTViewController.swift
//  Shelfie
//
//  Created by iosdev on 11.10.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import UIKit
import CoreData
import SwiftCharts
import PieCharts
import ChartLegends

class TESTViewController: UIViewController {
    let coreSingleton = CoreDataSingleton.sharedInstance;
    @IBOutlet weak var testTxtField: UITextView!
    @IBOutlet weak var testTxtField2: UITextView!
    @IBOutlet weak var testTxtField3: UITextView!
    
    @IBOutlet weak var testCont: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let chartConfig = BarsChartConfig(
            valsAxisConfig: ChartAxisConfig(from: 0, to: 8, by: 2)
        )
        
        let frame = CGRect(x: 0, y: 70, width: 300, height: 500)
        
        let chart = BarsChart(
            frame: frame,
            chartConfig: chartConfig,
            xTitle: "X axis",
            yTitle: "Y axis",
            bars: [
                ("A", 2),
                ("B", 4.5),
                ("C", 3),
                ("D", 5.4),
                ("E", 6.8),
                ("F", 0.5)
            ],
            color: UIColor.red,
            barWidth: 20
        )
        
        self.view.addSubview(chart.view)
        // self.chart = chart
        
        let legetest = ChartLegendsView();
        
        testCont.addSubview(legetest);
        legetest.frame = testCont.bounds;
        
//        legetest.setLegends(.circle(radius: 7), [
//            (text: "Chemicals", color: UIColor.orange),
//            (text: "Forestry", color: UIColor.green)
//            ])
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func testBtn1(_ sender: Any) {
        coreSingleton.deleteAllData(entity: "Chain");
        coreSingleton.deleteAllData(entity: "StoreChain");
        coreSingleton.deleteAllData(entity: "Store");
        coreSingleton.deleteAllData(entity: "ShelfPlan");
        coreSingleton.deleteAllData(entity: "ShelfBox");
    }
    
    @IBAction func testBtn2(_ sender: Any) {
        let stores = coreSingleton.fetchEntitiesFromCoreData("Store") as! [Store];
        var testStr = "here is what i got:\n";
        for jee in stores{
            testStr += "Name:\(jee.storeName!)\nAddress:\(jee.storeAddress!)\nContactPerson:\(jee.contactPerson!)\nContactNumber:\(jee.contactNumber!)\nStoreChain:\(jee.storeChain?.storeChainName)\n\n";
        }
        testTxtField.text = testStr;
    }
    
    @IBAction func testBtn3(_ sender: UIButton) {
        let chains = CoreDataSingleton.sharedInstance.fetchEntitiesFromCoreData("Chain") as! [Chain];
        testTxtField2.text! = "";
        for chain in chains{
            testTxtField2.text! += "Chain name: \(chain.chainName!)\nStoreChains: \(chain.storeChains!.count)\n\n"
        }
    }
    
    @IBAction func testBtn4(_ sender: UIButton) {
        let sps = coreSingleton.fetchEntitiesFromCoreData("ShelfPlan") as! [ShelfPlan];
        testTxtField3.text = "";
        for sp in sps {
            testTxtField3.text! += "ShelfPlan: \nstore:\(sp.store?.storeName)\nboxes: \(sp.boxes?.count) \n\n"
        }
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
