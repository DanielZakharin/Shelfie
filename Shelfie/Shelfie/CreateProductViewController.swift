//
//  CreateProductViewController.swift
//  Shelfie
//
//  Created by iosdev on 5.10.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import UIKit

class CreateProductViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    @IBOutlet weak var productNameField: UITextField!
    
    //MARK: Steppers
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var widthStepper: UIStepper!
    
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var heightStepper: UIStepper!
    
    @IBOutlet weak var depthLabel: UILabel!
    @IBOutlet weak var depthStepper: UIStepper!
    
    var stepperArr : [UIStepper] = [];
    var stepperDict : [UIStepper: UILabel] = [:];
    
    //MARK: Other outlets
    @IBOutlet weak var brandPicker: UIPickerView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var categorySelector: UISegmentedControl!
    
    var brandArr : [ProductBrand] = [];

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupSteppers();
        brandPicker.delegate = self;
        brandPicker.dataSource = self;
        fetchData();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchData();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Stepper functions
    func setupSteppers(){
        stepperArr = [widthStepper,heightStepper,depthStepper];
        stepperDict = [widthStepper: widthLabel, heightStepper: heightLabel, depthStepper: depthLabel];
        for stepper in stepperArr {
            stepper.minimumValue = 1;
            stepper.maximumValue = 8;
            stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged);
        }
    }
    
    func stepperValueChanged(_ sender: UIStepper){
        let label = stepperDict[sender]!;
        label.text = "\(label.text!.substring(to: label.text!.index(before: label.text!.endIndex)))\(Int(sender.value))"
    }
    
    func constructProductFromFields() -> ProductWrapper{
        let newProdWrap = ProductWrapper();
        if(Tools.checkTextFieldValid(textField: nameField)){
            newProdWrap.name = nameField.text!;
        }
        newProdWrap.category = categorySelector.selectedSegmentIndex;
        newProdWrap.brand = brandArr[brandPicker.selectedRow(inComponent: 0)];
        newProdWrap.width = Int(widthStepper.value);
        newProdWrap.height = Int(heightStepper.value);
        newProdWrap.depth = Int(depthStepper.value);
        return newProdWrap;
    }
    
    func writeProductToCoreData(_ wrapper: ProductWrapper){
        CoreDataSingleton.sharedInstance.createProduct(wrapper);
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        writeProductToCoreData(constructProductFromFields());
    }
    @IBAction func createBrandAction(_ sender: UIButton) {
        //TODO: make a popup for adding a brand to coredata
        showBrandCreationDialog();
    }
    
    //MARK: PickerView delegate methods
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return brandArr.count;
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return brandArr[row].name;
    }
    
    //MARK: popup
    func showBrandCreationDialog() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Create a Brand", message: "Enter a name for the Brand", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Create", style: .default) { (_) in
            //Handle creating and submitting to coredata here, completion block for button
            if let name = alertController.textFields?[0].text {
                CoreDataSingleton.sharedInstance.createBrand(name) { () in
                    self.fetchData();
                }
            }
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Brand Name"
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func fetchData(){
        brandArr = CoreDataSingleton.sharedInstance.fetchEntitiesFromCoreData("ProductBrand") as! [ProductBrand];
        brandPicker.reloadAllComponents();
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
