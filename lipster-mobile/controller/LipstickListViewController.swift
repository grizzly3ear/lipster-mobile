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

class LipstickListViewController:  UITableViewController  {

    @IBOutlet var lipListTableView: UITableView!
    
    var lipColor: UIColor?
    var searchController : UISearchController!
    var resultController = UITableViewController()
    var lipstickList = [Lipstick] ()
    
    var isFav = UserDefaults.standard.bool(forKey: "isFav")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        self.lipstickList = self.createArray()
 
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
            destination.lipstickList = lipstickList[(lipListTableView.indexPathForSelectedRow?.row)!]
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

// create array of lipstick
extension LipstickListViewController{
    
    func createArray() -> [Lipstick] {
        let lip1 : Lipstick = Lipstick(lipstickImage: [#imageLiteral(resourceName: "BE115") , UIImage(named: "BE115_pic2")!], lipstickBrand: "ETUDE", lipstickName: "Dear My Lip Talk ", lipstickColorName: "BE115", lipShortDetail: "Matte, totally reinvented. Delivering a romantic blur of soft-focus colour, this weightless moisture-matte lipstick was developed to replicate a backstage technique: blending out edges of matte lipstick for a hazy effect. Its groundbreaking formula contains moisture-coated powder pigments that condition and hydrate lips. The result is the zero-shine look of a matte lipstick with the cushiony, lightweight feel of a balm. Fall for this all-new soft-touch, misty matte kiss of colour.Matte, totally reinvented. Delivering a romantic blur of soft-focus colour, this weightless moisture-matte lipstick was developed to replicate a backstage technique: blending out edges of matte lipstick for a hazy effect. Its groundbreaking formula contains moisture-coated powder pigments that condition and hydrate lips. The result is the zero-shine look of a matte lipstick with the cushiony, lightweight feel of a balm. Fall for this all-new soft-touch, misty matte kiss of colour.", lipSelectedColor: #imageLiteral(resourceName: "01") ,lipstickColor : UIColor(rgb: 0x91171E) )
        let lip2 : Lipstick = Lipstick(lipstickImage: [#imageLiteral(resourceName: "BE116") , UIImage(named: "BE116_pic2")!], lipstickBrand: "ETUDE", lipstickName:"Dear My Lip Talk " , lipstickColorName: "BE116", lipShortDetail: "Detail of the lipstick is  ....", lipSelectedColor: #imageLiteral(resourceName: "04") ,lipstickColor : UIColor(rgb: 0xB74447) )
        let lip3 : Lipstick = Lipstick(lipstickImage: [#imageLiteral(resourceName: "OR214") , UIImage(named: "OR214_pic2")!], lipstickBrand: "ETUDE", lipstickName: "OR214", lipstickColorName: "OR241", lipShortDetail: "Detail of the lipstick is  ....   ", lipSelectedColor: #imageLiteral(resourceName: "03") ,lipstickColor : UIColor(rgb: 0xFA4855) )
        let lip4 : Lipstick = Lipstick(lipstickImage: [#imageLiteral(resourceName: "PK037") , UIImage(named: "OR214_pic2")!], lipstickBrand: "ETUDE", lipstickName: "Dear My Lip Talk ", lipstickColorName: "PK035", lipShortDetail: "Detail of the lipstick is  ....", lipSelectedColor: #imageLiteral(resourceName: "05") ,lipstickColor : UIColor(rgb: 0xFE486B) )
        let lip5 : Lipstick = Lipstick(lipstickImage: [#imageLiteral(resourceName: "PK035") , UIImage(named: "OR214_pic2")!], lipstickBrand: "ETUDE", lipstickName: "Dear My Lip Talk ", lipstickColorName: "PK037", lipShortDetail: "Detail of the lipstick is  ....", lipSelectedColor:#imageLiteral(resourceName: "06") ,lipstickColor : UIColor(rgb: 0xFF9A94) )
        
        return [lip1, lip2, lip3, lip4, lip5]
    }
}


