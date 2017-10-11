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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func testBtn1(_ sender: Any) {
        let currentTime = CACurrentMediaTime();
        coreSingleton.createTestStore(name: "Kauppa \(currentTime)", address: "CittarinKatu")
    }
    
    @IBAction func testBtn2(_ sender: Any) {
        let stores = coreSingleton.getStoresTest();
        var testStr = "here is what i got:\n";
        for jee in stores!{
            testStr += jee.storeName!+"\n";
        }
        testTxtField.text = testStr;
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
