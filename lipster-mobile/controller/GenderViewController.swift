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
    
    let genderPrefix: String = "I am a "
    
    @IBAction func selectMale(_ sender: UIButton) {
        genderLabel.text = genderPrefix + "male."
    }
    
    @IBAction func selectFemale(_ sender: UIButton) {
        genderLabel.text = genderPrefix + "female."
    }
    
    @IBAction func submit(_ sender: UIButton) {
        
    }
    
    @IBAction func goBack(_ sender: Any) {
        hero.dismissViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
