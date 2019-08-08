//
//  TrendsViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 20/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class TrendListViewController: UITableViewController   {
    
    var trendGroupList = [TrendGroup]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

// UITableView
extension TrendListViewController {
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? TrendGroupTableViewCell else {return}
        
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self as UICollectionViewDataSource & UICollectionViewDelegate, forRow: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trendGroupList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "trendGroupTableViewCell", for: indexPath) as! TrendGroupTableViewCell
        cell.trendName.text = trendGroupList[indexPath.item].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showTrendDetail", sender: indexPath.item)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TrendDetailViewController {
            let indexItemSelect = sender as! Int
            destination.trendGroup = trendGroupList[indexItemSelect]
        }
    }
    
}

// UICollectionView
extension TrendListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let number = trendGroupList[collectionView.tag].trends!.count
        return number < 4 ? number : 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendImageCollectionViewCell", for: indexPath) as? TrendImageCollectionViewCell
        
//        cell?.imageTrend.image = trendGroupList[collectionView.tag].trends![indexPath.item].trendImage
        cell?.imageTrend.sd_setImage(with: URL(string: trendGroupList[collectionView.tag].trends![indexPath.item].image), placeholderImage: UIImage(named: "nopic"))
        
        return cell!
    }
}

