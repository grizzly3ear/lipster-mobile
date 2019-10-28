//
//  StoreStockViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 28/10/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class StoreStockViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
   

    @IBOutlet weak var storeStockTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let lipstickBrandView = BrandLipstickView(frame: CGRect(x: 0, y: 0, width: storeStockTableView.frame.size.width, height: 40))
        return lipstickBrandView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 5
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "storeStockTableViewCell") as! StoreStockTableViewCell
        
        cell.stockLipstickBrand?.text = "LANCOME"
        return cell
       }
       
}
