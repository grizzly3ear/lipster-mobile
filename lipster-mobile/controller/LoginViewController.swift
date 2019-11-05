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
import GoogleSignIn

class LoginViewController: UIViewController {

    @IBOutlet weak var formContainer: UIImageView!
    @IBOutlet weak var leftLine: UIImageView!
    @IBOutlet weak var rightLine: UIImageView!
    @IBOutlet weak var lineLabel: UILabel!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    @IBOutlet weak var facebookButton: UIButton!

    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    var redirect: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initHero()
        
        passwordTextField.enablesReturnKeyAutomatically = true
        usernameTextField.enablesReturnKeyAutomatically = true
        
        passwordTextField.delegate = self
        usernameTextField.delegate = self
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        
        // MARK: GID Auto signin
//        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        // MARK: There are facebook user login now
//        if (AccessToken.current != nil) {
//            
//            fetchFacebookUserData()
//        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func onPressgoogleButton(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func onPressfacebookButton(_ sender: Any) {
        let login: LoginManager = LoginManager()
        let permissions: [String] = [
            "email",
            "public_profile"
        ]
        login.logIn(permissions: permissions, from: self) { (result, error) in
            if let err = error {
                print("[Facebook] error: \(err)")
            } else if let isCancel = result?.isCancelled, isCancel {
                print("Cancel login")
            } else {
                print("login")
                
                self.fetchFacebookUserData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        if identifier == "selectGenderPage" {
            let destination = segue.destination as! GenderViewController
            
            destination.redirect = self.redirect
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
            password: passwordTextField.text ?? ""
        ) { status, messages in
            if status == 200 {
                self.hero.dismissViewController()
            } else {
                self.popCenterAlert(title: messages[0], description: messages[1], actionTitle: "Ok")
            }
        }
    }
}

// MARK: Auth
extension LoginViewController: GIDSignInDelegate {
    
    func fetchFacebookUserData() {
        Profile.loadCurrentProfile { (fbProfile, error) in
            if let profile = fbProfile {

                GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, graphResult, error) in
                    if let _ = error {
                        print("Failed to fetch data")
                        return
                    }
                    if let dictionaryResult = graphResult as? Dictionary<String, AnyObject> {
                        User.shared.id = profile.userID
                        User.shared.firstname = profile.firstName!
                        User.shared.lastname = profile.lastName!
                        User.shared.imageURL = profile.imageURL(forMode: .square, size: CGSize(width: 480, height: 480))?.absoluteString
                        User.shared.email = "\(dictionaryResult["email"]!)"
                        
                        print(User.shared.id!)
                        print(User.shared.email!)
                        self.authenticate()
                    }
                    
                }
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("GID Error: \(error.localizedDescription)")
            }
            return
        }
        
        let userId = user.userID!
        let givenName = user.profile.givenName!
        let familyName = user.profile.familyName!
        let email = user.profile.email!
        
        User.shared.email = email
        User.shared.firstname = givenName
        User.shared.lastname = familyName
        User.shared.id = userId
        
        self.authenticate()
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        print("user disconnect: \(user.profile.givenName)")
    }
    
    private func authenticate() {
        print(User.shared.email!)
        print(User.shared.id!)
        UserRepository.authenticate(
            email: User.shared.email!,
            password: User.shared.id!
        ) { (status, messages) in
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
