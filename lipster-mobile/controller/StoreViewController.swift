import UIKit

class StoreViewController: UIViewController {
    
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var storeHours: UILabel!
    @IBOutlet weak var storeDayOpen: UILabel!
    @IBOutlet weak var storeAddress: UILabel!
    @IBOutlet weak var storePhoneNumber: UILabel!
    @IBOutlet weak var titleNavigation: UINavigationItem!
    @IBOutlet weak var blackView: UIView!
    
    var storeDetail: Store?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        storeName.text = storeDetail!.name
        storeImageView.sd_setImage(with: URL(string: (storeDetail?.image)!), placeholderImage: UIImage(named: "nopic")!)
        storeHours.text = storeDetail!.hours
        storeAddress.text = storeDetail!.address
        storePhoneNumber.text = storeDetail?.phoneNumber
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.titleNavigation.title = storeDetail?.name
    }
    
    
    
    
}