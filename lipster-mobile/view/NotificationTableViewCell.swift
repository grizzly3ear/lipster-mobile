//
//  NotificationTableViewCell.swift
//  lipster-mobile
//
//  Created by Mainatvara on 10/5/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var notificationImageView: UIImageView!
    @IBOutlet weak var notificationTitleLabel: UILabel!
    @IBOutlet weak var notificationDateTimeLabel: UILabel!
    @IBOutlet weak var notificationDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        notificationImageView.layer.cornerRadius = 10
        notificationImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)   
    }

}
