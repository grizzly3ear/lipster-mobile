import UIKit
import FlexiblePageControl

class TrendDetailViewController: UIViewController {

    @IBOutlet weak var trendLipColorView: UIView!
    @IBOutlet weak var trendSkinColorView: UIView!
    @IBOutlet weak var trendNameLabel: UILabel!
    
    @IBOutlet weak var scrollTrendImage: UIScrollView!
    @IBOutlet weak var pageControl: FlexiblePageControl!
    
    @IBOutlet weak var titleNavigationItem: UINavigationItem!
    var trendGroup: TrendGroup!
    var frame = CGRect(x:0,y:0,width:0 , height:0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initScrollView()
        initPageControl()
        initUserInterface()
        self.titleNavigationItem.title = trendGroup.trendName
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
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
        self.trendNameLabel.text = trendGroup.trendName
        setUserInterface(trendGroup.trends!.first!)
    }
    
    func setUserInterface(_ trend: Trend) {
        self.trendLipColorView.backgroundColor = trend.trendLipstickColor
        self.trendSkinColorView.backgroundColor = trend.trendSkinColor
    }
}

//scrollView of lipImg method
extension TrendDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.setProgress(contentOffsetX: scrollView.contentOffset.x, pageWidth: scrollView.bounds.width)
        
        setUserInterface(trendGroup.trends![pageControl.currentPage])
        print("scroll end \(scrollView.contentOffset.x)")
    }
    
    func initScrollView() {
        scrollTrendImage.delegate = self
        scrollTrendImage.isPagingEnabled = true
    }
    
}

// page control
extension TrendDetailViewController {
    
    func initPageControl() {
        pageControl.numberOfPages = trendGroup.trends!.count
        
        for index in 0..<pageControl.numberOfPages {
            frame.origin.x = scrollTrendImage.frame.size.width * CGFloat(index)
            frame.size = scrollTrendImage.frame.size
            
            let imgView = UIImageView(frame: frame)
            imgView.image = self.trendGroup.trends![index].trendImage
            self.scrollTrendImage.addSubview(imgView)
        }
        scrollTrendImage.contentSize = CGSize(width :(scrollTrendImage.frame.size.width * CGFloat(pageControl.numberOfPages)) , height : scrollTrendImage.frame.size.height)
        
        pageControl.pageIndicatorTintColor = UIColor.red
        pageControl.currentPageIndicatorTintColor = UIColor.black
    }

}
