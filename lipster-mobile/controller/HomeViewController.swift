import UIKit
import SwiftyJSON
import ReactiveCocoa
import ReactiveSwift
import Result
import Hero

class HomeViewController: UIViewController , UISearchControllerDelegate , UISearchBarDelegate {
    
    @IBOutlet weak var trendsCollectionView: UICollectionView!
    @IBOutlet weak var recommendCollectionView: UICollectionView!
    
    var searchController : UISearchController!
    
    var trendGroups = [TrendGroup]()
    var recommendLipstick = [Lipstick]()
    
    let lipstickDataPipe = Signal<[Lipstick], NoError>.pipe()
    var lipstickDataObserver: Signal<[Lipstick], NoError>.Observer?
    
    let trendDataPipe = Signal<[TrendGroup], NoError>.pipe()
    var trendDataObserver: Signal<[TrendGroup], NoError>.Observer?
    
    let padding: CGFloat = 8.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initReactiveLipstickData()
        initReactiveTrendData()
        fetchData()

        trendsCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: padding, bottom: 0.0, right: padding)
        recommendCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: padding, bottom: 0.0, right: padding)
        searchBarLip()
        addNavBarImage()
        initHero()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    @IBAction func seemoreButtonPress(_ sender: Any) {
        performSegue(withIdentifier: "showTrendGroup", sender: self)
    }
    
}

extension HomeViewController {
    func fetchData() {
        DispatchQueue.main.async {
            LipstickRepository.fetchAllLipstickData { (response) in
                self.lipstickDataPipe.input.send(value: response)
            }
            TrendRepository.fetchAllTrendData { (response) in
                self.trendDataPipe.input.send(value: response)
            }
        }
    }
}

extension HomeViewController {
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
            case trendsCollectionView:
                return trendGroups.count >= 5 ? 5 : trendGroups.count
            case recommendCollectionView:
                return recommendLipstick.count >= 5 ? 5 : recommendLipstick.count
            default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == trendsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendGroupCollectionViewcell" , for: indexPath) as! TrendHomeCollectionViewCell

            cell.hero.modifiers = [.fade, .scale(0.5)]
            cell.trendHomeImageView.sd_setImage(with: URL(string: trendGroups[indexPath.item].image!), placeholderImage: UIImage(named: "nopic"))
         
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendCollectionViewCell" , for: indexPath) as! RecommendHomeCollectionViewCell
            let lipstick = recommendLipstick[indexPath.item]
            var firstLipstickImage = ""
            if lipstick.lipstickImage.count > 0 {
                firstLipstickImage = lipstick.lipstickImage.first!
            }
            
            cell.hero.modifiers = [.fade, .scale(0.5)]
            cell.recImageView.sd_setImage(with: URL(string: firstLipstickImage), placeholderImage: UIImage(named: "nopic"))
            cell.recBrandLabel.text = lipstick.lipstickBrand
            cell.recNameLabel.text = lipstick.lipstickName
            
            cell.recImageView.hero.id = "lipstick\(indexPath.item)"
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case recommendCollectionView:
            performSegue(withIdentifier: "showLipstickDetail", sender: indexPath.item)
            break
        case trendsCollectionView:
            performSegue(withIdentifier: "showTrendList", sender: indexPath.item)
            break
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueIdentifier = segue.identifier
        if segueIdentifier == "showLipstickDetail" {
            let destination = segue.destination as? NewLipstickDetailViewcontroller
            let selectedIndex = sender as! Int
            if recommendLipstick[selectedIndex].lipstickImage.count == 0 {
                recommendLipstick[selectedIndex].lipstickImage.append("")
            }
            destination?.imageHeroId = "lipstick\(selectedIndex)"
            destination?.lipstick = recommendLipstick[selectedIndex]
        }
        else if segueIdentifier == "showTrendList" {
            if let destination = segue.destination as? PinterestViewController {
                let item = sender as! Int
                destination.trends = trendGroups[item].trends!
            }
        }
        else if segueIdentifier == "showTrendGroup" {
            if let destination = segue.destination as? TrendGroupViewController {
                destination.trendGroups = trendGroups
            }
        }
    }

}

// MARK: Reactive to retrieveData
extension HomeViewController {
    func initReactiveLipstickData() {
        lipstickDataObserver = Signal<[Lipstick], NoError>.Observer(value: { (lipsticks) in
            self.recommendLipstick = lipsticks
            self.recommendCollectionView.reloadData()
            self.recommendCollectionView.setNeedsLayout()
            self.recommendCollectionView.layoutIfNeeded()
            
        })
        lipstickDataPipe.output.observe(lipstickDataObserver!)
    }
    
    func initReactiveTrendData() {
        trendDataObserver = Signal<[TrendGroup], NoError>.Observer(value: { (trendGroups) in
            self.trendGroups = trendGroups
            
            self.trendsCollectionView.reloadData()
            self.trendsCollectionView.setNeedsLayout()
            self.trendsCollectionView.layoutIfNeeded()
        })
        trendDataPipe.output.observe(trendDataObserver!)
    }
}

extension HomeViewController {
    func initHero() {
        self.hero.isEnabled = true
        self.navigationController?.hero.navigationAnimationType = .selectBy(
            presenting: .slide(direction: .left),
            dismissing: .slide(direction: .right)
        )
    }
}
