import UIKit
import FlexiblePageControl
import Hero
import ReactiveCocoa
import ReactiveSwift
import Result

class TrendDetailViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
  
    @IBOutlet weak var trendLipColorView: UIView!
    @IBOutlet weak var trendSkinColorView: UIView!
    @IBOutlet weak var trendNameLabel: UILabel!
    @IBOutlet weak var trendDescription: UILabel!
    @IBOutlet weak var trendDateUpdated: UILabel!
    
    @IBOutlet weak var trendImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var lipstickRelatedCollectionView: UICollectionView!
    
    @IBOutlet weak var lipstickRelatedCollectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var lipstickRelated = [Lipstick]()
    var trend: Trend!
    var frame = CGRect(x:0, y:0, width:0 , height:0)
    var imageHeroId = String()
    var lipsticks: [Lipstick] = [Lipstick]()
    let padding: CGFloat = 15.0
    
    let lipstickDataPipe = Signal<[Lipstick], NoError>.pipe()
    var lipstickDataObserver: Signal<[Lipstick], NoError>.Observer?

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initHero()
        initGesture()
        lipstickRelatedCollectionView.delegate = self
        lipstickRelatedCollectionView.dataSource = self
        lipstickRelatedCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: padding, bottom: 0.0, right: 0.0)
        initReactive()
        fetchData()
    }
    
    func fetchData() {
        LipstickRepository.fetchSimilarLipstickHexColor(
            (trendLipColorView.backgroundColor?.toHex)!
        ) { (lipsticks) in
            self.lipstickDataPipe.input.send(value: lipsticks)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lipsticks.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lipstickRelatedTrendCollectionViewCell", for: indexPath) as! LipstickRelatedTrendCollectionViewCell
        cell.contentView.layer.cornerRadius = 10.0
        cell.lipstickRelated_LipstickImage.layer.cornerRadius = 10.0
        cell.contentView.layer.masksToBounds = true

        cell.hero.modifiers = [.fade, .scale(0.2)]
        
        let lipstick = lipsticks[indexPath.item]
        cell.lipstickRalated_lipstickName.text = lipstick.lipstickName
        cell.lipstickRelated_lipstickBrand.text = lipstick.lipstickBrand
        cell.lipstickRelated_LipstickImage.sd_setImage(with: URL(string: lipstick.lipstickImage.first ?? ""), placeholderImage: UIImage(named: "nopic"))

     return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          collectionView.deselectItem(at: indexPath, animated: true)
          performSegue(withIdentifier: "showLipstickDetail", sender: indexPath.item)
          
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: 166.0, height: 250.0)
    }
    
    @IBAction func goBack(_ sender: Any) {
        hero.dismissViewController()
    }
    @IBAction func toggleFavoriteTrend(_ sender: Any?) {
        Trend.toggleTrendFav(trend)
        initUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueIdentifier = segue.identifier
        let color = sender as? UIColor
        if let destination = segue.destination as? LipstickListViewController {
            destination.lipHexColor = color?.toHex()
        } else if segueIdentifier == "showLipstickDetail" {
            if let destination = segue.destination as? LipstickDetailViewcontroller{
                let item = sender as! Int
                destination.lipstick = lipsticks[item]
            }
        }
    }
}

extension TrendDetailViewController {
    
    func initUI() {

        self.trendNameLabel.text = trend.title
        setUserInterface(trend ?? Trend())
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        if Trend.isTrendFav(trend) {
            let image = UIImage(named: "heart_red")!
            favoriteButton.setImage(image, for: .normal)
        } else {
            let image = UIImage(named: "heart_white")!
            favoriteButton.setImage(image, for: .normal)
        }
        
        trendDateUpdated.text = trend.createdAt.timeAgoDisplay()
        
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
    func initReactive() {
        self.lipstickDataObserver = Signal<[Lipstick], NoError>.Observer(value: { (lipsticks) in
            self.lipsticks = lipsticks
            
            self.lipstickRelatedCollectionView.performBatchUpdates({
                self.lipstickRelatedCollectionView.reloadSections(IndexSet(integer: 0))
            }) { (_) in
                
            }
        })
        
        self.lipstickDataPipe.output.observe(lipstickDataObserver!)
        
    }
}


