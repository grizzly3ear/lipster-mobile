//
//  ViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 13/3/2562 BE.
//  Copyright © 2562 Mainatvara. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner

class LipstickListViewController: UITableViewController  {

    @IBOutlet var lipListTableView: UITableView!
    
    var lipColor: UIColor?
    var searchController : UISearchController!
    var resultController = UITableViewController()
    var lipstickList = [Lipstick]()
    
    var isFav = UserDefaults.standard.bool(forKey: "isFav")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
 
        addNavBarImage()
        searchBarLip()
    }
    
    @IBAction func favButtonClicked(_ sender: UIButton) {
        print("clicked!!!")
        if isFav == true {
            let image = UIImage(named: "favButton_off")
            sender.setImage(image, for: UIControl.State.normal)
        } else {
            let image = UIImage(named: "favButton_on")
            sender.setImage(image, for: UIControl.State.normal)
        }
        
        isFav = !isFav
        UserDefaults.standard.set(isFav, forKey: "isFav")
        UserDefaults.standard.synchronize()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? LipstickDetailSegmentVC {
            destination.lipstick = lipstickList[(lipListTableView.indexPathForSelectedRow?.row)!]
        }
    }

}

extension LipstickListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lipstickList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LipstickListTableViewCell") as! LipstickListTableViewCell
        let lipstick = lipstickList[indexPath.item]
        print(lipstick)
        cell.setLipstick(lipstick: lipstick)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showLipstickDetail" , sender: self)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}

// logo and NavBar
extension LipstickListViewController{
    
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
extension LipstickListViewController : UISearchControllerDelegate , UISearchBarDelegate{
    
    func searchBarLip() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        
        if #available(iOS 11.0, *) {
            let search = UISearchController(searchResultsController: nil)
            search.delegate = self
            let searchBackground = search.searchBar
            searchBackground.placeholder = "Brand, Color, ..."
            
            if let textfield = searchBackground.value(forKey: "searchField") as? UITextField {
                textfield.textColor = UIColor.black
                if let backgroundview = textfield.subviews.first {
                    
                    backgroundview.backgroundColor = UIColor.white
                    
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


