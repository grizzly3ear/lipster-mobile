//
//  HomeTableViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 21/10/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    @IBOutlet weak var trendHeaderCollectionView: UICollectionView!
    
    var trends: [Trend]?
    var trendGroups : [TrendGroup]?
    override func viewDidLoad() {
        super.viewDidLoad()

        
        trends = Trend.mockArrayData(size: 5)
        trendGroups = TrendGroup.mockArrayData(size: 5)
        
        trendHeaderCollectionView.contentInsetAdjustmentBehavior = .never
    }

    // MARK: - Table view data source

 

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trendGroups!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
        let trendGroup = trendGroups![indexPath.item]
        cell.trendGroupImage.sd_setImage(with: URL(string: trendGroups![indexPath.item].image!), placeholderImage: UIImage(named: "nopic"))
        cell.trendGroupTitle.text = trendGroup.name
        //  cell.trendGroupHomeDescription.text = tre
        return cell
    }
 

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
