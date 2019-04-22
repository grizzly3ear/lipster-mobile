//
//  TrendsViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 20/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class TrendsViewController: UIViewController   {

//    @IBOutlet weak var trendNameLabel: UILabel!
//    @IBOutlet weak var trendImgView: UIImageView!
//    @IBOutlet weak var lipColorView: UIView!
//    @IBOutlet weak var skinColorView: UIView!
    var lipColor: UIColor?
    var arrayOfTrendImg = [UIImage]()
    var arrayOfTrendLipColor = [UIColor]()
    var arrayOfTrendSkinColor = [UIColor]()
    var arrayOfTrendName = [String]()
    
    var trendList = [[Trend]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 0...3 {
            var trendYear = [Trend]()
            for j in 1...2 {
                let trend = Trend(trendImage: UIImage(named: "user\(j)")!, trendName: "name\(j)", trendLipstickColor: UIColor(rgb: 0xFA4855), trendSkinColor: UIColor(rgb: 0xFA4855))
                trendYear.append(trend)
            }
            trendList.append(trendYear)
        }
//        arrayOfTrendImg = [UIImage(named: "user1")! ,UIImage(named: "user2")!,UIImage(named: "user2")! ,UIImage(named: "user1")! ,UIImage(named: "user1")! ]
//        arrayOfTrendLipColor = [UIColor(rgb: 0xFA4855) ,UIColor(rgb: 0xFA4825) ,UIColor(rgb: 0xFA4255), UIColor(rgb: 0xFA4805), UIColor(rgb: 0xFA4805)]
//        arrayOfTrendLipColor = [ UIColor(rgb: 0xF4D3C0), UIColor(rgb: 0xE3C19C) , UIColor(rgb: 0xF6C5A4), UIColor(rgb: 0xF6C5A4), UIColor(rgb: 0xFA4805)]
//       arrayOfTrendName = [ "Trend of the year 2019 ","Trend of the year 2013 ","Trend of the year 2018 ","Trend of the year 2019 ","Trend of the year 2010" ]
        
    }
  
}
extension TrendsViewController :  UICollectionViewDataSource , UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  trendList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendsCollectionViewCell" , for: indexPath) as! TrendsCollectionViewCell
        cell.backgroundColor = .red
//
//        cell.trendsImageView.image = arrayOfTrendImg[indexPath.row]
//        cell.trendNameCell.text! = arrayOfTrendName[indexPath.row]
//    //     cell.trendColorCell.backgroundColor = arrayOfTrendLipColor [indexPath.row]
//     //    cell.trendSkinColorCell.backgroundColor = arrayOfTrendSkinColor[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let mainTrendStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let desVc = mainTrendStoryboard.instantiateViewController(withIdentifier: "TrendDetailViewController") as! TrendDetailViewController
//        desVc.trendBigImage = arrayOfTrendImg[indexPath.row]
//        desVc.trendName = arrayOfTrendName[indexPath.row]
//       //   desVc.trendLipColor = arrayOfTrendLipColor[indexPath.row]
//      //   desVc.trendSkinColor = arrayOfTrendSkinColor[indexPath.row]
//        self.navigationController?.pushViewController(desVc, animated: true)
        performSegue(withIdentifier: "showTrendDetail", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TrendDetailViewController {
            let rowSelect = sender as? Int
            destination.trend = trendList[rowSelect!]
        }
    }
}
