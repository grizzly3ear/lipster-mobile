import UIKit
import SwiftyJSON
import ReactiveCocoa
import ReactiveSwift
import Result

class HomeViewController: UIViewController , UISearchControllerDelegate , UISearchBarDelegate {
    
    
    @IBOutlet weak var trendsCollectionView: UICollectionView!
    @IBOutlet weak var recommendCollectionView: UICollectionView!
    
    var searchController : UISearchController!
    
    var trendGroups = [TrendGroup]()
    var recommendLipstick = [Lipstick]()
    let request = HttpRequest("http://18.136.104.217", nil)
    
    let lipstickDataPipe = Signal<[Lipstick], NoError>.pipe()
    var lipstickDataObserver: Signal<[Lipstick], NoError>.Observer?
    
    let trendDataPipe = Signal<TrendGroup, NoError>.pipe()
    var trendDataObserver: Signal<TrendGroup, NoError>.Observer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureReactiveLipstickData()
        configureReactiveTrendData()
        retrieveData(token: "some test token")
        
        searchBarLip()
        addNavBarImage()
    }
    
    func retrieveData(token: String) {
        let params: [String: Any] = [
            "part": "detail,color"
        ]
        self.request.get("api/brand", params, nil) { (response) -> (Void) in
            self.lipstickDataPipe.input.send(value: Lipstick.makeArrayModelFromJSON(response: response))
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
        switch collectionView {
            case trendsCollectionView: return trendGroups.count
            case recommendCollectionView: return recommendLipstick.count
            default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == trendsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendGroupCollectionViewcell" , for: indexPath) as! TrendHomeCollectionViewCell

            cell.trendHomeImageView.sd_setImage(with: URL(string: trendGroups.first!.trends![indexPath.row].trendImage), placeholderImage: UIImage(named: "nopic"))
         
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendCollectionViewCell" , for: indexPath) as! RecommendHomeCollectionViewCell
            let lipstick = recommendLipstick[indexPath.item]
            var firstLipstickImage = ""
            if lipstick.lipstickImage.count > 0 {
                firstLipstickImage = lipstick.lipstickImage.first!
            }
            
            cell.recImageView.sd_setImage(with: URL(string: firstLipstickImage), placeholderImage: UIImage(named: "nopic"))
            cell.recBrandLabel.text = lipstick.lipstickBrand
            cell.recNameLabel.text = lipstick.lipstickName
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == recommendCollectionView {
            performSegue(withIdentifier: "showLipstickDetail", sender: indexPath.item)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueIdentifier = segue.identifier
        if segueIdentifier == "showLipstickDetail" {
            let destination = segue.destination as? LipstickDetailSegmentVC
            let selectedIndex = sender as! Int
            destination?.lipstick = recommendLipstick[selectedIndex]
        }
        else if segueIdentifier == "showTrendGroupList" {
            if let destination = segue.destination as? TrendListViewController {
                destination.trendGroupList = trendGroups
            }
        }
    }

}

// MARK: Reactive to retrieveData
extension HomeViewController {
    func configureReactiveLipstickData() {
        lipstickDataObserver = Signal<[Lipstick], NoError>.Observer(value: { (lipsticks) in
            self.recommendLipstick = lipsticks
            
            self.recommendCollectionView.reloadData()
            self.recommendCollectionView.setNeedsLayout()
            self.recommendCollectionView.layoutIfNeeded()
            
        })
        lipstickDataPipe.output.observe(lipstickDataObserver!)
    }
    
    func configureReactiveTrendData() {
        trendDataObserver = Signal<TrendGroup, NoError>.Observer(value: { (trendGroup) in
            self.trendGroups.append(trendGroup)
            self.trendsCollectionView.reloadData()
            self.trendsCollectionView.setNeedsLayout()
            self.trendsCollectionView.layoutIfNeeded()
        })
        trendDataPipe.output.observe(trendDataObserver!)
    }
}
