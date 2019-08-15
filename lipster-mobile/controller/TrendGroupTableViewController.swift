//
//  TrendGroupTableViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 15/8/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class TrendGroupViewController: UIViewController , UITableViewController, UICollectionView {

    override func viewDidLoad() {
        super.viewDidLoad()

    
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrendGroupTableViewCell", for: indexPath) as? TrendGroup2TableViewCell

        // Configure the cell...

        return cell!
    }

}

//extension  TrendGroupTableViewController  : UICollectionView {
//
//
//}
