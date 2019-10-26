//
//  HomeTableViewCell.swift
//  lipster-mobile
//
//  Created by Mainatvara on 21/10/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell , UICollectionViewDelegate , UICollectionViewDataSource{


    var trendGroup: TrendGroup? 
    var trendGroups = [TrendGroup]()
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trendGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "todayTrendCollectionViewCell", for: indexPath) as! TodayTrendCollectionViewCell
        
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        
        let trendGroup = trendGroups[indexPath.item]
        cell.trendGroupImage.sd_setImage(with: URL(string: trendGroups[indexPath.item].image!), placeholderImage: UIImage(named: "nopic"))
        cell.trendGroupTitle.text = trendGroup.name

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      //  performSegue(withIdentifier: "showTrendDetail", sender: indexPath.item)
        collectionView.deselectItem(at: indexPath, animated: true)
//        switch collectionView {
//        case todayTrendCollectionView : performSegue(withIdentifier: "showTrendDetail", sender: indexPath.item)
//            break
//        default:
//            break
//        }

    }
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           let segueIdentifier = segue.identifier
           
           if segueIdentifier == "showPinterest" {
               if let destination = segue.destination as? PinterestCollectionViewController {
                   let item = sender as! Int
                   destination.trendGroup = trendGroups[item]
               }
           }
        
       }
    
    
}
    
    
