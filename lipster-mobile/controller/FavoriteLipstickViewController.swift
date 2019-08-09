//
//  FavoriteLipstickViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 8/8/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner

class FavoriteLipstickTableViewController:  UITableViewController  {
    @IBOutlet var favoriteLipstickListTableView: UITableView!
    
    var lipColor: UIColor?
    var resultController = UITableViewController()
    var lipstickList = [Lipstick]()
    
    var isFav = UserDefaults.standard.bool(forKey: "isFav")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        
    }
    
    @IBAction func favButtonClicked(_ sender: UIButton) {
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
//        if let destination = segue.destination as? LipstickDetailSegmentVC {
//            destination.lipstick = lipstickList[(favoriteLipstickListTableView.indexPathForSelectedRow?.row)!]
    //    }
    }
    
}

extension FavoriteLipstickTableViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lipstickList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteLipstickTableViewCell") as! FavoriteLipstickTableViewCell
        let lipstick = lipstickList[indexPath.item]
        cell.setLipstick(lipstick: lipstick)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     //   performSegue(withIdentifier: "showLipstickDetail" , sender: self)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}
