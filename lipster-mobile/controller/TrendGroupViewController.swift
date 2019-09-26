//
//  TrendGroup2ViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 15/8/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit
import Hero

class TrendGroupViewController: UIViewController , UITableViewDataSource , UITableViewDelegate , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trendGroups.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrendGroupTableViewCell") as! TrendGroup2TableViewCell
        cell.trendCollectionView.delegate = self
        cell.trendCollectionView.dataSource = self
        cell.trendCollectionView.tag = indexPath.row
        cell.setTrendGroup(trendGroup: trendGroups[indexPath.item])
        cell.trendCollectionView.reloadData()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showPinterest", sender: indexPath.item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    var trendGroups = [TrendGroup]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (trendGroups[collectionView.tag].trends?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendGroupCollectionViewCell", for: indexPath) as! TrendGroup2CollectionViewCell
        
        cell.hero.modifiers = [.fade, .scale(0.2)]
        
        let trend = trendGroups[collectionView.tag].trends![indexPath.item]
        cell.setTrend(trend: trend)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath )-> CGSize {
        return CGSize(width: 65
        , height: 144)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueIdentifier = segue.identifier
        if segueIdentifier == "showPinterest" {
            let item = sender as! Int
            print(item)
            let destination = segue.destination as? PinterestViewController
            destination?.trends = trendGroups[item].trends!
        }
    }
    
}





