//
//  BoxPopoverViewController.swift
//  Shelfie
//
//  Created by iosdev on 3.10.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import UIKit

class BoxPopoverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    let colorsList = [UIColor.red, UIColor.blue, UIColor.green, UIColor.brown];
    
    @IBOutlet weak var popoverTable: UITableView!
    @IBOutlet weak var delBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        popoverTable.delegate = self;
        popoverTable.dataSource = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: TableView methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: 200, height: 50));
        cell.backgroundColor = colorsList[indexPath.row];
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colorsList.count;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    
    @IBAction func delBtnAction(_ sender: UIButton) {
        //delete the view from here
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
