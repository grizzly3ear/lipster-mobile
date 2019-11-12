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
    @IBOutlet weak var headerLabel: UILabel!

    var notifications = [Notification]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let footer = UIView(frame: .zero)
        footer.backgroundColor = .white
        notificationTableView.tableFooterView = footer
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchData()
    }
    
    func fetchData() {
        UserRepository.getMyNotification { (notifications, _) in
            self.notifications = notifications
            self.notificationTableView.performBatchUpdates({
                self.notificationTableView.reloadSections(IndexSet(integer: 0), with: .none)
            }) { (_) in
                
            }
        }
    }
}

extension NotificationViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell" , for : indexPath) as! NotificationTableViewCell
        let notification = notifications[indexPath.item]
        
        cell.notificationTitleLabel.text = notification.title
        cell.notificationDescription.text = notification.body
        cell.notificationDateTimeLabel.text = notification.createdAt.formatDisplay()
        cell.notificationImageView.sd_setImage(with: URL(string: notifications[indexPath.item].image), placeholderImage: UIImage(named: "lip-logo-2"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let notification = notifications[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: notification.destination)
        
        if let exactVc = vc as? PinterestCollectionViewController {
            TrendRepository.fetchTrendGroupFromId(notification.modelId) { (trendGroup, _) in
                exactVc.trendGroup = trendGroup
                tableView.deselectRow(at: indexPath, animated: true)
                self.navigationController?.pushViewController(exactVc, animated: true)
            }
        }

    }

}
