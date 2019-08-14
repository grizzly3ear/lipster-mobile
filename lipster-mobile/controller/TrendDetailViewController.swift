import UIKit
import FlexiblePageControl
import Hero

class TrendDetailViewController: UIViewController {

    @IBOutlet weak var trendLipColorView: UIView!
    @IBOutlet weak var trendSkinColorView: UIView!
    @IBOutlet weak var trendNameLabel: UILabel!
    @IBOutlet weak var trendDescription: UILabel!
    
    @IBOutlet weak var scrollTrendImage: UIScrollView!
    @IBOutlet weak var pageControl: FlexiblePageControl!
    
    @IBOutlet weak var titleNavigationItem: UINavigationItem!
    
    var trendGroup: TrendGroup!
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
        self.titleNavigationItem.title = trendGroup.name
        self.trendNameLabel.text = trendGroup.name
        setUserInterface(trendGroup.trends!.first ?? Trend())
        initScrollView()
        initPageControl()
    }
    
    func setUserInterface(_ trend: Trend) {
        self.trendLipColorView.backgroundColor = trend.lipstickColor
        self.trendSkinColorView.backgroundColor = trend.skinColor
        self.trendDescription.text = trend.description
    }
}

extension TrendDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.setProgress(contentOffsetX: scrollView.contentOffset.x, pageWidth: scrollView.bounds.width)
        
        setUserInterface(trendGroup.trends![pageControl.currentPage])
    }
    
    func initScrollView() {
        scrollTrendImage.delegate = self
        scrollTrendImage.isPagingEnabled = true
    }
    
}

extension TrendDetailViewController {
    
    func initPageControl() {
        pageControl.numberOfPages = trendGroup.trends!.count
        
        for index in 0..<pageControl.numberOfPages {
            frame.origin.x = scrollTrendImage.frame.size.width * CGFloat(index)
            frame.size = scrollTrendImage.frame.size
            
            let imgView = UIImageView(frame: frame)
            imgView.sd_setImage(with: URL(string: self.trendGroup.trends![index].image), placeholderImage: UIImage(named: "nopic"))
            self.scrollTrendImage.addSubview(imgView)
        }
        scrollTrendImage.contentSize = CGSize(
            width: (scrollTrendImage.frame.size.width * CGFloat(pageControl.numberOfPages)),
            height : scrollTrendImage.frame.size.height
        )
        
        pageControl.pageIndicatorTintColor = UIColor.red
        pageControl.currentPageIndicatorTintColor = UIColor.black
    }

}

extension TrendDetailViewController {
    func initHero() {
        self.hero.isEnabled = true
        self.scrollTrendImage.hero.id = imageHeroId
    }
}
