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
    
    var panGesture: UIPanGestureRecognizer?
    
    fileprivate let padding: CGFloat = 7.0
    fileprivate let showTrendDetail: String = "showTrendDetail"
    var headerView: PinterestHeaderCollectionReusableView?
    var defaultHeaderHeight: CGFloat?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = CHTCollectionViewWaterfallLayout()
        
        layout.minimumColumnSpacing = 7.0
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        collectionView.alwaysBounceVertical = true
        collectionView.collectionViewLayout = layout
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: padding, right: 0)
        collectionView.contentInsetAdjustmentBehavior = .never
        
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
            cell.image.contentMode = .scaleAspectFill
            cell.image.clipsToBounds = true
//            cell.image.hero.id = "trend\(indexPath.item)"
        }
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PinterestHeaderCollectionReusableView.cellId, for: indexPath) as? PinterestHeaderCollectionReusableView
        
        headerView?.trendGroup = trendGroup
        defaultHeaderHeight = headerView?.frame.height
        
        return headerView!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        
        if identifier == showTrendDetail {
            let indexPath = sender as! IndexPath
            let destination = segue.destination as! TrendDetailViewController
            destination.trend = trendGroup?.trends![indexPath.item]
//            destination.imageHeroId = "trend\(indexPath.item)"
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset.y)
        
        let contentOffsetY = scrollView.contentOffset.y
        let height = defaultHeaderHeight! - contentOffsetY
        print(height)
        
        if contentOffsetY > 0 {
            return
        }
        headerView?.frame = CGRect(
            x: 0,
            y: contentOffsetY,
            width: (headerView?.frame.width)!,
            height: height
        )
        headerView?.trendGroupImage.frame = CGRect(
            x: 0,
            y: 0,
            width: (headerView?.frame.width)!,
            height: height
        )
    }
    
    override func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
    }

}

extension PinterestCollectionViewController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let rect = CGSize(width: 167, height: Int.random(in: 200...450) )
        
        return rect
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForHeaderInSection section: Int) -> CGFloat {
        return 250.0
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
            performSegue(withIdentifier: showTrendDetail, sender: selectedIndex)
        }
    }
    
    @objc func like(_ sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: collectionView!)
        let indexPath = collectionView.indexPathForItem(at: touchPoint)
        if let selectedIndex = indexPath {
            let cell = collectionView.cellForItem(at: selectedIndex) as! TrendCollectionViewCell
            cell.likeAnimator.animate {
                self.addFavoriteTrend(self.trendGroup?.trends![selectedIndex.item])
            }
        }
    }
}

extension PinterestCollectionViewController {
    func initHero() {
        self.hero.isEnabled = true
        self.navigationController?.hero.navigationAnimationType = .selectBy(
            presenting: .slide(direction: .up),
            dismissing: .pageOut(direction: .down)
        )
    }
}

extension PinterestCollectionViewController {
    func addFavoriteTrend(_ trend: Trend?) {
        var favTrends: [Trend] = Trend.getTrendArrayFromUserDefault(forKey: DefaultConstant.favoriteTrends)
        
        if (trend != nil) {
            
            if let _ = favTrends.firstIndex(where: { $0 == trend! }) {
            } else {
                print("add")
                favTrends.append(trend!)
            }

            print(favTrends.count)
            Trend.setTrendArrayToUserDefault(forKey: DefaultConstant.favoriteTrends, favTrends)
        }
    }
}
