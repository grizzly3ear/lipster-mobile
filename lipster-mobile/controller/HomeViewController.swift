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
    @IBOutlet weak var recommendCollectionView: UICollectionView!
    @IBOutlet weak var recentCollectionView: UICollectionView!
    
    var searchController : UISearchController!
    
    var trendGroup = TrendGroup()
    var recommendLipstick = [Lipstick]()
    var recentViewLipstick = [Lipstick]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        
        if (false) { // if have internet connection
            guard let token: String = defaults.string(forKey: "userToken") else {return}
            retrieveData(token: token)
        } else {
//            use old data
        }
        // we gonna set data manually first for dev phase
        retrieveData(token: "some test token")
        
        searchBarLip()
        addNavBarImage()
       
    }
    
    func retrieveData(token: String) {
        let images = [UIImage(named: "BE115")! ,UIImage(named: "BE115")!,UIImage(named: "BE116")!,UIImage(named: "BE116")!]
        
        trendGroup.trendName = "Trend of the month | January 2019"
        trendGroup.trendList = [Trend]()
        let trend1 = Trend(trendImage: UIImage(named: "user1")!, trendLipstickColor: UIColor(rgb: 0xF4D3C0), trendSkinColor: UIColor(rgb: 0xF4D3C6) )
        let trend2 = Trend(trendImage: UIImage(named: "user1")!, trendLipstickColor: UIColor(rgb: 0xF4D3C0), trendSkinColor: UIColor(rgb: 0xF4D3C6) )
        let trend3 = Trend(trendImage: UIImage(named: "user1")!, trendLipstickColor: UIColor(rgb: 0xF4D3C0), trendSkinColor: UIColor(rgb: 0xF4D3C6) )
        let trend4 = Trend(trendImage: UIImage(named: "user1")!, trendLipstickColor: UIColor(rgb: 0xF4D3C0), trendSkinColor: UIColor(rgb: 0xF4D3C6) )
        trendGroup.trendList?.append(trend1)
        trendGroup.trendList?.append(trend2)
        trendGroup.trendList?.append(trend3)
        trendGroup.trendList?.append(trend4)

        for i in 1...5 {
            var lipstick = Lipstick()
            lipstick.lipstickColor = UIColor(rgb: 0xF4D3C6)
            lipstick.lipstickBrand = "Brand 1"
            lipstick.lipstickName = "firstLip"
            lipstick.lipstickColorName = "R01"
            lipstick.lipShortDetail = "Detail"
            lipstick.lipstickImage = images
            recommendLipstick.append(lipstick)
            recentViewLipstick.append(lipstick)
        }
        
        print("finish init data")
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueIdentifier = segue.identifier
        if segueIdentifier == "showRecommendList" {
            print("showRecommendList")
            if let destination = segue.destination as? LipstickListViewController {
                
            }
            
        } else if segueIdentifier == "showRecentList" {
            print("showRecentList")
//            var destination = segue.destination as? LipstickListViewController {

//            }
            
        } else if segueIdentifier == "showTrendGroupList" {
            print("showTrendGroupList")
            if segue.destination is TrendListViewController {

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
        return  3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == trendsCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendGroupCollectionViewcell" , for: indexPath) as! TrendHomeCollectionViewCell

            cell.trendHomeImageView.image = trendGroup.trendList![indexPath.row].trendImage
         
            return cell
        }
        else if (collectionView == recentCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recentlyCollectionViewCell" , for: indexPath) as! RecentlyViewHomeCollectionViewCell

            print(recentViewLipstick.count)
            print(recentViewLipstick[indexPath.item].lipstickImage.count)
            cell.recentImageView.image = recentViewLipstick[indexPath.item].lipstickImage.first
            cell.recentBrandLabel.text = recentViewLipstick[indexPath.item].lipstickBrand
            cell.recentNameLabel.text = recentViewLipstick[indexPath.item].lipstickName
            
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendCollectionViewCell" , for: indexPath) as! RecHomeCollectionViewCell
            
            cell.recImageView.image = recommendLipstick[indexPath.item].lipstickImage.first
            cell.recBrandLabel.text = recommendLipstick[indexPath.item].lipstickBrand
            cell.recNameLabel.text = recommendLipstick[indexPath.item].lipstickName
            
            return cell
        }
    }

}
