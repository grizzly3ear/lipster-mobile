//
//  Login2ViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 11/8/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit
import Hero

class Login2ViewController: UIViewController {

    @IBOutlet weak var formContainer: UIImageView!
    @IBOutlet weak var leftLine: UIImageView!
    @IBOutlet weak var rightLine: UIImageView!
    @IBOutlet weak var lineLabel: UILabel!
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initHero()
        
        usernameTextField.text = "example@gmail.com"
        passwordTextField.text = "password"
        
    }
    
    @IBAction func signUpButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "showSignUp", sender: self)
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        UserRepository.authenticate(
            email: usernameTextField.text ?? "",
            password: passwordTextField.text ?? "") {_ in
                self.performSegue(withIdentifier: "showHomePage", sender: self)
        }
        
    }
}

extension Login2ViewController {
    func initHero() {
        self.hero.isEnabled = true
        self.formContainer.hero.id = "formContainer"
        self.leftLine.hero.id = "leftLine"
        self.rightLine.hero.id = "rightLine"
        self.lineLabel.hero.id = "lineLabel"
        self.facebookButton.hero.id = "facebookButton"
        self.loginButton.hero.id = "primaryActionButton"
    }
}
