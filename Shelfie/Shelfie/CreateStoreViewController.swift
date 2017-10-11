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

    //MARK: Data Fields
    @IBOutlet weak var storeChainPickerView: UIPickerView!;
    @IBOutlet weak var storeNameField: UITextField!
    @IBOutlet weak var storeAddressField: UITextField!
    @IBOutlet weak var storeContactPerson: UITextField!
    @IBOutlet weak var storeContactNumber: UITextField!
    
    
    
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
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        addToCoreData();
    }
    
    
    //MARK: adding entry to coreadata
    func addToCoreData() {
        CoreDataSingleton.sharedInstance.createTestStore(constructNewStoreWrapper())
    }
    
    //collect values from fields
    func constructNewStoreWrapper() -> StoreWrapper{
        let newStoreWrapper = StoreWrapper();
        if(checkTextFieldValid(textField: storeNameField)){
            newStoreWrapper.storeName = storeNameField.text!;
        }
        if(checkTextFieldValid(textField: storeAddressField)){
            newStoreWrapper.storeAddress = storeAddressField.text!;
        }
        if(checkTextFieldValid(textField: storeContactPerson)){
            newStoreWrapper.contactPerson = storeContactPerson.text!;
        }
        if(checkTextFieldValid(textField: storeContactNumber)){
            newStoreWrapper.contactNumber = storeContactNumber.text!;
        }
        //TODO: make pickerview based on actual data, get id from chain object
        //newStoreWrapper.chainID =
        return newStoreWrapper;
    }
    
    //TODO: move to common functions singleton
    func checkTextFieldValid(textField: UITextField) -> Bool{
        if((textField.text) != nil && !textField.text!.isEmpty){
            return true;
        }
        return false;
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
