//
//  NewTrendGroupViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 18/10/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class NewTrendGroupViewController: UIViewController ,UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    var trendGroups = [TrendGroup]()
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trendGroups.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        performSegue(withIdentifier: "showPinterest", sender: indexPath.item)
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewTrendGroupCollectionViewCell", for: indexPath) as! NewTrendGroupCollectionViewCell
        
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        
        
        cell.hero.modifiers = [.fade, .scale(0.2)]
        let trend = trendGroups[collectionView.tag].trends![indexPath.item]
        cell.setTrendGroup(trendGroup: trendGroups[indexPath.item])
        
        return cell
    }
    
    @IBAction func goBack(_ sender: Any) {
        hero.dismissViewController()
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
