//
//  HomeViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 19/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController , UISearchControllerDelegate , UISearchBarDelegate {
    
    
    @IBOutlet weak var trendsCollectionView: UICollectionView!
    @IBOutlet weak var recCollectionView: UICollectionView!
    @IBOutlet weak var recentCollectionView: UICollectionView!
    
    var arrayOfTrendImg = [UIImage]()
    var arrayOfRecImage  = [UIImage]()
    var arrayOfRecBrand = [String]()
    var arrayOfRecName = [String]()
    
    var searchController : UISearchController!
    
    var trends  = [Trends] ()
    func createTrendsArray() -> [Trends] {
        let trend1 : Trends = Trends(trendImage: #imageLiteral(resourceName: "user2"), trendName: "Trend of the month | January 2019", trendLipstickColor: UIColor(rgb: 0xF4D3C0), trendSkinColor: UIColor(rgb: 0xF4D3C6) )
        let trend2 : Trends = Trends(trendImage: #imageLiteral(resourceName: "user1"), trendName: "Trend of the month | January 2019", trendLipstickColor: UIColor(rgb: 0xF4D3C0), trendSkinColor: UIColor(rgb: 0xF4D3C6) )
        let trend3 : Trends = Trends(trendImage: #imageLiteral(resourceName: "user2"), trendName: "Trend of the month | January 2019", trendLipstickColor: UIColor(rgb: 0xF4D3C0), trendSkinColor: UIColor(rgb: 0xF4D3C6) )
        let trend4 : Trends = Trends(trendImage: #imageLiteral(resourceName: "user1"), trendName: "Trend of the month | January 2019", trendLipstickColor: UIColor(rgb: 0xF4D3C0), trendSkinColor: UIColor(rgb: 0xF4D3C6) )
        
        return [trend1 , trend2 ,trend3 , trend4]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayOfTrendImg = [UIImage(named: "user1")! ,UIImage(named: "user2")!,UIImage(named: "user2")! ,UIImage(named: "user1")! ,UIImage(named: "user1")! ]
        arrayOfRecImage = [UIImage(named: "BE115")! ,UIImage(named: "BE115")!,UIImage(named: "BE116")!,UIImage(named: "BE116")! ]
        arrayOfRecBrand = ["ETUDE" , "CHANEL" , "aaaa","aeee"]
        arrayOfRecName = ["2222" , "aaaa" , "aaaa","aeee"]
        
        // LipstickListViewController().addNavBarImage()
      //  LipstickListViewController().searchBarLip()
        searchBarLip()
        addNavBarImage()
       
    }
    
    @IBAction func clickedTrendImage(_ sender: Any) {
        print("clicked trend image")
     //   self.performSegue(withIdentifier: "showTrendDetail", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueIdentifier = segue.identifier
        if segueIdentifier == "showRecommendList" {
            print("showRecommendList")
//            var destination = segue.destination as? LipstickListViewController {
//                // we gonna set the array of lipstick here
//            }
            
        } else if segueIdentifier == "showRecentList" {
            print("showRecentList")
//            var destination = segue.destination as? LipstickListViewController {
//                // we gonna set the array of lipstick here
//            }
            
        } else if segueIdentifier == "showTrendList" {
            print("showTrendList")
            if segue.destination is TrendsViewController {
//                // we gonna set the array of trend here
    
            }
        }
    }
   
    
}
extension HomeViewController{
    func searchBarLip() {
        //navigationController?.navigationBar.prefersLargeTitles = true
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        
        if #available(iOS 11.0, *) {
            let search = UISearchController(searchResultsController: nil)
            search.delegate = self
            let searchBackground = search.searchBar
            // searchBackground.tintColor = UIColor.white
            searchBackground.placeholder = "Brand, Color, ..."
            // searchBackground.barTintColor = UIColor.white
            
            if let textfield = searchBackground.value(forKey: "searchField") as? UITextField {
                textfield.textColor = UIColor.black
                if let backgroundview = textfield.subviews.first {
                    
                    // Background color
                    backgroundview.backgroundColor = UIColor.white
                    
                    // corner
                    backgroundview.layer.cornerRadius = 10;
                    backgroundview.clipsToBounds = true;
                }
            }
            
            if let navigationbar = self.navigationController?.navigationBar {
                navigationbar.barTintColor = UIColor.black
            }
            navigationItem.searchController = search
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
}
extension HomeViewController {
    func addNavBarImage(){
        let navController = navigationController!
        let image = UIImage(named: "logo-3")
        let imageView = UIImageView(image : image)
        
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        
        let bannerX = (bannerWidth / 2 ) - (image!.size.width / 2 )
        let bannerY = (bannerHeight / 2 ) - (image!.size.height / 2 )
        
        imageView.frame = CGRect( x : bannerX, y: bannerY , width: bannerWidth , height : bannerHeight)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView  = imageView
    }
}
extension HomeViewController: UICollectionViewDataSource , UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == trendsCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendImageCollectionViewcell" , for: indexPath) as! TrendHomeCollectionViewCell
           // cell.setTrend(trends: trends[indexPath.row])
          //  cell.trendImageView.image = trends[indexPath.row].trendImage
            let imageView = cell.viewWithTag(1) as! UIImageView
            imageView.image =  arrayOfTrendImg[indexPath.row]
         
            return cell
        }
        else if (collectionView == recentCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentlyCollectionViewCell" , for: indexPath) as! RecentlyViewHomeCollectionViewCell
            cell.RecentImageView.image = arrayOfRecImage[indexPath.row]
            cell.RecentBrandLabel.text! = arrayOfRecBrand[indexPath.row]
            cell.RecentNameLabel.text! = arrayOfRecName[indexPath.row]
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecCollectionViewCell" , for: indexPath) as! RecHomeCollectionViewCell
            //            let imageView = cell.viewWithTag(2) as! UIImageView
            //            imageView.image = arrayOfRecImage[indexPath.row]
            cell.recImageView.image = arrayOfRecImage[indexPath.row]
            cell.recBrandLabel.text! = arrayOfRecBrand[indexPath.row]
            cell.recNameLabel.text! = arrayOfRecName[indexPath.row]
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainTrendStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVc = mainTrendStoryboard.instantiateViewController(withIdentifier: "TrendDetailViewController") as! TrendDetailViewController
        desVc.trendBigImage = trends[indexPath.row].trendImage
        desVc.trendLipColor = trends[indexPath.row].trendLipstickColor
        desVc.trendSkinColor = trends[indexPath.row].trendSkinColor
        self.navigationController?.pushViewController(desVc, animated: true)
    }
}
