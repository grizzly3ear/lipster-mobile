import UIKit
import SwiftyJSON
import ReactiveCocoa
import ReactiveSwift
import Result

class HomeViewController: UIViewController , UISearchControllerDelegate , UISearchBarDelegate {
    
    
    @IBOutlet weak var trendsCollectionView: UICollectionView!
    @IBOutlet weak var recommendCollectionView: UICollectionView!
    @IBOutlet weak var recentCollectionView: UICollectionView!
    
    var searchController : UISearchController!
    
    var trendGroup = TrendGroup()
    var recommendLipstick = [Lipstick]()
    var recentViewLipstick = [Lipstick]()
    let request = HttpRequest("http://18.136.104.217", nil)
    let lipstickDataPipe = Signal<[Lipstick], NoError>.pipe()
    var lipstickDataObserver: Signal<[Lipstick], NoError>.Observer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        defaults.set(recentViewLipstick, forKey: "recentLipstickView")
        if (false) { // if have internet connection
//            let token: String = (defaults.string(forKey: "userToken")?)!
//            retrieveData(token: token)
        } else {
//            use old data
        }
        configureReactiveLipstickData()
        retrieveData(token: "some test token")
        
        searchBarLip()
        addNavBarImage()
        print(defaults.object(forKey: "recentLipstickView"))
        print("view Did Load")
    }
    
    func retrieveData(token: String) {
        
        self.request.get("api/lipstick", nil, nil) { (response) -> (Void) in
            self.lipstickDataPipe.input.send(value: Lipstick.makeArrayModelFromJSON(response: response))
        }
        
        
        
        let images = [UIImage(named: "BE115")! ,UIImage(named: "BE115")!,UIImage(named: "BE116")!,UIImage(named: "BE116")!]

        trendGroup.trendName = "Trend of the month | January 2019"
        trendGroup.trends = [Trend]()
        let trend1 = Trend(trendImage: UIImage(named: "user1")!, trendLipstickColor: UIColor(rgb: 0xF4D3C0), trendSkinColor: UIColor(rgb: 0xF4D3C6) )
        let trend2 = Trend(trendImage: UIImage(named: "user1")!, trendLipstickColor: UIColor(rgb: 0xF4D3C0), trendSkinColor: UIColor(rgb: 0xF4D3C6) )
        let trend3 = Trend(trendImage: UIImage(named: "user1")!, trendLipstickColor: UIColor(rgb: 0xF4D3C0), trendSkinColor: UIColor(rgb: 0xF4D3C6) )
        let trend4 = Trend(trendImage: UIImage(named: "user1")!, trendLipstickColor: UIColor(rgb: 0xF4D3C0), trendSkinColor: UIColor(rgb: 0xF4D3C6) )
        trendGroup.trends?.append(trend1)
        trendGroup.trends?.append(trend2)
        trendGroup.trends?.append(trend3)
        trendGroup.trends?.append(trend4)

        for i in 1...5 {
            var lipstick = Lipstick()
            lipstick.lipstickColor = UIColor(rgb: 0xF4D3C6)
            lipstick.lipstickBrand = "brand"
            lipstick.lipstickName = "lipstick_name"
            lipstick.lipstickColorName = "color_name"
            lipstick.lipstickDetail = "detail"
            lipstick.lipstickImage = [""]
            recommendLipstick.append(lipstick)
            recentViewLipstick.append(lipstick)
        }
        
        print("finish init data")
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueIdentifier = segue.identifier
        if segueIdentifier == "showRecommendList" {
            if let destination = segue.destination as? LipstickListViewController {
                destination.lipstickList = recommendLipstick
            }
            
        } else if segueIdentifier == "showRecentList" {
            if let destination = segue.destination as? LipstickListViewController {
                destination.lipstickList = recommendLipstick
            }
            
        } else if segueIdentifier == "showTrendGroupList" {
            if segue.destination is TrendListViewController {

            }
        }
    }
}

extension HomeViewController{
    func searchBarLip() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        
        if #available(iOS 11.0, *) {
            let search = UISearchController(searchResultsController: nil)
            search.delegate = self
            let searchBackground = search.searchBar
            searchBackground.placeholder = "Brand, Color, ..."
            
            if let textfield = searchBackground.value(forKey: "searchField") as? UITextField {
                textfield.textColor = UIColor.black
                if let backgroundview = textfield.subviews.first {
                    
                    backgroundview.backgroundColor = UIColor.white
                    
                    backgroundview.layer.cornerRadius = 10;
                    backgroundview.clipsToBounds = true;
                }
            }
            
            if let navigationbar = self.navigationController?.navigationBar {
                navigationbar.barTintColor = UIColor.black
            }
            navigationItem.searchController = search
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
}

extension HomeViewController {
    func addNavBarImage(){
        let navController = navigationController!
        let image = UIImage(named: "logo-3")
        let imageView = UIImageView(image : image)
        
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        
        let bannerX = (bannerWidth / 2 ) - (image!.size.width / 2 )
        let bannerY = (bannerHeight / 2 ) - (image!.size.height / 2 )
        
        imageView.frame = CGRect( x : bannerX, y: bannerY , width: bannerWidth , height : bannerHeight)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView  = imageView
    }
}
extension HomeViewController: UICollectionViewDataSource , UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == trendsCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendGroupCollectionViewcell" , for: indexPath) as! TrendHomeCollectionViewCell

            cell.trendHomeImageView.image = trendGroup.trends![indexPath.row].trendImage
         
            return cell
        }
        else if (collectionView == recentCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recentlyCollectionViewCell" , for: indexPath) as! RecentlyViewHomeCollectionViewCell
            
//            cell.recentImageView.image = recentViewLipstick[indexPath.item].lipstickImage.first
            cell.recentImageView.sd_setImage(with: URL(string: recentViewLipstick[indexPath.item].lipstickImage.first!), placeholderImage: UIImage(named: "nopic"))
            cell.recentBrandLabel.text = recentViewLipstick[indexPath.item].lipstickBrand
            cell.recentNameLabel.text = recentViewLipstick[indexPath.item].lipstickName
            
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendCollectionViewCell" , for: indexPath) as! RecommendHomeCollectionViewCell
            
            print(recommendLipstick[indexPath.item].lipstickName)
//            cell.recImageView.image = recommendLipstick[indexPath.item].lipstickImage.first
            cell.recImageView.sd_setImage(with: URL(string: recommendLipstick[indexPath.item].lipstickImage.first!), placeholderImage: UIImage(named: "nopic"))
            cell.recBrandLabel.text = recommendLipstick[indexPath.item].lipstickBrand
            cell.recNameLabel.text = recommendLipstick[indexPath.item].lipstickName
            
            return cell
        }
    }

}

// MARK: Reactive to retrieveData
extension HomeViewController {
    func configureReactiveLipstickData() {
        lipstickDataObserver = Signal<[Lipstick], NoError>.Observer(value: { (lipsticks) in
            self.recommendLipstick = lipsticks
            self.recentViewLipstick = lipsticks
            print("finish init")
            self.recommendCollectionView.reloadData()
            self.recommendCollectionView.setNeedsLayout()
            self.recommendCollectionView.layoutIfNeeded()
            
            self.recentCollectionView.reloadData()
            self.recentCollectionView.setNeedsLayout()
            self.recentCollectionView.layoutIfNeeded()
            
        })
        lipstickDataPipe.output.observe(lipstickDataObserver!)
    }
}
