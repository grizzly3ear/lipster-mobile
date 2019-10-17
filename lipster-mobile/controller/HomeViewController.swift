import UIKit
import SwiftyJSON
import ReactiveCocoa
import ReactiveSwift
import Result
import Hero

class HomeViewController: UIViewController {
    
    @IBOutlet weak var trendsCollectionView: UICollectionView!
    @IBOutlet weak var trendGroupCollectionView: UICollectionView!
    @IBOutlet weak var recommendCollectionView: UICollectionView!
    @IBOutlet weak var leftButtonBarItem: UIBarButtonItem!
    @IBOutlet private weak var collectionViewLayout: UICollectionViewFlowLayout!
    
    var trendGroups = [TrendGroup]()
    var recommendLipstick = [Lipstick]()
    var trends = [Trend]()
    
    let lipstickDataPipe = Signal<[Lipstick], NoError>.pipe()
    var lipstickDataObserver: Signal<[Lipstick], NoError>.Observer?
    
    let trendDataPipe = Signal<[TrendGroup], NoError>.pipe()
    var trendDataObserver: Signal<[TrendGroup], NoError>.Observer?
    
    let storeDataPipe = Signal<[Store], NoError>.pipe()
    var storeDataObserver: Signal<[Store], NoError>.Observer?
    
    let padding: CGFloat = 25.0
    
    var logoImageView: UIImageView!
    
    
    func createTrendArray() -> [Trend] {
        let trend1: Trend = Trend("Hot Orenge ", "user1",  UIColor.red,  UIColor.black, "adojoffekwjehnjdnfaejfnjrfnlfflerjfadojoffekwjehnjdnfaejfnjrfnlfflerjf")
        let trend2: Trend = Trend("Hot Orenge ", "user1",  UIColor.red,  UIColor.black, "adojoffekwjehnjdnfaejfnjrfnlfflerjfadojoffekwjehnjdnfaejfnjrfnlfflerjf")
        let trend3: Trend = Trend("Hot Orenge ","user1",  UIColor.red,  UIColor.black, "adojoffekwjehnjdnfaejfnjrfnlfflerjf")
        let trend4: Trend = Trend("Hot Orenge ", "user1",  UIColor.red,  UIColor.black, "adojoffekwjehnjdnfaejfnjrfnlfflerjf")
        
        
        return [trend1,trend2,trend3,trend4]
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.trends = self.createTrendArray()
        initReactiveLipstickData()
        initReactiveTrendData()
        fetchData()

        trendGroupCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: padding, bottom: 0.0, right: padding)
        recommendCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: padding, bottom: 0.0, right: padding)
        trendsCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: padding, bottom: 0.0, right: padding)
       
        
        initHero()
        
        addLeftBarIcon(named:"logo_font")
        
    }

    func addLeftBarIcon(named:String) {
        
        let logoImage = UIImage.init(named: "logo_font")
        let logoImageView = UIImageView.init(image: logoImage)
        logoImageView.frame = CGRect(x: 0.0, y: 0.0, width: 130, height: 50)
        logoImageView.contentMode = .scaleAspectFit
        let imageItem = UIBarButtonItem.init(customView: logoImageView)
        let widthConstraint = logoImageView.widthAnchor.constraint(equalToConstant: 130)
        let heightConstraint = logoImageView.heightAnchor.constraint(equalToConstant: 50)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        navigationItem.leftBarButtonItem =  imageItem
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
//            StoreRepository.fetchAllStore { (response) in
//                self.storeDataPipe.input.send(value: response)
//            }
        }
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    private func indexOfMajorCell() -> Int {
        let itemWidth = collectionViewLayout.itemSize.width
        let proportionalOffset = collectionViewLayout.collectionView!.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(trends.count - 1, index))
        return safeIndex
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>){
        targetContentOffset.pointee = scrollView.contentOffset
        let indexOfMajorCell = self.indexOfMajorCell()
        let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
        collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
            case trendGroupCollectionView:
                return trendGroups.count >= 5 ? 5 : trendGroups.count
            case recommendCollectionView:
                return recommendLipstick.count >= 20 ? 20 : recommendLipstick.count
            case trendsCollectionView:
                return trends.count >= 10 ? 10 :  trends.count
            print("count trend = \(trends.count)")
            default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == trendGroupCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendGroupCollectionViewcell" , for: indexPath) as! TrendHomeCollectionViewCell

            cell.hero.modifiers = [.fade, .scale(0.5)]
            cell.trendHomeImageView.sd_setImage(with: URL(string: trendGroups[indexPath.item].image!), placeholderImage: UIImage(named: "nopic"))
            
            return cell
        } else if  collectionView == trendsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendsCollectionViewCell" , for: indexPath) as! TrendsCollectionViewCell
            let trend = trends[indexPath.item]
        
            
//            cell.trendImage.layer.masksToBounds = true
//            cell.trendImage.layer.cornerRadius = 0
            
            cell.hero.modifiers = [.fade, .scale(0.5)]
            cell.trendImage.sd_setImage(with: URL(string: trends[indexPath.item].image), placeholderImage: UIImage(named: "nopic"))
            cell.trendTitle.text = trend.title
            cell.TrendDescription.text = trend.detail
            
            return cell
        }else {
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
            print("count trend = \(trends.count)")
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case recommendCollectionView:
            performSegue(withIdentifier: "showLipstickDetail", sender: indexPath.item)
            break
        case trendGroupCollectionView:
            performSegue(withIdentifier: "showTrendList", sender: indexPath.item)
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
            let destination = segue.destination as? LipstickDetailViewcontroller
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
            Lipstick.setLipstickArrayToUserDefault(forKey: DefaultConstant.lipstickData, lipsticks)
            
            self.recommendLipstick = lipsticks
            self.recommendCollectionView.performBatchUpdates({
                self.recommendCollectionView.reloadSections(NSIndexSet(index: 0) as IndexSet)
            }, completion: { (_) in
                
            })
            
        })
        lipstickDataPipe.output.observe(lipstickDataObserver!)
    }
    
    func initReactiveTrendData() {
        trendDataObserver = Signal<[TrendGroup], NoError>.Observer(value: { (trendGroups) in
            TrendGroup.setTrendGroupArrayToUserDefault(forKey: DefaultConstant.trendData, trendGroups)
            
            self.trendGroups = trendGroups
            
            self.trendGroupCollectionView.performBatchUpdates({
                self.trendGroupCollectionView.reloadSections(NSIndexSet(index: 0) as IndexSet)
            }, completion: { (_) in
                
            })
        })
        trendDataPipe.output.observe(trendDataObserver!)
    }
    
    func initReactiveStoreData() {
        storeDataObserver = Signal<[Store], NoError>.Observer(value: { (stores) in
            
        })
        storeDataPipe.output.observe(storeDataObserver!)
    }
}

extension HomeViewController {
    func initHero() {
        self.hero.isEnabled = true
      //  searchButton.customView?.hero.id = "searchbar"
        self.navigationController?.hero.navigationAnimationType = .selectBy(
            presenting: .slide(direction: .left),
            dismissing: .slide(direction: .right)
        )
        
    }
}
