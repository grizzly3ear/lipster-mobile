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
    
   // var notificationTitle = ["Trend of the year | 2019" , "Trend of the month | August ","Trend of the month 2011"]
    var yourNotification = [Notification]()
    func createNotificationArray() -> [Notification] {
        let noti1: Notification = Notification(title: "5 Cult Favorite Lipstick", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. " , dateAndTime : "05 November 2019" , destination : "ferf" , image : "nopic")
        let noti2: Notification = Notification(title: "Trend of the month November 2019", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. " , dateAndTime : "05 November 2019" , destination : "ferf" , image : "nopic")
        let noti3: Notification = Notification(title: "Trend of the month November 2019", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. " , dateAndTime : "06 November 2019" , destination : "ferf" , image : "nopic")
        let noti4: Notification = Notification(title: "Trend of the month November 2019", description: "dkefhajh;da" , dateAndTime : "11 November 2019" , destination : "ferf" , image : "nopic")

        return [noti1, noti2, noti3, noti4]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //notificationTableView.backgroundView = UIImageView(image: UIImage(named: "backgroundLiplist"))
        self.yourNotification =  self.createNotificationArray()

    
    }
    

}

extension NotificationViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  yourNotification.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell" , for : indexPath) as! NotificationTableViewCell
        let notification = yourNotification[indexPath.item]
        cell.notificationTitleLabel.text = notification.title
        cell.notificationDescription.text = notification.body
        cell.notificationDateTimeLabel.text = notification.date
        cell.notificationImageView.sd_setImage(with: URL(string: yourNotification[indexPath.item].image), placeholderImage: UIImage(named: "lip-logo-2"))
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }

}
