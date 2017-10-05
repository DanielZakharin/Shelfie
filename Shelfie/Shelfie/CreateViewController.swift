//
//  CreateViewController.swift
//  Shelfie
//
//  Created by iosdev on 5.10.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var creationContainer: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    let pickerData = ["Store", "Product"];

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pickerView.delegate = self;
        pickerView.dataSource = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Delegate Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row];
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switchView(i: row);
    }
    
    //MARK: Methods
    func switchView(i:Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        //removes all subviews from container
        creationContainer.subviews.forEach { $0.removeFromSuperview() };
        if(i == 0){
            //change to store creation view
            let viewCtrl = storyboard.instantiateViewController(withIdentifier: "CreateStoreView");
            self.addChildViewController(viewCtrl);
            creationContainer.addSubview(viewCtrl.view);
        }else if (i == 1){
            //change to product creation view
            let viewCtrl = storyboard.instantiateViewController(withIdentifier: "CreateProductView");
            self.addChildViewController(viewCtrl);
            creationContainer.addSubview(viewCtrl.view);
        }else {
            
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
