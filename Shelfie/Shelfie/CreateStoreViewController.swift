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
    
    
    
    var arr1 : [Chain] = [] {
        didSet {
            print("chain value changed to:\(arr1)");
            if(arr1.count != 0){
                let sc = arr1[storeChainPickerView.selectedRow(inComponent: 0)].storeChains;
                arr2 = Array(sc!) as! [StoreChain];
                storeChainPickerView.reloadAllComponents();
            }
        }
    };
    var arr2 : [StoreChain] = [] {
        didSet {
            
        }
    };
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        arr1 = CoreDataSingleton.sharedInstance.fetchEntitiesFromCoreData("Chain") as! [Chain];
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //arr1 needs to be loaded twice for some reason, set delegate only here, when the values are actually present
        arr1 = CoreDataSingleton.sharedInstance.fetchEntitiesFromCoreData("Chain") as! [Chain];
        storeChainPickerView.delegate = self;
        storeChainPickerView.dataSource = self;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: delegate methods
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == storeChainPickerView){
            switch component {
            case 0:
                return arr1.count;
            case 1:
                return arr1[0].storeChains!.count;
            default:
                return 0;
            }
        }
        return arr1.count;
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == storeChainPickerView){
            switch component {
            case 0:
                return arr1[row].chainName;
            case 1:
                return arr2[row].storeChainName;
            default:
                return "err";
            }
        }
        return arr1[row].chainName;
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == storeChainPickerView){
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
        }else {
            print("selecter other picker");
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if(pickerView == storeChainPickerView){
            return 2;
        }
        return 1;
    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        addToCoreData();
    }
    @IBAction func createChainAction(_ sender: UIButton) {
        showChainCreationDialog();
    }
    @IBAction func createStoreChain(_ sender: UIButton) {
        showStoreChainCreationDialog();
    }
    
    
    //MARK: adding entry to coreadata
    func addToCoreData() {
        CoreDataSingleton.sharedInstance.createStore(constructNewStoreWrapper())
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
    
    //MARK: Dialogs
    func showStoreChainCreationDialog() {/*
         //Creating UIAlertController and
         //Setting title and message for the alert dialog
         let alertController = UIAlertController(title: "Create a new Store Chain", message: "Enter a name for the store chain", preferredStyle: .alert);
         alertController.isModalInPopover = true;
         
         //the confirm action taking the inputs
         let confirmAction = UIAlertAction(title: "Create", style: .default) { (_) in
         //Handle creating and submitting to coredata here
         if let name = alertController.textFields?[0].text {
         //CoreDataSingleton.sharedInstance.createStoreChain(name);
         }
         }
         
         //the cancel action doing nothing
         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
         
         //adding textfields to our dialog box
         alertController.addTextField { (textField) in
         textField.placeholder = "Enter Store Chain Name"
         }
         
         //add a pickerview to the alert
         let pickerFrame: CGRect = CGRect(x: 17, y: 52, width: 270, height: 100);// CGRectMake(left), top, width, height) - left and top are like margins
         let picker: UIPickerView = UIPickerView(frame: pickerFrame);
         alertController.view.addSubview(picker);
         
         //adding the action to dialogbox
         alertController.addAction(confirmAction)
         alertController.addAction(cancelAction)
         
         //finally presenting the dialog box
         self.present(alertController, animated: true, completion: nil)*/
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 300)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
        pickerView.delegate = self
        pickerView.dataSource = self
        vc.view.addSubview(pickerView)
        let alert = UIAlertController(title: "Create a new Store Chain", message: "Select Chain and Name", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Store Chain Name"
        }
        alert.setValue(vc, forKey: "contentViewController");
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showChainCreationDialog() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Create a new Chain", message: "Enter a name for the chain", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Create", style: .default) { (_) in
            //Handle creating and submitting to coredata here
            if let name = alertController.textFields?[0].text {
                CoreDataSingleton.sharedInstance.createChain(name);
            }
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Chain Name"
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
        
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
