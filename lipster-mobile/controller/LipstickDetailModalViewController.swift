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

class LipstickDetailModalViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lipstickTitle: UILabel!
    @IBOutlet weak var lipstickColorName: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var lipstick: Lipstick?
    var trends: [Trend]!
    
    func setLipstick(_ lipstick: Lipstick) {
        imageView.sd_setImage(with: URL(string: lipstick.lipstickImage.first ?? ""), placeholderImage: UIImage(named: "nopic")!)
        lipstickTitle.text = lipstick.lipstickBrand
        lipstickColorName.text = lipstick.lipstickColorName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true
        view.hero.id = "pullableView"
        setLipstick(lipstick!)
        collectionView.delegate = self
        collectionView.dataSource = self
        trends = createArray()
    }
    
    func createArray() -> [Trend] {
        let t1 = Trend("abc", "", .blue, .black, "")
        let t2 = Trend("abc", "", .blue, .black, "")
        let t3 = Trend("abc", "", .blue, .black, "")
        return [t1, t2, t3]
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

class TrendModalCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
}
