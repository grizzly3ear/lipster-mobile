//
//  Login2ViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 11/8/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class Login2ViewController: UIViewController {

    
 
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBAction func signUpButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "showSignUp", sender: self)
    }
    @IBAction func loginButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "showHomePage", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

      //  usernameTextField.setIcon(image: #imageLiteral(resourceName: "username"))
       // passwordTextField.setIcon(image: #imageLiteral(resourceName: "password"))
     
    }
    
}
