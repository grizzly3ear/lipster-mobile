//
//  HomeViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 19/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController , UISearchControllerDelegate , UISearchBarDelegate , UICollectionViewDataSource , UICollectionViewDelegate {
    
    
    @IBOutlet weak var trendsCollectionView: UICollectionView!
    @IBOutlet weak var RecCollectionView: UICollectionView!
    
    var searchController : UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayOfTrendImg = [UIImage(named: "user1")! ,UIImage(named: "user2")!,UIImage(named: "user2")! ]
        arrayOfRecImage = [UIImage(named: "BE115")! ,UIImage(named: "BE115")!,UIImage(named: "BE116")!,UIImage(named: "BE116")! ]
        arrayOfRecBrand = ["ETUDE" , "CHANEL" , "aaaa","aeee"]
        arrayOfRecName = ["2222" , "aaaa" , "aaaa","aeee"]
    //LipstickListViewController().addNavBarImage()
      //  LipstickListViewController().searchBarLip()
       searchBarLip()
       addNavBarImage()
       
    }
    
    var arrayOfTrendImg = [UIImage]()
    var arrayOfRecImage  = [UIImage]()
    var arrayOfRecBrand = [String]()
    var arrayOfRecName = [String]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == trendsCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendImageCollectionViewcell" , for: indexPath) as! TrendHomeCollectionViewCell
            let imageView = cell.viewWithTag(1) as! UIImageView
            imageView.image = arrayOfTrendImg[indexPath.row]
            
        //    cell.trendImageView.image = UIImage(named: arrayOfTrendImg[indexPath.row])
            
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
    
    //  ------------------------- logo in nav bar-------------------------------
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
