//
//  NotificationViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 10/5/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet weak var notificationTableView: UITableView!
    
    var notificationTitle = ["Trend of the year | 2019" , "Trend of the month | August ","Trend of the month 2011"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationTableView.backgroundView = UIImageView(image: UIImage(named: "backgroundLiplist"))
    
    }

}

extension NotificationViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  notificationTitle.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell" , for : indexPath) as! NotificationTableViewCell
        cell.notificationTitleLabel.text = notificationTitle[indexPath.row]
    
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}
