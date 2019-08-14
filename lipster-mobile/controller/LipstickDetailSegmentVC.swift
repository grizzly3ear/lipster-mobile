import UIKit
import SwiftyJSON
import ReactiveCocoa
import ReactiveSwift
import Result
import Hero

class LipstickDetailSegmentVC: UIViewController {
    
    @IBOutlet weak var lipstickImagesPageControl: UIPageControl!
    @IBOutlet weak var scrollLipstickImages: UIScrollView!

    @IBOutlet weak var tryMeButton: UIButton!
    
    @IBOutlet weak var contentSegmentControl: UISegmentedControl!
    @IBOutlet weak var contentScrollView: UIScrollView!
    
    @IBOutlet weak var lipstickBrand: UILabel!
    @IBOutlet weak var lipstickName: UILabel!
    @IBOutlet weak var lipstickColorName: UILabel!
    @IBOutlet weak var lipstickShortDetail: UILabel!
    @IBOutlet weak var detailViewContainer: UIView!
    
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var typeReviewTextView: UITextView!
    @IBOutlet weak var clickedPostButton: UIButton!
    
    @IBOutlet weak var lipstickSelectColorCollectionView: UICollectionView!
    
    @IBOutlet weak var titleNavigationItem: UINavigationItem!
    
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    let reviewDataPipe = Signal<[UserReview], NoError>.pipe()
    var reviewDataObserver: Signal<[UserReview], NoError>.Observer?
    
    let colorDataPipe = Signal<[Lipstick], NoError>.pipe()
    var colorDataObserver: Signal<[Lipstick], NoError>.Observer?
    
    var reviews: [UserReview] = [UserReview]()
    var lipstick : Lipstick?
    var colors: [Lipstick] = [Lipstick]()
    var imageHeroId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initHero()
        initReactiveData()
        fetchData()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.titleNavigationItem.title = lipstick?.lipstickBrand
        initialUI()
    }

    @IBAction func segments(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0 :
            contentScrollView.setContentOffset(CGPoint( x : 0 , y : 0), animated:true)
        case 1 :
            contentScrollView.setContentOffset(CGPoint( x : 375 , y : 0), animated:true)
        default:
            contentScrollView.setContentOffset(CGPoint( x : 0 , y : 0), animated:true)
        }
    }
    
    @IBAction func clickedTryMe(_ sender: Any) {
        self.performSegue(withIdentifier: "showTryMe", sender: self)
    }
}

// MARK: fetch data
extension LipstickDetailSegmentVC {
    func fetchData() {
        fetchReview()
        fetchLipstickSameDetail()
    }
    func fetchReview() {
        LipstickRepository.fetchReview(lipstickId: self.lipstick!.lipstickId) { (userReviews) in
            self.reviewDataPipe.input.send(value: userReviews)
        }
    }
    func fetchLipstickSameDetail() {
        LipstickRepository.fetchLipstickWithSameDetail(lipstick: self.lipstick!) { (lipsticks) in
            self.colorDataPipe.input.send(value: lipsticks)
        }
    }
}

extension LipstickDetailSegmentVC: UITableViewDelegate , UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
            
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserReviewTableViewCell") as! UserReviewTableViewCell
        cell.userReviewLabel.text = reviews[indexPath.item].userReview
        cell.userNameLabel.text = reviews[indexPath.item].userName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension LipstickDetailSegmentVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Review this lipstick here." {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.trim() == "" {
            clickedPostButton.isEnabled = false
        } else {
            clickedPostButton.isEnabled = true
        }
    }
}

// Post Button Config
extension LipstickDetailSegmentVC {
    @IBAction func clickedPostReviewButton(_ sender: Any) {
        
//        userReviews.append(typeReviewTextView.text!)
//        let indexPath = IndexPath(row: userReviews.count - 1, section: 0)
//
//        reviewTableView.beginUpdates()
//        reviewTableView.insertRows(at: [indexPath], with: .automatic)
//        reviewTableView.endUpdates()
//
//        typeReviewTextView.text = ""
//        clickedPostButton.isEnabled = false
//        view.endEditing(true)
    }
}

// Init UI
extension LipstickDetailSegmentVC : UIScrollViewDelegate {
    func initialUI() {
        if let lipstick = self.lipstick{
            self.lipstickBrand.text = lipstick.lipstickBrand
            self.lipstickName.text = lipstick.lipstickName
            self.lipstickColorName.text = lipstick.lipstickColorName
            self.lipstickShortDetail.text = lipstick.lipstickDetail
        }
        typeReviewTextView.text = "Review this lipstick here."
        typeReviewTextView.textColor = UIColor.lightGray
        typeReviewTextView.delegate = self
        typeReviewTextView.returnKeyType = .done
        clickedPostButton.isEnabled = false
        reviewTableView.backgroundView = UIImageView(image: UIImage(named: "backgroundLiplist"))
        pageController()
    }
    
    func pageController() {
        lipstickImagesPageControl.numberOfPages = self.lipstick?.lipstickImage.count ?? 0
        
        for index in 0..<lipstickImagesPageControl.numberOfPages {
            frame.origin.x = scrollLipstickImages.frame.size.width * CGFloat(index)
            frame.size = scrollLipstickImages.frame.size
    
            let imgView = UIImageView(frame: frame)
            imgView.sd_setImage(with: URL(string: self.lipstick!.lipstickImage[index]), placeholderImage: UIImage(named: "nopic"))
            imgView.contentMode = .scaleAspectFit
            imgView.clipsToBounds = true
            self.scrollLipstickImages.addSubview(imgView)
        }
        if self.lipstick?.lipstickImage.count == 0 {
            let imgView = UIImageView(frame: frame)
            lipstickImagesPageControl.numberOfPages = 1
            
            lipstick?.lipstickImage.append("")
            imgView.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "nopic"))
            self.scrollLipstickImages.addSubview(imgView)
        }
        
        scrollLipstickImages.contentSize = CGSize(
            width: (scrollLipstickImages.frame.size.width *  CGFloat(lipstickImagesPageControl.numberOfPages)),
            height: scrollLipstickImages.frame.size.height)
        scrollLipstickImages.delegate = self
        contentScrollView.delegate = self
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == scrollLipstickImages {
            lipstickImagesPageControl.currentPage = scrollView.currentPage()
        } else if scrollView == contentScrollView {
            contentSegmentControl.selectedSegmentIndex = scrollView.currentPage()
        }
    }
}

// collectionView cell
extension LipstickDetailSegmentVC : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectColorFromDetailCollectionViewCell", for: indexPath) as? SelectColorFromDetailCollectionViewCell
    
        cell?.selectColorView.backgroundColor = colors[indexPath.item].lipstickColor
        if colors[indexPath.item].lipstickId == lipstick?.lipstickId {
            cell?.triangleView.isHidden = false
        } else {
            cell?.triangleView.isHidden = true
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        lipstick = colors[indexPath.item]
        initialUI()
        collectionView.reloadData()
        fetchReview()
    }

}

extension LipstickDetailSegmentVC {
    func initReactiveData() {
        reviewDataObserver = Signal<[UserReview], NoError>.Observer(value: { (userReviews) in
            self.reviews = userReviews
            self.reviewTableView.reloadData()
            self.reviewTableView.setNeedsLayout()
        })
        reviewDataPipe.output.observe(reviewDataObserver!)
        
        colorDataObserver = Signal<[Lipstick], NoError>.Observer(value: { (lipstickColors) in
            self.colors = lipstickColors
            self.lipstickSelectColorCollectionView.reloadData()
            self.lipstickSelectColorCollectionView.setNeedsLayout()
        })
        colorDataPipe.output.observe(colorDataObserver!)
    }
    
}

extension LipstickDetailSegmentVC {
    func initHero() {
        self.hero.isEnabled = true
        self.scrollLipstickImages.hero.id = imageHeroId
    }
}
