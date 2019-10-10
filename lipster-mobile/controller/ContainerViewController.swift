//
//  ContainerViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 17/9/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit
import Hero

class ContainerViewController: UIViewController {
    
    @IBOutlet weak var lipstickDescription: UILabel!
    @IBOutlet weak var lipstickIngredients: UILabel!
    
    var lipstick : Lipstick?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialUI()
        
    }

    func initialUI() {
        if let lipstick = self.lipstick{
            
            self.lipstickDescription.text = lipstick.lipstickDetail
            self.lipstickIngredients.text = lipstick.lipstickIngredients
            lipstickDescription.numberOfLines = 7
            lipstickIngredients.numberOfLines = 7
        }
    }
}
