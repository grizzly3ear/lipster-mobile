import UIKit
import FlexiblePageControl
import Hero

class TrendDetailViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
  

    @IBOutlet weak var trendLipColorView: UIView!
    @IBOutlet weak var trendSkinColorView: UIView!
    @IBOutlet weak var trendNameLabel: UILabel!
    @IBOutlet weak var trendDescription: UILabel!
    
    @IBOutlet weak var trendImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var lipstickRelatedCollectionView: UICollectionView!
    
    @IBOutlet weak var lipstickRelatedCollectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var lipstickRelated = [Lipstick]()
    var trend: Trend!
    var frame = CGRect(x:0, y:0, width:0 , height:0)
    var imageHeroId = String()
    var lipsticks : [Lipstick]?
    let padding: CGFloat = 15.0

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initHero()
        initGesture()
        lipstickRelatedCollectionView.delegate = self
        lipstickRelatedCollectionView.dataSource = self
        lipsticks =  Lipstick.mockArrayData(size: 5)
        lipstickRelatedCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: padding, bottom: 0.0, right: 0.0)
        
        print("count lipstickRelated=======\(lipsticks!.count)")
        
       
    }
    
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return lipsticks!.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lipstickRelatedTrendCollectionViewCell", for: indexPath) as! LipstickRelatedTrendCollectionViewCell
        cell.contentView.layer.cornerRadius = 10.0
        cell.lipstickRelated_LipstickImage.layer.cornerRadius = 10.0
        cell.contentView.layer.masksToBounds = true
//        cell.layer.cornerRadius = 10
//        cell.clipsToBounds = true
        
        cell.hero.modifiers = [.fade, .scale(0.2)]
        
        let lipstickRelatedTrends = lipsticks![indexPath.item]
        cell.lipstickRalated_lipstickName.text = lipsticks![indexPath.item].lipstickName
        cell.lipstickRelated_lipstickBrand.text = lipsticks![indexPath.item].lipstickBrand
        cell.lipstickRelated_LipstickImage.sd_setImage(with: URL(string: lipsticks![indexPath.item].lipstickImage.first!), placeholderImage: UIImage(named: "nopic"))
     //   cell.lipstickRelated_lipstickColorName.text = lipsticks![indexPath.item].lipstickColorName
     return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          collectionView.deselectItem(at: indexPath, animated: true)
          performSegue(withIdentifier: "showLipstickDetail", sender: indexPath.item)
          
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: 166.0, height: 250.0)
    }
      
    @IBAction func onShowLipstickButtonPress(_ sender: Any?) {
        let colorSelect = trendLipColorView.backgroundColor!

        self.performSegue(withIdentifier: "showLipstickListFromColor", sender: colorSelect)
    }
    
    @IBAction func goBack(_ sender: Any) {
        hero.dismissViewController()
    }
    @IBAction func toggleFavoriteTrend(_ sender: Any?) {
        toggleTrendFav()
        initUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let color = sender as? UIColor
        if let destination = segue.destination as? LipstickListViewController {
            destination.lipHexColor = color?.toHex()
        }
    }
}

extension TrendDetailViewController {
    
    func initUI() {

        self.trendNameLabel.text = trend.title
        setUserInterface(trend ?? Trend())
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        if isTrendFav() {
            let image = UIImage(named: "heart_red")!
            favoriteButton.setImage(image, for: .normal)
        } else {
            let image = UIImage(named: "heart_white")!
            favoriteButton.setImage(image, for: .normal)
        }
        
        view.insetsLayoutMarginsFromSafeArea = false
        
    }
    
    func setUserInterface(_ trend: Trend) {
        self.trendLipColorView.backgroundColor = trend.lipstickColor
        self.trendSkinColorView.backgroundColor = trend.skinColor
        self.trendDescription.text = trend.detail
        self.trendImageView.sd_setImage(with: URL(string:  trend.image), placeholderImage: UIImage(named: "nopic")!)
        self.trendDescription.layoutIfNeeded()
        self.trendDescription.layoutSubviews()
        self.trendDescription.setNeedsLayout()
        self.trendDescription.numberOfLines = 7
    }
}

// MARK: Set up gesture on fav trend collection
extension TrendDetailViewController {
    func initGesture() {
        trendImageView.isUserInteractionEnabled = true
        setUpPanGesture()
    }
    
    func setUpPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.onDrag))
        trendImageView.addGestureRecognizer(panGesture)
    }
    
    @objc func onDrag(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: nil)
        let progress = translation.y / 2 / view.bounds.height
    
        if translation.y > 0 {
            switch sender.state {
            case .began:
                hero.dismissViewController()
            case .changed:
                Hero.shared.update(progress)
                
                Hero.shared.apply(modifiers: [.position(CGPoint(
                    x: trendImageView.center.x,
                    y: translation.y + trendImageView.center.y
                ))], to: trendImageView)
                
                Hero.shared.apply(modifiers: [.position(CGPoint(
                    x: trendLipColorView.center.x,
                    y: translation.y + trendLipColorView.center.y
                ))], to: trendLipColorView)
                
                Hero.shared.apply(modifiers: [.position(CGPoint(
                    x: trendSkinColorView.center.x,
                    y: translation.y + trendSkinColorView.center.y
                ))], to: trendSkinColorView)
                
                Hero.shared.apply(modifiers: [.position(CGPoint(
                    x: trendNameLabel.center.x,
                    y: translation.y + trendNameLabel.center.y
                ))], to: trendNameLabel)
                
                Hero.shared.apply(modifiers: [.position(CGPoint(
                    x: trendDescription.center.x,
                    y: translation.y + trendDescription.center.y
                ))], to: trendDescription)
                
            default:
                if progress + sender.velocity(in: nil).y / view.bounds.height > 0.3 {
                    Hero.shared.finish()
                } else {
                    Hero.shared.cancel()
                }
            }
        }
        
    }

}


extension TrendDetailViewController {
    func initHero() {
        self.hero.isEnabled = true
        self.trendImageView.hero.id = imageHeroId
        self.favoriteButton.hero.modifiers = [
            .whenPresenting(
                .delay(0.2),
                .fade,
                .spring(stiffness: 100, damping: 15)
            )
        ]
        self.trendNameLabel.hero.modifiers = [
            .whenPresenting(
                .delay(0.2),
                .translate(x: 200),
                .fade,
                .spring(stiffness: 100, damping: 15)
            )
        ]
        self.trendDescription.hero.modifiers = [
            .whenPresenting(
                .delay(0.3),
                .translate(x: 200),
                .fade,
                .spring(stiffness: 100, damping: 15)
            )
        ]
        self.navigationController?.hero.navigationAnimationType = .selectBy(
            presenting: .zoom,
            dismissing: .zoomOut
        )
    }
}

extension TrendDetailViewController {
    func toggleTrendFav() {
        if trend != nil {
            var favTrends: [Trend] = Trend.getTrendArrayFromUserDefault(forKey: DefaultConstant.favoriteTrends)
            
            if let i = favTrends.firstIndex(where: { $0 == trend! }) {
                print("remove")
                favTrends.remove(at: i)
                
            } else {
                print("add")
                favTrends.append(trend!)
            }
            Trend.setTrendArrayToUserDefault(forKey: DefaultConstant.favoriteTrends, favTrends)
        }
        
        
    }
    func isTrendFav() -> Bool {
        if trend != nil {
            let favTrends: [Trend] = Trend.getTrendArrayFromUserDefault(forKey: DefaultConstant.favoriteTrends)
            
            if let _ = favTrends.firstIndex(where: { $0 == trend! }) {
                return true
                
            }
        }
        return false
    }
}
