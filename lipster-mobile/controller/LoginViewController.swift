//
//  ViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 26/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

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
        

//        let icon = #imageLiteral(resourceName: "facebook_icon")
//        loginWithFacebookButton.setImage(icon, for: .normal)
//        loginWithFacebookButton.imageView?.contentMode = .scaleAspectFit
//        loginWithFacebookButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
    }
    
    @IBAction func didLoginButtonPress(_ sender: UIButton) {
        performSegue(withIdentifier: "replaceHomePage", sender: self)
    }
    
    @IBAction func loginSegments(_ sender: Any) {
        print ("Clicked segment")
        switch (sender as AnyObject).selectedSegmentIndex{
        case 0 :
            loginScrollView.setContentOffset(CGPoint( x : 0 , y : 0), animated:true)
            break
        case 1 :
            loginScrollView.setContentOffset(CGPoint( x : 375 , y : 0), animated:true)
            break
        default:
            print("")
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

extension UITextField {
    func setIcon( image : UIImage){
        let iconView =  UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
        iconView.image = image
        
        let iconContainerView: UIView = UIView(frame: CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
}
