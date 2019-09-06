import UIKit
import FlexiblePageControl
import Hero

class TrendDetailViewController: UIViewController {

    @IBOutlet weak var trendLipColorView: UIView!
    @IBOutlet weak var trendSkinColorView: UIView!
    @IBOutlet weak var trendNameLabel: UILabel!
    @IBOutlet weak var trendDescription: UILabel!
    
    
    @IBOutlet weak var trendImageView: UIImageView!
    
    @IBOutlet weak var titleNavigationItem: UINavigationItem!
    
    var trend: Trend!
    var frame = CGRect(x:0, y:0, width:0 , height:0)
    var imageHeroId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUserInterface()
        initHero()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    @IBAction func onShowLipstickButtonPress(_ sender: Any?) {
        let colorSelect = trendLipColorView.backgroundColor!
        performSegue(withIdentifier: "showLipstickListFromColor", sender: colorSelect)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let color = sender as? UIColor
        if let destination = segue.destination as? LipstickListViewController {
            destination.lipColor = color
        }
    }
}

extension TrendDetailViewController {
    
    func initUserInterface() {
        self.titleNavigationItem.title = trend.title
        self.trendNameLabel.text = trend.title
        setUserInterface(trend ?? Trend())
    }
    
    func setUserInterface(_ trend: Trend) {
        self.trendLipColorView.backgroundColor = trend.lipstickColor
        self.trendSkinColorView.backgroundColor = trend.skinColor
        self.trendDescription.text = trend.description
        self.trendImageView.sd_setImage(with: URL(string:  trend.image), placeholderImage: UIImage(named: "nopic")!)
    }
}


extension TrendDetailViewController {
    func initHero() {
        self.hero.isEnabled = true
        self.trendImageView.hero.id = imageHeroId
    }
}
