//
//  NotificationViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 10/5/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

import UserNotifications

class NotificationViewController: UIViewController {

    @IBOutlet weak var notificationTableView: UITableView!
    @IBOutlet weak var headerLabel: UILabel!

    var notifications = [UserNotification]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let footer = UIView(frame: .zero)
        footer.backgroundColor = .white
        notificationTableView.tableFooterView = footer
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.fetchData),
                                               name: NSNotification.Name(rawValue: NotificationEvent.newNotification),
                                               object: nil)
       
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        fetchData()
    }
    
    @objc func fetchData() {
        UserRepository.getMyNotification { (notifications, _) in
            self.notifications = notifications
            self.notificationTableView.performBatchUpdates({
                self.notificationTableView.reloadSections(IndexSet(integer: 0), with: .none)
                self.initUI()
            }) { (_) in
                
            }
        }
    }
    
    func initUI() {
        if notifications.count == 0 {
            self.notificationTableView.separatorStyle = .none
            self.notificationTableView.tableFooterView = UIView(frame: .zero)
            self.notificationTableView.backgroundColor = .white
            
            let label = UILabel()
            label.frame.size.height = 42
            label.frame.size.width = self.notificationTableView.frame.size.width
            label.center = self.notificationTableView.center
            label.center.y = self.notificationTableView.frame.size.height / 2
            label.numberOfLines = 2
            label.textColor = .darkGray
            label.text = "There are no notification yet."
            label.textAlignment = .center
            label.tag = 1
            
            self.notificationTableView.addSubview(label)
        } else {
            self.notificationTableView.viewWithTag(1)?.removeFromSuperview()
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
        cell.notificationDateTimeLabel.text = notification.createdAt.timeAgoDisplay()
        cell.notificationImageView.sd_setImage(with: URL(string: notifications[indexPath.item].image), placeholderImage: UIImage(named: "lip-logo-2"))

        if notification.isRead {
            cell.backgroundColor = .white
        } else {
            cell.backgroundColor = .init(hexString: "#F2F2F2")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let notification = notifications[indexPath.row]
        
        notification.isRead = true
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.backgroundColor = .white
        }
        
        UserRepository.readNotification(notification: notification, completion: nil)
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

