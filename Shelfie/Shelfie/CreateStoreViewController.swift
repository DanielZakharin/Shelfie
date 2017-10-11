//
//  CreateStoreViewController.swift
//  Shelfie
//
//  Created by iosdev on 5.10.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import UIKit
import CoreData

class CreateStoreViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var storeChainPickerView: UIPickerView!
    let arr1 = ["Kesko", "S-ryhmä", "JokuViel"];
    let arr2 = [["CityMarket","SuperMarket"],["Prisma","Sale"],["Test1", "Test2"]];
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        storeChainPickerView.delegate = self;
        storeChainPickerView.dataSource = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: delegate methods
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return arr1.count;
        case 1:
            return arr2[pickerView.selectedRow(inComponent: 0)].count;
        default:
            return 0;
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return arr1[row];
        case 1:
            return arr2[pickerView.selectedRow(inComponent: 0)][row];
        default:
            return "err";
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            //update store being created
            pickerView.reloadComponent(1);
            break;
        case 1:
            //update store being created
            break;
        default:
            break;
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2;
    }
    
    //MARK: adding entry to coreadata
    func submitToCoreData() {
        
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
