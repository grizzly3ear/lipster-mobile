//
//  PinterestCollectionViewController.swift
//  lipster-mobile
//
//  Created by Bank on 21/10/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit
import CHTCollectionViewWaterfallLayout
import Hero

class PinterestCollectionViewController: UICollectionViewController {

    var trendGroup: TrendGroup?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 15.0
        layout.minimumInteritemSpacing = 15.0
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.alwaysBounceVertical = true
        collectionView.collectionViewLayout = layout

        initGesture()
        initHero()
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        hero.dismissViewController()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let trends = trendGroup?.trends {
            return trends.count
        }

        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendCollectionViewCell.cellId, for: indexPath) as! TrendCollectionViewCell
        
        if let trends = trendGroup?.trends {
            cell.hero.modifiers = [
                .whenPresenting(
                    .translate(y: CGFloat(500 + (Double(indexPath.item) * 30))),
                    .fade,
                    .spring(stiffness: 100, damping: 15)
                )
            ]
            
            cell.image.sd_setImage(with: URL(string: trends[indexPath.item].image), placeholderImage: UIImage(named: "nopic")!)
            cell.image.layer.cornerRadius = 8.0
            cell.image.contentMode = .scaleAspectFit
            cell.image.clipsToBounds = true
            cell.image.hero.id = "trend\(indexPath.item)"
        }
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PinterestHeaderCollectionReusableView.cellId, for: indexPath)
        
        return header
    }

}

extension PinterestCollectionViewController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let rect = CGSize(width: 300, height: Int.random(in: 250...650) )
        
        return rect
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForHeaderInSection section: Int) -> CGFloat {
        return 301.0
    }
    
}

extension PinterestCollectionViewController {
    func initGesture() {
        collectionView.isUserInteractionEnabled = true
        setupClickGesture()
    }
    
    func setupClickGesture() {
        let viewDetailTap = UITapGestureRecognizer(target: self, action: #selector(self.viewDetail))
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(self.like))
        
        viewDetailTap.numberOfTapsRequired = 1
        likeTap.numberOfTapsRequired = 2
        
        viewDetailTap.require(toFail: likeTap)
        
        collectionView.addGestureRecognizer(viewDetailTap)
        collectionView.addGestureRecognizer(likeTap)
    }
    
    @objc func viewDetail(_ sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: collectionView)
        let indexPath = collectionView.indexPathForItem(at: touchPoint)
        if let selectedIndex = indexPath {
            print("view detail")
        }
    }
    
    @objc func like(_ sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: collectionView!)
        let indexPath = collectionView.indexPathForItem(at: touchPoint)
        if let selectedIndex = indexPath {
            print("like")
        }
    }
}

extension PinterestCollectionViewController {
    func initHero() {
        self.hero.isEnabled = true
        self.navigationController?.hero.navigationAnimationType = .selectBy(
            presenting: .slide(direction: .left),
            dismissing: .slide(direction: .right)
        )
    }
}
