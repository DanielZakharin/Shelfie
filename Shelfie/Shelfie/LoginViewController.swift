//
//  LoginViewController.swift
//  Shelfie
//
//  Created by iosdev on 4.10.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import UIKit

/*
 Login controller, currently does nothing, since it would need to be implemented with metsäs own systems in mind
 */

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "LoginToTab", sender: self);
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
