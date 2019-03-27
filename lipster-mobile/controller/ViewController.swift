//
//  ViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 13/3/2562 BE.
//  Copyright © 2562 Mainatvara. All rights reserved.
//

import UIKit

class ViewController:  UITableViewController , UISearchControllerDelegate , UISearchBarDelegate {
    
    // change variable name
    @IBOutlet var lipListTableView: UITableView!
    @IBOutlet var searchBar : UISearchBar!
  
   // @IBOutlet weak var favButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lipList = self.createArray()
        self.lipListTableView.delegate = self
        self.lipListTableView.dataSource = self
       
        addNavBarImage()
      
        //navigationController?.navigationBar.prefersLargeTitles = true
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        //navigationItem.largeTitleDisplayMode = .never
        
        //        if #available(iOS 11.0, *) {
        //            let sc = UISearchController(searchResultsController: nil)
        //            if let navigationbar = self.navigationController?.navigationBar {
        //                navigationbar.barTintColor = UIColor(patternImage: UIImage(named: "BE115")!)
        //            }
        //            navigationItem.searchController = sc
        //            navigationItem.hidesSearchBarWhenScrolling = false
        //        }
        
        if #available(iOS 11.0, *) {
            let search = UISearchController(searchResultsController: nil)
            search.delegate = self
            let searchBackground = search.searchBar
            searchBackground.tintColor = UIColor.white
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
    
    
    @IBAction func favClicked(_ sender: UIButton) {
        if sender.currentImage == #imageLiteral(resourceName: "favButton_off") {
            sender.setImage(#imageLiteral(resourceName: "favButton_on"), for: .normal)
        }else{
            sender.setImage(#imageLiteral(resourceName: "favButton_off"), for: .normal)
        }
    }
    
    var lipList:[Lipstick] = [Lipstick] ()
    func createArray() -> [Lipstick] {
        
        let lip1 : Lipstick = Lipstick(lipstickImage: #imageLiteral(resourceName: "BE115"), lipstickBrand: "ETUDE", lipstickName: "Dear My Lip Talk ", lipstickColorName: "BE115", lipShortDetail: "Matte, totally reinvented. Delivering a romantic blur of soft-focus colour, this weightless moisture-matte lipstick was developed to replicate a backstage technique: blending out edges of matte lipstick for a hazy effect. Its groundbreaking formula contains moisture-coated powder pigments that condition and hydrate lips. The result is the zero-shine look of a matte lipstick with the cushiony, lightweight feel of a balm. Fall for this all-new soft-touch, misty matte kiss of colour." )
        let lip2 : Lipstick = Lipstick(lipstickImage: #imageLiteral(resourceName: "BE116"), lipstickBrand: "ETUDE", lipstickName:"Dear My Lip Talk " , lipstickColorName: "BE116", lipShortDetail: "Detail of the lipstick is  ....")
        let lip3 : Lipstick = Lipstick(lipstickImage: #imageLiteral(resourceName: "OR214"), lipstickBrand: "ETUDE", lipstickName: "OR241", lipstickColorName: "OR241", lipShortDetail: "Detail of the lipstick is  ....   ")
        let lip4 : Lipstick = Lipstick(lipstickImage: #imageLiteral(resourceName: "PK037"), lipstickBrand: "ETUDE", lipstickName: "Dear My Lip Talk ", lipstickColorName: "PK035", lipShortDetail: "Detail of the lipstick is  ....")
        let lip5 : Lipstick = Lipstick(lipstickImage: #imageLiteral(resourceName: "PK035"), lipstickBrand: "ETUDE", lipstickName: "Dear My Lip Talk ", lipstickColorName: "PK037", lipShortDetail: "Detail of the lipstick is  ....")

    
        return [lip1, lip2, lip3, lip4, lip5]
    }
    
    //          logo in nav bar
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


extension ViewController   {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lipList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LipstickListTableViewCell") as! LipstickListTableViewCell
        cell.setLipstick(lipstick: lipList[indexPath.row])
//        cell.lipImageView.image = lipList[indexPath.row].lipstickImage
//        cell.lipNameLabel.text = lipList[indexPath.row].lipstickName
//        cell.lipShortDetail.text = lipList[indexPath.row].lipShortDetail
        
        cell.selectionStyle = .none
        cell.favButton.addTarget(self, action: #selector(favClicked(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func favClicked (sender : UIButton){
         print("cilcked")
        if sender.isSelected {
            //unlike the butoon
            sender.isSelected = false

        } else {
            // like it
            sender.isSelected = true

        }
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       performSegue(withIdentifier: "showDetails" , sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? LipstickDetailViewController {
            destination.lipstick = lipList[(lipListTableView.indexPathForSelectedRow?.row)!]
        }
    }


}




