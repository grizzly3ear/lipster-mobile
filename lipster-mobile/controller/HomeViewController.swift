import UIKit
import SwiftyJSON
import ReactiveCocoa
import ReactiveSwift
import Result
import Hero

class HomeViewController: UIViewController {
    
    @IBOutlet weak var trendsCollectionView: UICollectionView!
    @IBOutlet weak var trendGroupCollectionView: UICollectionView!
    @IBOutlet weak var leftButtonBarItem: UIBarButtonItem!
    @IBOutlet private weak var collectionViewLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var blackBackground: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var panGesture: UIPanGestureRecognizer!
    
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
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initReactiveLipstickData()
        initReactiveTrendData()
        fetchData()

        trendGroupCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: padding, bottom: 0.0, right: padding)
        trendsCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: padding, bottom: 0.0, right: padding)
        
        trendsCollectionView.tag = 1
       
        panGesture = scrollView.panGestureRecognizer
        panGesture.addTarget(self, action: #selector(self.onDrag))
        
        initHero()
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
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        if scrollView.tag == 1 {
            targetContentOffset.pointee = scrollView.contentOffset
            let indexOfMajorCell = self.indexOfMajorCell()
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
            case trendGroupCollectionView:
                return trendGroups.count >= 5 ? 5 : trendGroups.count
            case trendsCollectionView:
                return trends.count >= 10 ? 10 :  trends.count
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
        
            cell.hero.modifiers = [.fade, .scale(0.5)]
            cell.trendImage.sd_setImage(with: URL(string: trends[indexPath.item].image), placeholderImage: UIImage(named: "nopic"))
            cell.trendTitle.text = trend.title
            cell.TrendDescription.text = trend.detail
            
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
//            Lipstick.setLipstickArrayToUserDefault(forKey: DefaultConstant.lipstickData, lipsticks)
//
//            self.recommendLipstick = lipsticks
//            self.recommendCollectionView.performBatchUpdates({
//                self.recommendCollectionView.reloadSections(NSIndexSet(index: 0) as IndexSet)
//            }, completion: { (_) in
//
//            })
            
        })
        lipstickDataPipe.output.observe(lipstickDataObserver!)
    }
    
    func initReactiveTrendData() {
        trendDataObserver = Signal<[TrendGroup], NoError>.Observer(value: { (trendGroups) in
            TrendGroup.setTrendGroupArrayToUserDefault(forKey: DefaultConstant.trendData, trendGroups)
            
            self.trendGroups = trendGroups
            
            self.trendGroups.forEach { (trendGroup) in
                if let trend = trendGroup.trends?.randomElement() {
                    self.trends.append(trend)
                }
            }
            
            self.trendsCollectionView.performBatchUpdates({
                self.trendsCollectionView.reloadSections(IndexSet(integer: 0))
            }) { (_) in
                
            }
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
    
    @objc func onDrag(_ sender: UIPanGestureRecognizer) {
        print("drag")
    }
    
    
    func initHero() {
        self.hero.isEnabled = true

        self.navigationController?.hero.navigationAnimationType = .selectBy(
            presenting: .slide(direction: .left),
            dismissing: .slide(direction: .right)
        )
        
        self.blackBackground.hero.modifiers = [
            .whenPresenting(
                .translate(y: -300),
                .spring(stiffness: 270, damping: 25),
                .delay(0.2),
                .fade
            ),
        ]
    }
}
