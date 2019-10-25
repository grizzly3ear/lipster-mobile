//
//  SignUpViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 11/8/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit
import Hero

class SignUpViewController: UIViewController {

    @IBOutlet weak var formContainer: UIImageView!
    @IBOutlet weak var leftLine: UIImageView!
    @IBOutlet weak var rightLine: UIImageView!
    @IBOutlet weak var lineLabel: UILabel!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initHero()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        hero.dismissViewController()
    }
}

extension SignUpViewController {
    func initHero() {
        self.hero.isEnabled = true
        self.formContainer.hero.id = "formContainer"
        self.leftLine.hero.id = "leftLine"
        self.rightLine.hero.id = "rightLine"
        self.lineLabel.hero.id = "lineLabel"
        self.facebookButton.hero.id = "facebookButton"
        self.submitButton.hero.id = "primaryActionButton"
    }
}
