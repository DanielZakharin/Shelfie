//
//  CreateProductViewController.swift
//  Shelfie
//
//  Created by iosdev on 5.10.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import UIKit
import BarcodeScanner

class CreateProductViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource, BarcodeScannerDismissalDelegate, BarcodeScannerCodeDelegate {
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
    @IBOutlet weak var manufacturerPicker: UIPickerView!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var categorySelector: UISegmentedControl!
    
    var brandArr : [ProductBrand] = [];
    var manArr : [Manufacturer] = [];
    var barcode: String = "";
    var scanner: BarcodeScannerController?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        scanner = BarcodeScannerController();
        scanner?.codeDelegate = self;
        scanner?.dismissalDelegate = self;
        
        manufacturerPicker.delegate = self;
        manufacturerPicker.dataSource = self;
        
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
        if(!barcode.isEmpty){
            newProdWrap.barcode = barcode;
        }
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
    
    @IBAction func createManufacturerAction(_ sender: UIButton) {
        showmanuFacturerDialog();
    }
    
    @IBAction func scanBarcodeAction(_ sender: UIButton) {
        
    }
    
    
    
    //MARK: PickerView delegate methods
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == brandPicker){
            return brandArr.count;
        }else if (pickerView == manufacturerPicker){
            return manArr.count;
        }else {
            return manArr.count;
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == brandPicker){
            return brandArr[row].name!;
        }else if (pickerView == manufacturerPicker){
            return manArr[row].name!;
        }else {
            return manArr[row].name!;
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == manufacturerPicker){
            updateBrands();
        }
    }
    
    //MARK: Barcode Scanner delegate
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (timer) in
            controller.dismiss(animated: true, completion: nil);
        }
    }
    
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (timer) in
            controller.dismiss(animated: true, completion: nil);
        }
    }
    
    //MARK: popup
    func showBrandCreationDialog() {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 300)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
        pickerView.delegate = self
        pickerView.dataSource = self
        vc.view.addSubview(pickerView)
        let alert = UIAlertController(title: "Create a new Brand", message: "Select Manufacturer and Name", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Brand Name"
        }
        alert.setValue(vc, forKey: "contentViewController");
        alert.addAction(UIAlertAction(title: "Create", style: .default){(_) in
            if let name  = alert.textFields?[0].text {
                CoreDataSingleton.sharedInstance.createBrand(name, withManufacturer: self.manArr[pickerView.selectedRow(inComponent: 0)]) { () in
                    //self.brandPicker.reloadAllComponents();
                    self.fetchData();
                };
            }
        });
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        
    }
    
    func showmanuFacturerDialog(){
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Create a Manufacturer", message: "Enter a name for the Manufacturer", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Create", style: .default) { (_) in
            //Handle creating and submitting to coredata here, completion block for button
            if let name = alertController.textFields?[0].text {
                CoreDataSingleton.sharedInstance.createManufacturer(name) { () in
                    self.fetchData();
                }
            }
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Manufacturer Name"
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    
    func fetchData(){
        manArr = CoreDataSingleton.sharedInstance.fetchEntitiesFromCoreData("Manufacturer") as! [Manufacturer];
        manufacturerPicker.reloadAllComponents();
        updateBrands();
    }
    
    func updateBrands(){
        if(manArr.count > 0){
            brandArr = Array(manArr[manufacturerPicker.selectedRow(inComponent: 0)].brands!) as! [ProductBrand];
            print("\(manArr[0].brands?.count) <- manarr \(brandArr.count) <--brandarr");
            brandPicker.reloadAllComponents();
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
