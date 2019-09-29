import UIKit
import FlexiblePageControl
import Hero

class TrendDetailViewController: UIViewController {

    @IBOutlet weak var trendLipColorView: UIView!
    @IBOutlet weak var trendSkinColorView: UIView!
    @IBOutlet weak var trendNameLabel: UILabel!
    @IBOutlet weak var trendDescription: UILabel!
    
    @IBOutlet weak var trendImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var titleNavigationItem: UINavigationItem!
    
    var trend: Trend!
    var frame = CGRect(x:0, y:0, width:0 , height:0)
    var imageHeroId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initHero()
        initGesture()
    }
    
    @IBAction func onShowLipstickButtonPress(_ sender: Any?) {
        let colorSelect = trendLipColorView.backgroundColor!

        self.performSegue(withIdentifier: "showLipstickListFromColor", sender: colorSelect)
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
        self.titleNavigationItem.title = trend.title
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
    }
    
    func setUserInterface(_ trend: Trend) {
        self.trendLipColorView.backgroundColor = trend.lipstickColor
        self.trendSkinColorView.backgroundColor = trend.skinColor
        self.trendDescription.text = trend.detail
        self.trendImageView.sd_setImage(with: URL(string:  trend.image), placeholderImage: UIImage(named: "nopic")!)
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
            
            if let i = favTrends.firstIndex(where: { $0 == trend! }) {
                return true
                
            }
        }
        return false
    }
}
