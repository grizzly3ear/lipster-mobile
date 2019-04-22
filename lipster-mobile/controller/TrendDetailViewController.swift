//
//  TrendDetailViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 20/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class TrendDetailViewController: UIViewController {

    @IBOutlet weak var trendBigImageView: UIImageView!
    @IBOutlet weak var trendLipColorView: UIView!
    @IBOutlet weak var trendSkinColorView: UIView!
    @IBOutlet weak var trendNameLabel: UILabel!
    
    @IBOutlet weak var scrollTrendImage: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var trendGroup: TrendGroup!
    var frame = CGRect(x:0,y:0,width:0 , height:0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageController()
    }
}

//scrollView of lipImg method
extension TrendDetailViewController {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollTrendImage.contentOffset.x / scrollTrendImage.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
}

// page controll to show multi Trend image
extension TrendDetailViewController: UIScrollViewDelegate {
    func pageController() {
        pageControl.numberOfPages = (self.trendGroup?.trendList!.count)!
        for index in 0..<pageControl.numberOfPages {
            frame.origin.x = scrollTrendImage.frame.size.width * CGFloat(index)
            frame.size = scrollTrendImage.frame.size
            
            let imgView = UIImageView(frame: frame)
            imgView.image = self.trendGroup.trendList![index].trendImage
            self.scrollTrendImage.addSubview(imgView)
        }
        scrollTrendImage.contentSize = CGSize(width :(scrollTrendImage.frame.size.width * CGFloat(pageControl.numberOfPages)) , height : scrollTrendImage.frame.size.height)
        scrollTrendImage.delegate = self
    }
}
