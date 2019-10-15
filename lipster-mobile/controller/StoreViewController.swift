//
//  StoreViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 14/10/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class StoreViewController: UIViewController {
    
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var storeHours: UILabel!
    @IBOutlet weak var storeDayOpen: UILabel!
    @IBOutlet weak var storeAddress: UILabel!
    @IBOutlet weak var storePhoneNumber: UILabel!
    @IBOutlet weak var titleNavigation: UINavigationItem!
    
    var store: Store?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.titleNavigation.title = store?.name
    }
    
    
    
    
}
