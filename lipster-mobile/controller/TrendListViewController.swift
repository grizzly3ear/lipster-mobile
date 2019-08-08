import UIKit
import CHTCollectionViewWaterfallLayout

class TrendListViewController: UIViewController {
    
    @IBOutlet var titleNavigationItem: UINavigationItem!
    @IBOutlet weak var trendListCollectionView: UICollectionView!
    
    var trendCollections = [TrendGroup]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleNavigationItem.title = "Trends"
        initCollectionViewProtocol()
        setupCollectionView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            print("reload")
            self.trendListCollectionView.reloadData()
            self.trendListCollectionView.layoutIfNeeded()
            self.trendListCollectionView.setNeedsLayout()
        }
    }
}

extension TrendListViewController: UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trendCollections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendGroupCollectionViewCell", for: indexPath) as! TrendGroupCollectionViewCell
        
        DispatchQueue.main.async {
            cell.image.sd_setImage(with: URL(string: self.trendCollections[indexPath.item].image!), placeholderImage: UIImage(named: "nopic")!)
            collectionView.layoutIfNeeded()
            collectionView.setNeedsLayout()
            collectionView.setNeedsDisplay()
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendGroupCollectionViewCell", for: indexPath) as! TrendGroupCollectionViewCell

        return (cell.image.image ?? UIImage(named: "nopic")!).size
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
