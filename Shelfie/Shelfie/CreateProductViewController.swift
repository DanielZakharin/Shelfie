//
//  CreateProductViewController.swift
//  Shelfie
//
//  Created by iosdev on 5.10.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//
/*
 Controller for adding new products to coredata
 */
import UIKit
import BarcodeScanner

class CreateProductViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource, BarcodeScannerDismissalDelegate, BarcodeScannerCodeDelegate {
    @IBOutlet weak var productNameField: UITextField!
    
    @IBOutlet weak var barcodeLabel: UILabel!
    
    @IBOutlet weak var brandPicker: UIPickerView!
    @IBOutlet weak var manufacturerPicker: UIPickerView!
    
    @IBOutlet weak var categorySelector: UISegmentedControl!
    
    var brandArr : [ProductBrand] = [];
    var manArr : [Manufacturer] = [];
    var barcode: String = "";
    var scanner: BarcodeScannerController?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //initialize the barcode scanner to be used later, set delegate to self
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
    
    //gather data from fields and construct a wrapper class
    func constructProductFromFields() -> ProductWrapper{
        let newProdWrap = ProductWrapper();
        if(Tools.checkTextFieldValid(textField: productNameField)){
            newProdWrap.name = productNameField.text!;
        }
        newProdWrap.category = categorySelector.selectedSegmentIndex;
        newProdWrap.brand = brandArr[brandPicker.selectedRow(inComponent: 0)];
        if(!barcode.isEmpty){
            newProdWrap.barcode = barcode;
        }
        return newProdWrap;
    }
    
    //save constructed wrapper to coredata
    func writeProductToCoreData(_ wrapper: ProductWrapper){
        CoreDataSingleton.sharedInstance.createProduct(wrapper);
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        //if fields are valid save make a wrapper and save it to coradata
        if(validateFields()){
            writeProductToCoreData(constructProductFromFields());
            //display a message to let the user know the product has been added succesfully
            alert(message: "Success!");
            //after 2 seconds, clear the screen
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (timer) in
                let ctrl = self.parent as! CreateViewController;
                ctrl.switchView(i: 1);
            }
        }
    }
    //displays the brand creation dialog
    //if not manufacturers exist, shows an error
    @IBAction func createBrandAction(_ sender: UIButton) {
        if(manArr.count > 0){
        showBrandCreationDialog();
        }else {
            alert(message: "Please create a manufacturer first.")
        }
    }
    
    @IBAction func createManufacturerAction(_ sender: UIButton) {
        showmanuFacturerDialog();
    }
    
    @IBAction func scanBarcodeAction(_ sender: UIButton) {
        present(scanner!, animated: true, completion: nil);
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
    
    //custom styling for picker label
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var title = "";
        if(pickerView == brandPicker){
            title = brandArr[row].name!;
        }else if (pickerView == manufacturerPicker){
            title = manArr[row].name!;
        }else {
            title =  manArr[row].name!;
        }
        return Tools.formattedPickerLabel(view, withTitle: title);
    }
    
    //when a manufacturer is selected in the picker, update data in brand picker to relfect the change
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == manufacturerPicker){
            updateBrands();
        }
    }
    
    //MARK: Barcode Scanner delegate
    
    //this function is called when the barcodescanners cancel button is pressed
    //the bracode scanner must be dismissed manually, the cancel button does nothing on its own
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        controller.reset();
        controller.dismiss(animated: true, completion: nil);
    }
    
    //this function is called when the barcode succesfully reads a code
    //save code in variable, dismiss the barcode scanner
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        barcode = code;
        barcodeLabel.text = "Barcode: \(code)";
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (timer) in
            controller.reset();
            controller.dismiss(animated: true, completion: nil);
        }
    }
    
    //MARK: popup
    
    //shows a dialog with a pickerview for creatin new brands
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
            if (alert.textFields?[0] != nil && Tools.checkTextFieldValid(textField: alert.textFields![0], self))  {
                CoreDataSingleton.sharedInstance.createBrand((alert.textFields?[0].text)!, withManufacturer: self.manArr[pickerView.selectedRow(inComponent: 0)]) { () in
                    //self.brandPicker.reloadAllComponents();
                    self.fetchData();
                };
            }
        });
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        
    }
    
    //shows a dialog with a textinput for creating new manufacturers
    func showmanuFacturerDialog(){
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Create a Manufacturer", message: "Enter a name for the Manufacturer", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Create", style: .default) { (_) in
            //Handle creating and submitting to coredata here, completion block for button
            if (alertController.textFields?[0] != nil && Tools.checkTextFieldValid(textField: alertController.textFields![0], self))  {
                CoreDataSingleton.sharedInstance.createManufacturer((alertController.textFields?[0].text)!) { () in
                    self.fetchData();
                }
            }
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Manufacturer Name"
            //Tools.formatTextField(textField);
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
    
    //updates the brands picker with the brands of the currently selected manufacturer
    func updateBrands(){
        if(manArr.count > 0){
            brandArr = Array(manArr[manufacturerPicker.selectedRow(inComponent: 0)].brands!) as! [ProductBrand];
            brandPicker.reloadAllComponents();
        }
    }
    
    //validetes all fields in the controller, marks invalid ones with a red border
    func validateFields()->Bool{
        clearInvalidFields();
        var valid = Tools.checkTextFieldValid(textField: productNameField,self);
        
        if (!(brandArr.count > 0)){
            valid = false;
            self.alert(message: "Please select or create a new brand.");
            brandPicker.layer.borderWidth = 2;
            brandPicker.layer.borderColor = UIColor.red.cgColor;
        }
        return valid;
        
    }
    
    //clears all fields that have been marked invalid
    func clearInvalidFields(){
        productNameField.layer.borderWidth = 0;
        brandPicker.layer.borderWidth = 0;
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
