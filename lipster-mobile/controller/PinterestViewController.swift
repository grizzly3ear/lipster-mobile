import UIKit
import CHTCollectionViewWaterfallLayout
import Hero

class PinterestViewController: UIViewController {
    
    @IBOutlet var titleNavigationItem: UINavigationItem!
    @IBOutlet weak var trendListCollectionView: UICollectionView!
    
    var trends = [Trend]()
    let padding: CGFloat = 15.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trendListCollectionView.contentInset = UIEdgeInsets(top: padding, left: 0.0, bottom: padding, right: 0.0)
        initGesture()
        titleNavigationItem.title = "Trends"
        initCollectionViewProtocol()
        setupCollectionView()
        self.navigationController?.hero.navigationAnimationType = .selectBy(
            presenting: .fade,
            dismissing: .fade
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueIdentifier = segue.identifier
        if segueIdentifier == "showTrendGroupDetail" {
            let destination = segue.destination as! TrendDetailViewController
            let indexPath = sender as! IndexPath
            
            destination.trend = trends[indexPath.item]
            destination.imageHeroId = "trend\(indexPath.item)"
        }
    }
}

extension PinterestViewController: UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("trend count: \(trends.count)")
        return trends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendGroupCollectionViewCell", for: indexPath) as! TrendCollectionViewCell
        
        cell.image.sd_setImage(with: URL(string: trends[indexPath.item].image), placeholderImage: UIImage(named: "nopic")!)
        cell.image.layer.cornerRadius = 8.0
        cell.image.contentMode = .scaleAspectFill
        cell.image.clipsToBounds = true
        cell.image.hero.id = "trend\(indexPath.item)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let rect = CGSize(width: 300, height: Int.random(in: 250...650) )
        
        return rect
    }
    
    func initCollectionViewProtocol() {
        self.trendListCollectionView.delegate = self
        self.trendListCollectionView.dataSource = self
    }
    
    func setupCollectionView() {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 15.0
        layout.minimumInteritemSpacing = 15.0
        trendListCollectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        trendListCollectionView.alwaysBounceVertical = true
        trendListCollectionView.collectionViewLayout = layout
        
    }
}

// MARK: Set up gesture on fav trend collection
extension PinterestViewController {
    func initGesture() {
        trendListCollectionView.isUserInteractionEnabled = true
        setUpTapGesture()
    }
    
    func setUpTapGesture() {
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        trendListCollectionView.addGestureRecognizer(doubleTapGesture)
        
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onSingleTap))
        singleTapGesture.numberOfTapsRequired = 1
        trendListCollectionView.addGestureRecognizer(singleTapGesture)
        
        singleTapGesture.require(toFail: doubleTapGesture)
    }
    
    @objc func onSingleTap(_ sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: trendListCollectionView!)
        let indexPath = trendListCollectionView.indexPathForItem(at: touchPoint)
        
        performSegue(withIdentifier: "showTrendGroupDetail", sender: indexPath)
    }
    
    @objc func onDoubleTap(_ sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: trendListCollectionView!)
        let indexPath = trendListCollectionView.indexPathForItem(at: touchPoint)
        let cell = trendListCollectionView.cellForItem(at: indexPath!) as! TrendCollectionViewCell
        
        cell.likeAnimator.animate {
            self.addFavoriteTrend(self.trends[(indexPath?.item)!])
        }
    }
}

extension PinterestViewController {
    func addFavoriteTrend(_ trend: Trend?) {
        var favTrends: [Trend] = Trend.getTrendArrayFromUserDefault(forKey: DefaultConstant.favoriteTrends)
        
        if (trend != nil) {
            favTrends.append(trend!)
            Trend.setTrendArrayToUserDefault(forKey: DefaultConstant.favoriteTrends, favTrends)
        }        
    }
}
