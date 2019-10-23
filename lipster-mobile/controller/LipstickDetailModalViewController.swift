//
//  LipstickDetailModalViewController.swift
//  lipster-mobile
//
//  Created by Vitsarut Udomphol on 27/9/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import Foundation
import UIKit
import Hero
import CHTCollectionViewWaterfallLayout
import ReactiveCocoa
import ReactiveSwift
import Result

class LipstickDetailModalViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lipstickTitle: UILabel!
    @IBOutlet weak var lipstickColorName: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var favButton: UIButton!
    
    let trendDataPipe = Signal<[Trend], NoError>.pipe()
    var trendDataObserver: Signal<[Trend], NoError>.Observer?
    
    var lipstick: Lipstick?
    var trends: [Trend]!
    
    func setLipstick(_ lipstick: Lipstick) {
        imageView.sd_setImage(with: URL(string: lipstick.lipstickImage.first ?? ""), placeholderImage: UIImage(named: "nopic")!)
        lipstickTitle.text = lipstick.lipstickBrand
        lipstickColorName.text = lipstick.lipstickColorName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadTable()
        self.hero.isEnabled = true
        view.hero.id = "pullableView"
        setLipstick(lipstick!)
        collectionView.delegate = self
        collectionView.dataSource = self
        reloadFavButton()
        fetchData()
        
    }
    
    func reloadFavButton() {
        if Lipstick.isLipstickFav(lipstick) {
            let image = UIImage(named: "heart_red")
            favButton.setImage(image, for: UIControl.State.normal)
        } else {
            let image = UIImage(named: "heart_white")
            favButton.setImage(image, for: UIControl.State.normal)
        }
    }
    
    func fetchData() {
        DispatchQueue.main.async {
            TrendRepository.fetchSimilarTrendLipstick(self.lipstick!, completion: { (response) in
                self.trendDataPipe.input.send(value: response)
            })
        }
    }
    
    
    func reloadTable() {
        if trends == nil || trends.count == 0 {
            self.collectionView.backgroundColor = .clear
            
            let label = UILabel()
            label.frame.size.height = 42
            label.frame.size.width = self.collectionView.frame.size.width
            label.center = self.collectionView.center
            label.center.y = self.collectionView.frame.size.height / 2
            label.numberOfLines = 2
            label.textColor = .darkGray
            label.text = "There are no matching current trends."
            label.textAlignment = .center
            label.tag = 1
            
            self.collectionView.addSubview(label)
        } else {
            self.collectionView.viewWithTag(1)?.removeFromSuperview()
        }
    }
    
    @IBAction func toggleFavButton(_ sender: Any) {
        Lipstick.toggleFavLipstick(lipstick)
        reloadFavButton()
    }
}

extension LipstickDetailModalViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trends?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendModalCollectionViewCell", for: indexPath) as! TrendModalCollectionViewCell
        
        cell.hero.modifiers = [.fade, .scale(0.5)]
        
        cell.imageView.sd_setImage(with: URL(string: trends[indexPath.item].image), placeholderImage: UIImage(named: "nopic")!)
        cell.imageView.layer.cornerRadius = 8.0
        cell.imageView.contentMode = .scaleAspectFill
        cell.imageView.clipsToBounds = true
//        cell.imageView.hero.id = "trend\(indexPath.item)"
        
        return cell
    }
}

extension LipstickDetailModalViewController {
    func initReactiveTrendData() {
        trendDataObserver = Signal<[Trend], NoError>.Observer(value: { (trends) in
            self.trends = trends
            
            self.collectionView.reloadData()
            self.collectionView.setNeedsLayout()
            self.collectionView.layoutIfNeeded()
            self.reloadTable()
        })
        trendDataPipe.output.observe(trendDataObserver!)
    }
}

class TrendModalCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
}
