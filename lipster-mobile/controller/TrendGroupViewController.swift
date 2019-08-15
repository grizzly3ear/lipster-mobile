//
//  TrendGroup2ViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 15/8/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class TrendGroupViewController: UIViewController , UITableViewDataSource , UITableViewDelegate , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.trends = self.createTrendArray()
   
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrendGroupTableViewCell") as! TrendGroup2TableViewCell
        cell.trendCollectionView.delegate = self
        cell.trendCollectionView.dataSource = self
        cell.trendCollectionView.tag = indexPath.row
        cell.trendCollectionView.reloadData()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showPinterest", sender: self)
    }
    
    var trends = [Trend]()
    func createTrendArray() -> [Trend] {
        let trendGroup1 : Trend = Trend("Trend of the year 2020", "dedefrg", .gray, .green , "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ")
        let trendGroup2 : Trend = Trend("Trend of the year 2020", "dedefrg", .gray, .green , "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ")
        let trendGroup3 : Trend = Trend("Trend of the year 2020", "dedefrg", .gray, .green , "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ")
        let trendGroup4 : Trend = Trend("Trend of the year 2020", "dedefrg", .gray, .green , "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ")
        return [trendGroup1 , trendGroup2 , trendGroup3 ,trendGroup4]
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return trends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendGroupCollectionViewCell", for: indexPath) as! TrendGroup2CollectionViewCell
        
        let trend = trends[indexPath.item]
        cell.setTrend(trend: trend)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath )-> CGSize {
        return CGSize(width: 65
        , height: 144)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
    
}





