import UIKit
import CHTCollectionViewWaterfallLayout
import SwiftEntryKit
import Hero

class TrendListViewController: UIViewController {
    
    @IBOutlet var titleNavigationItem: UINavigationItem!
    @IBOutlet weak var trendListCollectionView: UICollectionView!
    
    var trendCollections = [TrendGroup]()
    var likePopupAttributes: EKAttributes!
    var contentPopup: EKNotificationMessageView!
    let padding: CGFloat = 15.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trendListCollectionView.contentInset = UIEdgeInsets(top: padding, left: 0.0, bottom: padding, right: 0.0)
        setUpGesture()
        initLikePopupAttributes()
        titleNavigationItem.title = "Trends"
        initCollectionViewProtocol()
        setupCollectionView()
        self.navigationController?.hero.navigationAnimationType = .selectBy(
            presenting: .fade,
            dismissing: .fade
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueIdentifier = segue.identifier
        if segueIdentifier == "showTrendGroupDetail" {
            let destination = segue.destination as! TrendDetailViewController
            let indexPath = sender as! IndexPath
            
            destination.trendGroup = trendCollections[indexPath.item]
            destination.imageHeroId = "trend\(indexPath.item)"
        }
    }
}

extension TrendListViewController: UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trendCollections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendGroupCollectionViewCell", for: indexPath) as! TrendGroupCollectionViewCell
        
        cell.image.sd_setImage(with: URL(string: trendCollections[indexPath.item].image ?? ""), placeholderImage: UIImage(named: "nopic")!)
        cell.image.layer.cornerRadius = 8.0
        cell.image.contentMode = .scaleAspectFill
        cell.image.clipsToBounds = true
        cell.image.hero.id = "trend\(indexPath.item)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let rect = CGSize(width: 300, height: Int.random(in: 250...650) )
        
        return rect
    }
    
    func initCollectionViewProtocol() {
        self.trendListCollectionView.delegate = self
        self.trendListCollectionView.dataSource = self
    }
    
    func setupCollectionView() {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 15.0
        layout.minimumInteritemSpacing = 15.0
        trendListCollectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        trendListCollectionView.alwaysBounceVertical = true
        trendListCollectionView.collectionViewLayout = layout
        
    }
}

// MARK: Set up gesture on fav trend collection
extension TrendListViewController {
    func setUpGesture() {
        trendListCollectionView.isUserInteractionEnabled = true
        setUpTapGesture()
    }
    
    func setUpTapGesture() {
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        trendListCollectionView.addGestureRecognizer(doubleTapGesture)
        
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onSingleTap))
        singleTapGesture.numberOfTapsRequired = 1
        trendListCollectionView.addGestureRecognizer(singleTapGesture)
        
        singleTapGesture.require(toFail: doubleTapGesture)
    }
    
    @objc func onSingleTap(_ sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: trendListCollectionView!)
        let indexPath = trendListCollectionView.indexPathForItem(at: touchPoint)
        
        performSegue(withIdentifier: "showTrendGroupDetail", sender: indexPath)
    }
    
    @objc func onDoubleTap(_ sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: trendListCollectionView!)
        
        let indexPath = trendListCollectionView.indexPathForItem(at: touchPoint)
        let name = trendCollections[(indexPath?.item)!].name
        let trendsCount = trendCollections[(indexPath?.item)!].trends!.count
        createNotificationMessage(title: "Like \(name ?? "")", description: "\(trendsCount) trends have been add to your favorite", image: nil)
        SwiftEntryKit.display(entry: contentPopup, using: likePopupAttributes)
    }
    
}

extension TrendListViewController {
    func initLikePopupAttributes() {
        likePopupAttributes = EKAttributes.topFloat
        likePopupAttributes.hapticFeedbackType = .success
        likePopupAttributes.entryInteraction = .absorbTouches
        likePopupAttributes.entryBackground = .gradient(
            gradient: .init(
                colors: [.gray, .lightGray],
                startPoint: .zero,
                endPoint: CGPoint(x: 1, y: 1)
            )
        )
        likePopupAttributes.entranceAnimation = .init(
            translate: .init(
                duration: 0.5,
                spring: .init(
                    damping: 0.7,
                    initialVelocity: 0
                )
            )
        )
        
        likePopupAttributes.popBehavior = .animated(
            animation: .init(
                translate: .init(duration: 0.3),
                scale: .init(from: 1, to: 0.7, duration: 0.7)
            )
        )
        likePopupAttributes.scroll = .enabled(
            swipeable: true,
            pullbackAnimation: .easeOut
        )
        likePopupAttributes.displayDuration = .init(1)
        likePopupAttributes.roundCorners = .all(radius: 5.0)
    }
    
    func createNotificationMessage(title: String, description: String, image: UIImage?) {
        let title = EKProperty.LabelContent(
            text: title,
            style: .init(
                font: .systemFont(ofSize: 20),
                color: .black
            )
        )
        let description = EKProperty.LabelContent(
            text: description,
            style: .init(
                font: .systemFont(ofSize: 15),
                color: .black
            )
        )
        let simpleMessage = EKSimpleMessage(title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        
        contentPopup = EKNotificationMessageView(with: notificationMessage)
    }
    
}

