//
//  HomeTableViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 21/10/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result
import Hero
import FAPaginationLayout

class HomeTableViewController: UITableViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var todayTrendCollectionView: UICollectionView!
    @IBOutlet weak var recommendForYouCollectionView: UICollectionView!
    @IBOutlet weak var trendHeaderCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var recommendCollectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var trends = [Trend]()
    var trendGroups = [TrendGroup]()
    var recommendLipstick = [Lipstick]()
    let trendDataPipe = Signal<[TrendGroup], NoError>.pipe()
    var trnedDataObserver: Signal<[TrendGroup], NoError>.Observer?
    
    let lipstickDataPipe = Signal<[Lipstick], NoError>.pipe()
    var lipstickDataObserver: Signal<[Lipstick], NoError>.Observer?
    var isNeedToRefresh: Bool = false
    
  
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *){
            return .lightContent
        }
        return .default
    }
    
    var refresher : UIRefreshControl!
    
    @objc func requestData(){
        print("request")
        self.isNeedToRefresh = true
        fetchData()
//        refresher.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recommendForYouCollectionView.dataSource = self
        trendHeaderCollectionView.dataSource = self
        
        print(trendGroups.count)
        print(recommendLipstick.count)
        
        refresher = UIRefreshControl()
        refresher.tintColor = .white
        refresher.backgroundColor = .black
        refresher.addTarget(self, action: #selector(HomeTableViewController.requestData), for: .valueChanged)
        tableView.addSubview(refresher)

        trendHeaderCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast

        trendHeaderCollectionView.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        trendHeaderCollectionView.contentInsetAdjustmentBehavior = .never
        initReactive()
        
        fetchData()
        
        recommendForYouCollectionView.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)

    }
    
    func fetchData() {
        TrendRepository.fetchAllTrendData { (trendGroups, _) in
            self.trendDataPipe.input.send(value: trendGroups)
        }
        LipstickRepository.fetchAllLipstickData { (lipsticks) in
            self.lipstickDataPipe.input.send(value: lipsticks)
            if self.isNeedToRefresh {
                print("finish")
                self.isNeedToRefresh = false
                self.refresher.endRefreshing()
            }
        }
    }
 
  
    
    @IBAction func seemoreButtonPress(_ sender: Any) {
        performSegue(withIdentifier: "showTrendGroup", sender: self)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
//
//        let trendGroup = trendGroups[indexPath.item]
//        cell.trendGroup = trendGroup
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "showPinterest", sender: indexPath.item)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateCellsLayout()
    }

    func updateCellsLayout()  {

        let centerX = trendHeaderCollectionView.contentOffset.x + (trendHeaderCollectionView.frame.size.width)/2
        for cell in trendHeaderCollectionView.visibleCells {

        var offsetX = centerX - cell.center.x

        if offsetX < 0 {
            offsetX *= -1
        }
        cell.transform = CGAffineTransform.identity
        let offsetPercentage = offsetX / (view.bounds.width * 2.7 )

        let scaleX = 1-offsetPercentage
            cell.transform = CGAffineTransform(scaleX: scaleX, y: scaleX)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == trendHeaderCollectionView {
        var cellSize: CGSize = collectionView.bounds.size
        print(cellSize.width)
    
            cellSize.width -= collectionView.contentInset.left * 2
            cellSize.width -= collectionView.contentInset.right * 2
           // cellSize.height = cellSize.width

        return cellSize
        }
        else {
            return CGSize(width: 150, height: 230)
        }
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCellsLayout()
    }

    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
            case trendHeaderCollectionView:
                return trends.count >= 5 ? 5 : trends.count
            case recommendForYouCollectionView:
                return recommendLipstick.count >= 5 ? 5 : recommendLipstick.count
            default: return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        switch collectionView {
        case trendHeaderCollectionView : performSegue(withIdentifier: "showTrendDetail", sender: indexPath.item)
            break
        case recommendForYouCollectionView : performSegue(withIdentifier: "showLipstickDetail", sender: indexPath.item)
            break
        default:
            break
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == trendHeaderCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendsCollectionViewCell", for: indexPath) as! TrendsCollectionViewCell
        
            cell.layer.cornerRadius = 10
            cell.clipsToBounds = true
        
            let trend = trends[indexPath.item]
            cell.trendImage.sd_setImage(with: URL(string: trends[indexPath.item].image), placeholderImage: UIImage(named: "nopic"))
            cell.trendTitle.text = trend.title
            cell.TrendDescription.text = trend.detail
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendForYouCollectionViewCell", for: indexPath) as! RecommendForYouCollectionViewCell
            let lipstick =  recommendLipstick[indexPath.item]
            
            
            cell.recommendForYouName.text = lipstick.lipstickName
            cell.recommendForYouBrand.text = lipstick.lipstickBrand
            cell.recommendForYouImage.sd_setImage(with: URL(string: lipstick.lipstickImage.first ?? ""), placeholderImage: UIImage(named : "nopic"))
                        
            return cell
        }
    }
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        return CGSize(width: 150, height: 230)
//    }

    
    private func indexOfMajorCell() -> Int {
        let itemWidth = collectionViewLayout.itemSize.width
        let proportionalOffset = collectionViewLayout.collectionView!.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(trends.count - 1, index))
        return safeIndex
    }

    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        if scrollView.tag == 1 {
            targetContentOffset.pointee = scrollView.contentOffset
            let indexOfMajorCell = self.indexOfMajorCell()
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueIdentifier = segue.identifier
        
        if segueIdentifier == "showPinterest" {
            if let destination = segue.destination as? PinterestCollectionViewController {
                let item = sender as! Int
                destination.trendGroup = trendGroups[item]
                
            }
        }
        else if segueIdentifier == "showTrendGroup" {
            if let destination = segue.destination as? TrendGroupViewController {
                destination.trendGroups = trendGroups
            }
        }
        else if segueIdentifier == "showTrendDetail" {
            if let destination = segue.destination as? TrendDetailViewController {
                let item = sender as! Int
                destination.trend = trends[item]
            }
        }
    }
}

extension HomeTableViewController {
    func initReactive() {
        self.lipstickDataObserver = Signal<[Lipstick], NoError>.Observer(value: { (lipsticks) in
            Lipstick.setLipstickArrayToUserDefault(forKey: DefaultConstant.lipstickData, lipsticks)
            self.recommendLipstick = lipsticks
            self.recommendForYouCollectionView.performBatchUpdates({
                self.recommendForYouCollectionView.reloadSections(IndexSet(integer: 0))
            }) { (_) in
                
            }
        })
        
        self.lipstickDataPipe.output.observe(lipstickDataObserver!)
        
        self.trnedDataObserver = Signal<[TrendGroup], NoError>.Observer(value: { (trendGroups) in
            self.trendGroups = trendGroups
            
            self.trendGroups.forEach { (trendGroup) in
                if let trend = trendGroup.trends?.randomElement() {
                    self.trends.append(trend)
                }
            }
            
            self.tableView.performBatchUpdates({
                self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }) { (_) in
                
            }
            
            self.trendHeaderCollectionView.performBatchUpdates({
                self.trendHeaderCollectionView.reloadSections(IndexSet(integer: 0))
            }) { (_) in

            }
        })
        
        self.trendDataPipe.output.observe(self.trnedDataObserver!)
    }
}


