//
//  Login2ViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 11/8/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit
import Hero

class LoginViewController: UIViewController {

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
        passwordTextField.enablesReturnKeyAutomatically = true
        usernameTextField.enablesReturnKeyAutomatically = true
        passwordTextField.delegate = self
        usernameTextField.delegate = self
    }
    
    @IBAction func signUpButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "showSignUp", sender: self)
    }
    
    @IBAction func goBack(_ sender: Any) {
        hero.dismissViewController()
    }
    
    
    @IBAction func loginButtonAction(_ sender: Any) {
        UserRepository.authenticate(
            email: usernameTextField.text ?? "",
            password: passwordTextField.text ?? "") { status, messages in
                if status == 200 {
                    self.hero.dismissViewController()
                } else {
                    self.popCenterAlert(title: messages[0], description: messages[1], actionTitle: "Ok")
                }
        }
        
    }
}

extension LoginViewController: UITextFieldDelegate {
    func initHero() {
        self.hero.isEnabled = true
        self.formContainer.hero.id = "formContainer"
        self.leftLine.hero.id = "leftLine"
        self.rightLine.hero.id = "rightLine"
        self.lineLabel.hero.id = "lineLabel"
        self.facebookButton.hero.id = "facebookButton"
        self.loginButton.hero.id = "primaryActionButton"
        
        
    }
    
    func popCenterAlert(title: String, description: String, actionTitle: String, completion: (() -> Void)? = nil ) {
        let alert  = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: completion)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
