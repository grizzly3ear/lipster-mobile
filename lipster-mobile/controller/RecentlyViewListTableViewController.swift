//
//  RecentlyViewListTableViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 8/8/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class RecentlyViewListTableViewController: UITableViewController {
    @IBOutlet var recentlyViewListTableView: UITableView!
    
    var recentlyViewLipsticks  = [Lipstick] ()
    var lipColor: UIColor?
    var resultController = UITableViewController()
    var isFav = UserDefaults.standard.bool(forKey: "isFav")
    
    func createRecentlyViewLipstickArray() -> [Lipstick] {
        let fav1 : Lipstick = Lipstick( 111 ,  ["nopic"], "AAA", "ddewe", "VE222", "dffvweeeeeeee",  .gray, 225)
        let fav2 : Lipstick = Lipstick( 111 ,  ["BE115 , BE116"], "AAA", "ddewe", "VE222", "dffvweeeeeeee",  .gray, 225)
        let fav3 : Lipstick = Lipstick( 111 ,  ["BE115 , BE116"], "AAA", "ddewe", "VE222", "dffvweeeeeeee",  .gray, 225)
        let fav4 : Lipstick = Lipstick( 111 ,  ["BE115 , BE116"], "AAA", "ddewe", "VE222", "dffvweeeeeeee",  .gray, 225)
        
        return [fav1 , fav2 ,fav3,fav4]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        self.recentlyViewLipsticks  = self.createRecentlyViewLipstickArray()
        
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

extension RecentlyViewListTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  recentlyViewLipsticks .count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentlyViewListTableViewCell") as! RecentlyViewListTableViewCell
        let lipstick = recentlyViewLipsticks[indexPath.item]
        cell.setLipstick(lipstick: lipstick)
        //  cell.lipBrandLabel.text = brand[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //   performSegue(withIdentifier: "showLipstickDetail" , sender: self)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}
