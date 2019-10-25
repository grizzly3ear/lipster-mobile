//
//  Login2ViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 11/8/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit
import Hero
import FBSDKCoreKit
import FBSDKLoginKit

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
        
        if (AccessToken.current != nil) {
            // MARK: There are user login now
            print("hey user")
            fetchUserData()
        }
    }
    
    @IBAction func onPressfacebookButton(_ sender: Any) {
        let login: LoginManager = LoginManager()
        let permissions: [String] = [
            "email",
            "public_profile"
        ]
        login.logIn(permissions: permissions, from: self) { (result, error) in
            if let err = error {
                print(err)
            } else if let isCancel = result?.isCancelled, isCancel {
                print("Cancel login")
            } else {
                print("login")
                
                self.fetchUserData()
            }
        }
    }
    
    func fetchUserData() {
        Profile.loadCurrentProfile { (fbProfile, error) in
            if let profile = fbProfile {

                GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, graphResult, error) in
                    if let _ = error {
                        print("Failed to fetch data")
                        return
                    }
                    if let dictionaryResult = graphResult as? Dictionary<String, AnyObject> {
                        User.firstname = profile.firstName
                        User.lastname = profile.lastName
                        User.imageURL = profile.imageURL(forMode: .square, size: CGSize(width: 100, height: 100))?.absoluteString
                        User.email = "\(String(describing: dictionaryResult["email"]))"
                        UserRepository.authenticate(email: User.email!, password: User.id!) { (status, messages) in
                            if status == 401 {
                                self.performSegue(withIdentifier: "selectGenderPage", sender: self)
                            } else if status == 200 {
                                self.hero.dismissViewController()
                            } else {
                                self.popCenterAlert(title: messages[0], description: messages[1], actionTitle: "Ok")
                            }
                        }
                        
                    }
                    
                }
            }
        }
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
