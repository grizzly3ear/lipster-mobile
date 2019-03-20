//
//  LipstickDetailViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 13/3/2562 BE.
//  Copyright © 2562 Mainatvara. All rights reserved.
//

import UIKit

class LipstickDetailViewController: UIViewController {
    
    @IBOutlet weak var lipstickImage: UIImageView!
    @IBOutlet weak var lipstickName: UILabel!
    @IBOutlet weak var lipstickShortDetail: UILabel!
    
    @IBOutlet weak var lipstickReviews: UILabel!
    
    
    //    var imageOfDetail = UIImage()
    //    var nameOfDetail = ""
    var lipstick : Lipstick?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        //        lipstickName.text = "\(nameOfDetail)"
        //        lipstickImage.image = imageOfDetail
        
        if let lipstick = self.lipstick{
            self.lipstickImage.image =  lipstick.lipstickImage
            self.lipstickName.text = lipstick.lipstickName
            self.lipstickShortDetail.text = lipstick.lipShortDetail
            //   self.lipstickReviews.text = lipstick.
        }
        navigationItem.largeTitleDisplayMode = .never
        self.title = "LIPSTICK Detail"
    }
    
    
}
//extension ViewController{
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = storyboard?.instantiateViewController(withIdentifier : "LipstickDetailViewController") as? LipstickDetailViewController
//        vc?.image = UIImage(named : name[indexPath.row])
//        vc?.name = name[indexPath.row]
//        self.navigationController?.pushViewController(vc!, animated: true)
//    }
//
//}
