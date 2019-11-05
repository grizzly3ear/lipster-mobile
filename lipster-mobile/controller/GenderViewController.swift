//
//  GenderSelectViewController.swift
//  lipster-mobile
//
//  Created by Bank on 24/10/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class GenderViewController: UIViewController {
    
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    let genderPrefix: String = "I am a "
    var gender = ""
    var redirect: String?
    
    @IBAction func selectMale(_ sender: UIButton) {
        genderLabel.text = genderPrefix + "male."
        gender = "male"
        submitButton.isHidden = false
    }
    
    @IBAction func selectFemale(_ sender: UIButton) {
        genderLabel.text = genderPrefix + "female."
        gender = "female"
        submitButton.isHidden = false
    }
    
    @IBAction func submit(_ sender: UIButton) {
        print(User.email!)
        UserRepository.register(email: User.email!, password: User.id!, firstname: User.firstname!, lastname: User.lastname!, gender: gender, imageURL: User.imageURL!) { (result, messages) in
            if result {
                // MARK: Pass
                self.hero.dismissViewController()
                self.hero.dismissViewController()
            } else {
                // MARK: FAILED
            }
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        hero.dismissViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.isHidden = true
        // Do any additional setup after loading the view.
    }


}
