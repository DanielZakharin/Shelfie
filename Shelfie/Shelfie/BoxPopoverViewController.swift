//
//  BoxPopoverViewController.swift
//  Shelfie
//
//  Created by iosdev on 3.10.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import UIKit
import BarcodeScanner

class BoxPopoverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, BarcodeScannerCodeDelegate, BarcodeScannerDismissalDelegate{
    
    var selectedBoxView : BoxView?;
    var parentCtrl : BoxViewController?;
    @IBOutlet weak var popoverTable: UITableView!
    @IBOutlet weak var delBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var scannerBtn: MetsaButton!
    
    var productsArr : [Product] = [];
    var scanner: BarcodeScannerController?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        scanner = BarcodeScannerController();
        scanner?.codeDelegate = self;
        scanner?.dismissalDelegate = self;
        
        popoverTable.delegate = self;
        popoverTable.dataSource = self;
        searchBar.delegate = self;
        searchBar.returnKeyType = .search;
        searchBar.showsCancelButton = true;
        scannerBtn.layer.cornerRadius = 0;
        scannerBtn.backgroundColor = UIColor(red: 199/255, green: 197/255, blue: 201/255, alpha: 1)
        fetchProducts();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: TableView methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BoxPopoverTableCell", for: indexPath) as? BoxPopOverTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        // Configure the cell...
        cell.titleLabel.text = productsArr[indexPath.row].name;
        let b = productsArr[indexPath.row].brand;
        cell.subtitleLabel.text = b?.name;
        cell.categoryImageView.image = Tools.categoryImageDict[productsArr[indexPath.row].category];
        
        cell.categoryImageView.contentMode = .scaleAspectFit;
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //temporary dataset, change to products / categories later
        return productsArr.count;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //change selected box color to matching color from list
        if(selectedBoxView != nil){
            selectedBoxView!.setProducForBox(productsArr[indexPath.row]);
        }
        parentCtrl!.dismissPopOver(ctrl: self);
        //need to manually deselect row
        tableView.deselectRow(at: indexPath, animated: false);
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searching");
        fetchProductsWithSearch(searchBar.text!);
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("clear");
        searchBar.text = "";
        fetchProducts();
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("jee \(searchBar.text)");
        if(searchBar.text?.isEmpty)!{
            print("clear search");
        }
    }
    
    
    @IBAction func delBtnAction(_ sender: UIButton) {
        //delete the view from here
        selectedBoxView!.removeFromSuperview();
        selectedBoxView = nil;
        parentCtrl?.dismissPopOver(ctrl: self);
    }
    
    @IBAction func barcodeAction(_ sender: UIButton) {
        present(scanner!, animated: true, completion: nil);
    }
    
    
    func fetchProducts(){
        productsArr = CoreDataSingleton.sharedInstance.fetchEntitiesFromCoreData("Product") as! [Product];
        popoverTable.reloadData();
    }
    
    func fetchProductsWithSearch(_ searchTerm: String){
        productsArr = Array(CoreDataSingleton.sharedInstance.fetchEntitiesFromCoreData("Product", withSearchTerm: searchTerm, forVariable: "name")) as! [Product];
        popoverTable.reloadData();
    }
    
    //MARK: barcode scanner
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        print("CODE: \(code)");
        productsArr = Array(CoreDataSingleton.sharedInstance.fetchEntitiesFromCoreData("Product", withSearchTerm: code, forVariable: "barcode")) as! [Product];
        dump(productsArr);
        popoverTable.reloadData();
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (timer) in
            controller.reset();
            controller.dismiss(animated: true, completion: nil);
        }
    }
    
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        controller.reset();
        controller.dismiss(animated: true, completion: nil);
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
