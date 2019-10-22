import UIKit

class StoreViewController: UIViewController {
    
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var storeHours: UILabel!
    @IBOutlet weak var storeAddress: UILabel!
    @IBOutlet weak var storePhoneNumber: UILabel!
    
    @IBOutlet weak var storeBranch: UILabel!
    var storeDetail: Store?
    
    @IBOutlet weak var titleNavigation: UINavigationItem!
    @IBOutlet weak var blackView: UIView!
    
    @IBOutlet weak var lipstickImage: UIImageView!
    @IBOutlet weak var lipstickBrand: UILabel!
    @IBOutlet weak var lipstickName: UILabel!
    @IBOutlet weak var lipstickColor: UILabel!
    @IBOutlet weak var lipstickPrice: UILabel!
    
    var lipstickStore: Lipstick!
    var lipstick = [Lipstick]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        lipstickBrand.text = lipstickStore?.lipstickBrand
        lipstickName.text = lipstickStore?.lipstickName
        lipstickImage.sd_setImage(with: URL(string: (lipstickStore!.lipstickImage.first ?? "")), placeholderImage: UIImage(named: "nopic")!)
      //  lipstickPrice.text = lipstickStore.price
     //   lipstickColor.text = lipstickStore?.lipstickColorName

        
        storeName.text = storeDetail!.name
        storeImageView.sd_setImage(with: URL(string: (storeDetail?.image)!), placeholderImage: UIImage(named: "nopic")!)
        storeHours.text = storeDetail!.hours
        storeAddress.text = storeDetail!.address
        storePhoneNumber.text = storeDetail?.phoneNumber
        storeBranch.text  = storeDetail?.branch
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.titleNavigation.title = storeDetail?.name
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        hero.dismissViewController()
    }
  
    
}
