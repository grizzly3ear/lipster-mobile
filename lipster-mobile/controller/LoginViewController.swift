//
//  ViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 26/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//
// Not use this file
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginWithFacebookButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var registerLoginWithFacebookButton: UIButton!
    @IBOutlet weak var registerNameTextFiled: UITextField!
    @IBOutlet weak var registerEmailTextField: UITextField!
    @IBOutlet weak var registerPasswordTextField: UITextField!
    @IBOutlet weak var registerReTypePasswordTextField: UITextField!
    
    @IBOutlet weak var loginScrollView: UIScrollView!
    @IBOutlet weak var loginSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initScrollView()
        loginEmailTextField.setIcon(image: #imageLiteral(resourceName: "mail"))
        loginPasswordTextField.setIcon(image: #imageLiteral(resourceName: "lock"))
        registerNameTextFiled.setIcon(image: #imageLiteral(resourceName: "userIcon"))
        registerEmailTextField.setIcon(image: #imageLiteral(resourceName: "mail"))
        registerPasswordTextField.setIcon(image: #imageLiteral(resourceName: "lock"))
        registerReTypePasswordTextField.setIcon(image: #imageLiteral(resourceName: "lock"))
        loginButton.layer.cornerRadius = 10
        loginWithFacebookButton.layer.cornerRadius = 10
        registerButton.layer.cornerRadius = 10
        registerLoginWithFacebookButton.layer.cornerRadius = 10
        

    }
    
    @IBAction func didLoginButtonPress(_ sender: UIButton) {
        UserRepository.authenticate(email: "example@gmail.com", password: "password") { () in
            self.performSegue(withIdentifier: "replaceHomePage", sender: self)
        }
    }
    
    @IBAction func loginSegments(_ sender: Any) {
        switch (sender as AnyObject).selectedSegmentIndex{
        case 0 :
            loginScrollView.setContentOffset(CGPoint( x : 0 , y : 0), animated:true)
            break
        case 1 :
            loginScrollView.setContentOffset(CGPoint( x : 375 , y : 0), animated:true)
            break
        default:
            break
        }
    }
    
}

extension LoginViewController: UIScrollViewDelegate {
    func initScrollView() {
        self.loginScrollView.delegate = self
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {        
        loginSegment.selectedSegmentIndex = loginScrollView.currentPage()
    }
}
