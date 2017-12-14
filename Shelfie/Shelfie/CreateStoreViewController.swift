//
//  CreateStoreViewController.swift
//  Shelfie
//
//  Created by iosdev on 5.10.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import UIKit
import CoreData

/*
 Controller for handling creation of store objects for storing in coredata
 */

class CreateStoreViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: Data Fields
    @IBOutlet weak var storeChainPickerView: UIPickerView!;
    @IBOutlet weak var storeNameField: UITextField!
    @IBOutlet weak var storeAddressField: UITextField!
    @IBOutlet weak var storeContactPerson: UITextField!
    @IBOutlet weak var storeContactNumber: UITextField!
    @IBOutlet weak var nomberOfModulesLabel: UILabel!
    @IBOutlet weak var numberOfModulesStepper: UIStepper!
    
    var textFieldArr : [UITextField] = [];
    
    
    //array containing all Chains, when values change, update all components of storechainpickerview, since  section 1 also depends on contents of section 0
    //realoding of pickerview that is inside alert is not necessary, as it is remade each time the alert is presented
    var storeChainArr : [StoreChain] = [];
    var chainArr : [Chain] = [] {
        didSet {
            if(chainArr.count != 0){
                let sc = chainArr[storeChainPickerView.selectedRow(inComponent: 0)].storeChains;
                storeChainArr = Array(sc!) as! [StoreChain];
                storeChainPickerView.reloadAllComponents();
            }
        }
    };
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //first fetch of chains
        setup();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchArrData();
        storeChainPickerView.delegate = self;
        storeChainPickerView.dataSource = self;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: delegate methods
    //all methods first check for which pickerview is selected, then if the pickerview is storechain... then check which section
    //not much happens when selecting values in section 2 of storepicker, it is mostly used for reading when StoreWrapper is later constructed
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == storeChainPickerView){
            switch component {
            case 0:
                return chainArr.count;
            case 1:
                return storeChainArr.count;
            default:
                return 0;
            }
        }
        return chainArr.count;
    }
    
    //Custom styling for pickerview labels, setting label text
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var title = "";
        if(pickerView == storeChainPickerView){
            switch component {
            case 0:
                title = chainArr[row].chainName!;
            case 1:
                title = storeChainArr[row].storeChainName!;
            default:
                title = "err";
            }
        }else {
            title =  chainArr[row].chainName!;
        }
        
        return Tools.formattedPickerLabel(view, withTitle: title);
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == storeChainPickerView){
            switch component {
            case 0:
                //if a value in the first picker is selected, update second picker to reflect selection
                if(chainArr.count > 0){
                    storeChainArr = Array(chainArr[row].storeChains!) as! [StoreChain];
                    storeChainPickerView.reloadComponent(1);
                }
                break;
            case 1:
                break;
            default:
                break;
            }
        }else {
            print("selecter other picker");
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //storechain picker is made up of two components, popup picker only has one
        if(pickerView == storeChainPickerView){
            return 2;
        }
        return 1;
    }
    
    
    //MARK: Button actions
    @IBAction func submitButtonAction(_ sender: UIButton) {
        if(validateFields()){
            addStoreToCoreData();
        }
    }
    @IBAction func createChainAction(_ sender: UIButton) {
        showChainCreationDialog();
    }
    @IBAction func createStoreChain(_ sender: UIButton) {
        showStoreChainCreationDialog();
    }
    @IBAction func numberOfModulesChanged(_ sender: UIStepper) {
        nomberOfModulesLabel.text = "Number of Modules: \(Int(sender.value))";
    }
    
    
    //MARK: adding entry to coreadata
    func addStoreToCoreData() {
        CoreDataSingleton.sharedInstance.createStore(constructNewStoreWrapper());
    }
    
    //collect values from fields and construct a wrapper class
    func constructNewStoreWrapper() -> StoreWrapper{
        let newStoreWrapper = StoreWrapper();
        if(Tools.checkTextFieldValid(textField: storeNameField)){
            newStoreWrapper.storeName = storeNameField.text!;
        }
        if(Tools.checkTextFieldValid(textField: storeAddressField)){
            newStoreWrapper.storeAddress = storeAddressField.text!;
        }
        if(Tools.checkTextFieldValid(textField: storeContactPerson)){
            newStoreWrapper.contactPerson = storeContactPerson.text!;
        }
        if(Tools.checkTextFieldValid(textField: storeContactNumber)){
            newStoreWrapper.contactNumber = storeContactNumber.text!;
        }
        newStoreWrapper.shelfWidth = Int(numberOfModulesStepper.value);
        newStoreWrapper.storeChain = storeChainArr[storeChainPickerView.selectedRow(inComponent: 1)];
        return newStoreWrapper;
    }
    
    //MARK: Dialogs
    
    func showStoreChainCreationDialog() {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 300)
        //inserting a pickerview with chains into the dialog
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
        pickerView.delegate = self
        pickerView.dataSource = self
        vc.view.addSubview(pickerView)
        let alert = UIAlertController(title: "Create a new Store Chain", message: "Select Chain and Name", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Store Chain Name"
        }
        alert.setValue(vc, forKey: "contentViewController");
        alert.addAction(UIAlertAction(title: "Create", style: .default){(_) in
            if let name  = alert.textFields?[0].text {
                //save the storechain into coredata, refetch all data and update pickers so they contain new data
                CoreDataSingleton.sharedInstance.createStoreChain(name, inChain: self.chainArr[pickerView.selectedRow(inComponent: 0)]);
                self.realodComponent1();
            }
        });
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showChainCreationDialog() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Create a new Chain", message: "Enter a name for the chain", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Create", style: .default) { (_) in
            if let name = alertController.textFields?[0].text {
                CoreDataSingleton.sharedInstance.createChain(name) {() in
                    //refetch data and update pickers
                    self.fetchArrData();
                };
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
    
    
    func fetchArrData(){
        chainArr = CoreDataSingleton.sharedInstance.fetchEntitiesFromCoreData("Chain") as! [Chain];
    }
    
    func realodComponent1(){
        let sc = chainArr[storeChainPickerView.selectedRow(inComponent: 0)].storeChains;
        storeChainArr = Array(sc!) as! [StoreChain];
        storeChainPickerView.reloadComponent(1);
    }
    
    //put all textfields into an array so they can be looped through easily
    func setup(){
        textFieldArr = [storeNameField,storeAddressField,storeContactNumber,storeContactPerson];
    }
    
    //see if input in fields is valid before submitting to coredata
    //mark invalid fields with red outline
    func validateFields()->Bool{
        clearInvalidFields();
        var valid = true;
        for field in textFieldArr {
            if (!Tools.checkTextFieldValid(textField: field, self)){
                valid = false;
            }
        }
        if (!(storeChainArr.count > 0)){
            alert(message: "Please select a store chain.");
            storeChainPickerView.layer.borderColor = UIColor.red.cgColor;
            storeChainPickerView.layer.borderWidth = 2;
            valid = false;
        }
        return valid;
    }
    
    //clear all fields from being marked invalid
    func clearInvalidFields(){
        for field in textFieldArr {
            field.layer.borderWidth = 0;
        }
        storeChainPickerView.layer.borderWidth = 0;
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
