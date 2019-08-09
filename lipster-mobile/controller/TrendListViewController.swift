import UIKit
import CHTCollectionViewWaterfallLayout

class TrendListViewController: UIViewController {
    
    @IBOutlet var titleNavigationItem: UINavigationItem!
    @IBOutlet weak var trendListCollectionView: UICollectionView!
    
    var trendCollections = [TrendGroup]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpGesture()
        titleNavigationItem.title = "Trends"
        initCollectionViewProtocol()
        setupCollectionView()
    }
}

extension TrendListViewController: UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trendCollections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendGroupCollectionViewCell", for: indexPath) as! TrendGroupCollectionViewCell
        
        cell.image.sd_setImage(with: URL(string: trendCollections[indexPath.item].image ?? ""), placeholderImage: UIImage(named: "nopic")!)
        cell.image.contentMode = .scaleAspectFill
        cell.image.clipsToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 300, height: Int.random(in: 250...650) )
    }
    
    func initCollectionViewProtocol() {
        self.trendListCollectionView.delegate = self
        self.trendListCollectionView.dataSource = self
    }
    
    func setupCollectionView() {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        trendListCollectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        trendListCollectionView.alwaysBounceVertical = true
        trendListCollectionView.collectionViewLayout = layout
        
    }
}

// MARK: Set up gesture on imagePreview
extension TrendListViewController {
    func setUpGesture() {
        trendListCollectionView.isUserInteractionEnabled = true
        setUpTapGesture()
    }
    
    func setUpTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onTap))
        tapGesture.numberOfTapsRequired = 2
        trendListCollectionView.addGestureRecognizer(tapGesture)
    }
    
    @objc func onTap(_ sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: view!)
        
        let indexPath = trendListCollectionView.indexPathForItem(at: touchPoint)
    }
}
    