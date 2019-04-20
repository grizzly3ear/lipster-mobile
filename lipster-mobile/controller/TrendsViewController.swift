//
//  TrendsViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 20/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class TrendsViewController: UIViewController , UICollectionViewDataSource , UICollectionViewDelegate  {

    @IBOutlet weak var trendImgView: UIImageView!
    
    var arrayOfTrendImg = [UIImage]()
    var arrayOfTrendLipColor = [UIColor]()
    var arrayOfTrendSkinColor = [UIColor]()
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayOfTrendImg = [UIImage(named: "user1")! ,UIImage(named: "user2")!,UIImage(named: "user2")! ,UIImage(named: "user1")! ,UIImage(named: "user1")! ]
        arrayOfTrendLipColor = [UIColor(rgb: 0xFA4855) ,UIColor(rgb: 0xFA4825) ,UIColor(rgb: 0xFA4255), UIColor(rgb: 0xFA4805)]
        arrayOfTrendLipColor = [ UIColor(rgb: 0xF4D3C0), UIColor(rgb: 0xE3C19C) , UIColor(rgb: 0xF6C5A4), UIColor(rgb: 0xF6C5A4)]
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  arrayOfTrendImg.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendsCollectionViewCell" , for: indexPath) as! TrendsCollectionViewCell
        cell.trendsImageView.image = arrayOfTrendImg[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainTrendStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVc = mainTrendStoryboard.instantiateViewController(withIdentifier: "TrendDetailViewController") as! TrendDetailViewController
        desVc.trendBigImage = arrayOfTrendImg[indexPath.row]
      //  desVc.trendLipColor = arrayOfTrendLipColor[indexPath.row]
       // desVc.trendSkinColor = arrayOfTrendSkinColor[indexPath.row]
        self.navigationController?.pushViewController(desVc, animated: true)
    }
}
