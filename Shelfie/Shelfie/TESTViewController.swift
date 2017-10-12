//
//  TESTViewController.swift
//  Shelfie
//
//  Created by iosdev on 11.10.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import UIKit
import CoreData

class TESTViewController: UIViewController {
    
    let coreSingleton = CoreDataSingleton.sharedInstance;
    @IBOutlet weak var testTxtField: UITextView!
    @IBOutlet weak var testTxtField2: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func testBtn1(_ sender: Any) {
        coreSingleton.deleteAllData(entity: "Chain");
        coreSingleton.deleteAllData(entity: "StoreChain");
        coreSingleton.deleteAllData(entity: "Store");
        
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
