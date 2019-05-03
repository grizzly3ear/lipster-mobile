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
        for _ in 0...3 {
            let trendGroup = TrendGroup()
            trendGroup.trendName = "Trend of the year 2010"
            trendGroup.trendList = [Trend]()
            
            let trend1 = Trend(trendImage: UIImage(named: "user\(1)")!,trendLipstickColor: UIColor(rgb: 0xFA4855), trendSkinColor: UIColor(rgb: 0xFA4855))
            let trend2 = Trend(trendImage: UIImage(named: "user\(2)")!,trendLipstickColor: UIColor(rgb: 0xFA4825), trendSkinColor: UIColor(rgb: 0xE0E0E0))
            let trend3 = Trend(trendImage: UIImage(named: "user\(1)")!,trendLipstickColor: UIColor(rgb: 0xFA4805), trendSkinColor: UIColor(rgb: 0xFFEE00))
            
            trendGroup.trendList?.append(trend1)
            trendGroup.trendList?.append(trend2)
            trendGroup.trendList?.append(trend3)
            
            trendGroupList.append(trendGroup)
            
        }
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
        print("name is \(trendGroupList[indexPath.item])")
        cell.trendName.text = trendGroupList[indexPath.item].trendName
        
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
        
        print(trendGroupList[collectionView.tag])
        return trendGroupList[collectionView.tag].trendList!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendImageCollectionViewCell", for: indexPath) as? TrendImageCollectionViewCell
        
        cell?.imageTrend.image = trendGroupList[collectionView.tag].trendList![indexPath.item].trendImage
        
        return cell!
    }
}

