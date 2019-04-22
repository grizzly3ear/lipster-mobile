import UIKit
import FlexiblePageControl

class TrendDetailViewController: UIViewController {

    @IBOutlet weak var trendBigImageView: UIImageView!
    @IBOutlet weak var trendLipColorView: UIView!
    @IBOutlet weak var trendSkinColorView: UIView!
    @IBOutlet weak var trendNameLabel: UILabel!
    
    @IBOutlet weak var scrollTrendImage: UIScrollView!
    @IBOutlet weak var pageControl: FlexiblePageControl!
    
    var trendGroup: TrendGroup!
    var frame = CGRect(x:0,y:0,width:0 , height:0)
    let scrollSize: CGFloat = 270
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initScrollView()
        initPageControl()
    }
}

//scrollView of lipImg method
extension TrendDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.setProgress(contentOffsetX: scrollView.contentOffset.x, pageWidth: scrollView.bounds.width)
    }
    
    func initScrollView() {
        scrollTrendImage.delegate = self
        scrollTrendImage.isPagingEnabled = true
    }
    
}

// page control
extension TrendDetailViewController {
    
    func initPageControl() {
        pageControl.numberOfPages = trendGroup.trendList!.count
        
        for index in 0..<pageControl.numberOfPages {
            frame.origin.x = scrollTrendImage.frame.size.width * CGFloat(index)
            frame.size = scrollTrendImage.frame.size
            
            let imgView = UIImageView(frame: frame)
            imgView.image = self.trendGroup.trendList![index].trendImage
            self.scrollTrendImage.addSubview(imgView)
        }
        scrollTrendImage.contentSize = CGSize(width :(scrollTrendImage.frame.size.width * CGFloat(pageControl.numberOfPages)) , height : scrollTrendImage.frame.size.height)

    }

}
