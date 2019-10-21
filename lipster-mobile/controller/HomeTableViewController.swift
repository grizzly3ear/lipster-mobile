//
//  HomeTableViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 21/10/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController , UICollectionViewDelegate , UICollectionViewDataSource{

    @IBOutlet weak var trendHeaderCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    
    var trends: [Trend]?
    var trendGroups : [TrendGroup]?
    override func viewDidLoad() {
        super.viewDidLoad()
     //   trendHeaderCollectionView.dataSource = self as! UICollectionViewDataSource
       
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
       // cell.trendGroupImage.sd_setImage(with: URL(string: trendGroups![indexPath.item].image!), placeholderImage: UIImage(named: "nopic"))
        cell.trendGroupTitle.text = trendGroup.name
        //  cell.trendGroupHomeDescription.text = trendGroup.Detail
        return cell
    }
 

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trends!.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        performSegue(withIdentifier: "showPinterest", sender: indexPath.item)
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendsCollectionViewCell", for: indexPath) as! TrendsCollectionViewCell
        
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        
        let trend = trends![indexPath.item]
        cell.trendImage.sd_setImage(with: URL(string: trends![indexPath.item].image), placeholderImage: UIImage(named: "nopic"))
        cell.trendTitle.text = trend.title
        cell.TrendDescription.text = trend.detail
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
            destination?.trends = trendGroups![item].trends!
        }
    }
    
    private func indexOfMajorCell() -> Int {
        let itemWidth = collectionViewLayout.itemSize.width
        let proportionalOffset = collectionViewLayout.collectionView!.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(trends!.count - 1, index))
        return safeIndex
    }
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>){
        targetContentOffset.pointee = scrollView.contentOffset
        let indexOfMajorCell = self.indexOfMajorCell()
        let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
        collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                
    }

}

