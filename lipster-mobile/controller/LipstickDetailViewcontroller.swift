//
//  CustomViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 13/9/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit
import SwiftyJSON
import ReactiveCocoa
import ReactiveSwift
import Result
import Hero
import MXSegmentedControl

class LipstickDetailViewcontroller: UIViewController {

    @IBOutlet weak var segmentedControl3: MXSegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var tryMeButton: UIButton!
    @IBOutlet weak var scrollLipstickImages: UIScrollView!
    @IBOutlet weak var lipstickImagesPageControl: UIPageControl!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    
    @IBOutlet weak var lipstickBrand: UILabel!
    @IBOutlet weak var lipstickName: UILabel!
    @IBOutlet weak var lipstickColorName: UILabel!
 
    @IBOutlet weak var reviewButton: UIButton!
    
    @IBOutlet weak var lipstickSelectColorCollectionView: UICollectionView!
  
    let padding: CGFloat = 20.0
    
    var isFav = UserDefaults.standard.bool(forKey: "isFav")
    
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    let reviewDataPipe = Signal<[UserReview], NoError>.pipe()
    var reviewDataObserver: Signal<[UserReview], NoError>.Observer?
    
    let colorDataPipe = Signal<[Lipstick], NoError>.pipe()
    var colorDataObserver: Signal<[Lipstick], NoError>.Observer?
    
    var reviews: [UserReview] = [UserReview]()
    var lipstick: Lipstick?
    var colors: [Lipstick] = [Lipstick]()
    var imageHeroId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tryMeButtonStyle()
        mapButtonStyle()
        numberOfReviewLabel()
        initHero()
        initReactiveData()
        fetchData()
        initialUI()
        lipstickSelectColorCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: padding, bottom: 0.0, right: padding)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        segmentedControl3.append(title: "Description").set(titleColor: UIColor(hexString: "#2B7DBF"), for: .selected)
        
        segmentedControl3.append(title: "Ingredient").set(titleColor: UIColor(hexString: "#CE0755"), for: .selected)
        
        segmentedControl3.addTarget(self, action: #selector(changeIndex(segmentedControl:)), for: .valueChanged)
        addLipstickToHistory()

    }
    
    @IBAction func goBack(_ sender: Any) {
        hero.dismissViewController()
    }
    
    @IBAction func favButtonClicked(_ sender: UIButton) {
        self.toggleFavLipstick()
        initialUI()
    }
    
    @IBAction func clickedTryMe(_ sender: Any) {
        self.performSegue(withIdentifier: "showTryMe", sender: self)
    }
    func tryMeButtonStyle(){
        tryMeButton.backgroundColor = .black
        tryMeButton.layer.cornerRadius = 5.0
    }
    func mapButtonStyle(){
        mapButton.backgroundColor = .black
        mapButton.tintColor = .white 
        mapButton.layer.cornerRadius = 5.0
    }
    func numberOfReviewLabel(){
       
        reviewButton.setTitle("\(reviews.count)  review\(reviews.count > 1 ? "s" : "") ", for: .normal)
        reviewButton.isEnabled = true
    }
    @IBAction func clickedMapButton(_ sender: Any) {
        self.performSegue(withIdentifier: "showMap", sender: self)
    }
    @IBAction func clickedSeeReviews(_ sender: Any) {
        self.performSegue(withIdentifier: "showReview", sender: self)
    }
    
    @objc func changeIndex(segmentedControl: MXSegmentedControl) {
        
        if let segment = segmentedControl.segment(at: segmentedControl.selectedIndex) {
            segmentedControl.indicator.boxView.backgroundColor = segment.titleColor(for: .selected)
            segmentedControl.indicator.lineView.backgroundColor = segment.titleColor(for: .selected)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueIdentifier = segue.identifier
        if segueIdentifier == "showReview" {
            if let destination = segue.destination as? ReviewViewController {
                destination.lipstick = lipstick
                destination.userReviews = reviews
            }
        } else if segueIdentifier == "showContainer" {
            if let destination = segue.destination as? ContainerViewController {
               destination.lipstick = lipstick
            }
        } else if segueIdentifier == "showTryMe" {
            if let destination = segue.destination as? TryMeViewController {
                destination.lipstick = lipstick
                destination.lipsticks = colors
            }
        } else if segueIdentifier == "showMap" {
            if let destination = segue.destination as? NearByViewController {
                destination.lipstick = lipstick
            }
        }
    }
    
}

// MARK: fetch data
extension LipstickDetailViewcontroller {
    func fetchData() {
        fetchLipstickSameDetail()
        fetchLipstickReview()
    }
   
    func fetchLipstickSameDetail() {
        LipstickRepository.fetchLipstickWithSameDetail(lipstick: self.lipstick!) { (lipsticks) in
            self.colorDataPipe.input.send(value: lipsticks)
        }
    }
    
    func fetchLipstickReview() {
        LipstickRepository.fetchReview(lipstickId: self.lipstick!.lipstickId) { (userReviews) in
            self.reviewDataPipe.input.send(value: userReviews)
        }
    }
}

// Init UI
extension LipstickDetailViewcontroller: UIScrollViewDelegate {
    func initialUI() {
        if let lipstick = self.lipstick{
            self.lipstickBrand.text = lipstick.lipstickBrand
            self.lipstickName.text = lipstick.lipstickName
            self.lipstickColorName.text = lipstick.lipstickColorName
          //  self.lipstickShortDetail.text = lipstick.lipstickDetail'
            
            addLipstickToHistory()
        }
        if isLipstickFav() {
            let image = UIImage(named: "heart_red")
            favoriteButton.setImage(image, for: UIControl.State.normal)
        } else {
            let image = UIImage(named: "heart_white")
            favoriteButton.setImage(image, for: UIControl.State.normal)
        }
       
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
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == scrollLipstickImages {
            lipstickImagesPageControl.currentPage = scrollView.currentPage()
        }
    }
}

// collectionView cell
extension LipstickDetailViewcontroller : UICollectionViewDelegate, UICollectionViewDataSource{
    
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
       
    }
    
}

extension LipstickDetailViewcontroller{
    func initReactiveData() {
        reviewDataObserver = Signal<[UserReview], NoError>.Observer(value: { (userReviews) in
            self.reviews = userReviews
            self.numberOfReviewLabel()
        })
        reviewDataPipe.output.observe(reviewDataObserver!)

        colorDataObserver = Signal<[Lipstick], NoError>.Observer(value: { (lipstickColors) in
            self.colors = lipstickColors
            self.lipstickSelectColorCollectionView.reloadData()
            self.lipstickSelectColorCollectionView.setNeedsLayout()
            self.lipstickSelectColorCollectionView.setNeedsDisplay()
        })
        colorDataPipe.output.observe(colorDataObserver!)
    }
    
}

extension LipstickDetailViewcontroller {
    func initHero() {
        self.hero.isEnabled = true
        self.scrollLipstickImages.hero.id = imageHeroId
        
        let arr = [
            self.lipstickBrand,
            self.lipstickColorName,
            self.segmentedControl3,
            self.lipstickName,
            self.tryMeButton,
            self.reviewButton,
            self.scrollView
        ]
        var delay = 0.02
        arr.forEach { (view) in
            view?.hero.modifiers = [
                .whenPresenting(
                    .delay(delay),
                    .translate(y: 200),
                    .fade,
                    .spring(stiffness: 270, damping: 25)
                )
            ]
            delay += 0.03
        }

    }
}

extension LipstickDetailViewcontroller {
    func addLipstickToHistory() {
        if lipstick != nil {
            
            var lipstickHistory: [Lipstick] = Lipstick.getLipstickArrayFromUserDefault(forKey: DefaultConstant.lipsticksHistory)

            if let i = lipstickHistory.firstIndex(where: { $0 == lipstick! }) {
                lipstickHistory.remove(at: i)
            }
            
            lipstickHistory.append(lipstick!)
            lipstick?.lipstickColor.addToUserDefaults(forKey: DefaultConstant.colorHistory)
            
            Lipstick.setLipstickArrayToUserDefault(forKey: DefaultConstant.lipsticksHistory, lipstickHistory)
        }

    }
    func toggleFavLipstick() {
        if lipstick != nil {
            var favLipstick: [Lipstick] = Lipstick.getLipstickArrayFromUserDefault(forKey: DefaultConstant.favoriteLipsticks)
            
            if let i = favLipstick.firstIndex(where: { $0 == lipstick! }) {
                print("remove")
                favLipstick.remove(at: i)
                
            } else {
                print("add")
                favLipstick.append(lipstick!)
            }
            Lipstick.setLipstickArrayToUserDefault(forKey: DefaultConstant.favoriteLipsticks, favLipstick)
        }
        
        
    }
    func isLipstickFav() -> Bool {
        if lipstick != nil {
            let favLipstick: [Lipstick] = Lipstick.getLipstickArrayFromUserDefault(forKey: DefaultConstant.favoriteLipsticks)
            
            if let _ = favLipstick.firstIndex(where: { $0 == lipstick! }) {
                return true
                
            }
        }
        return false
    }
}


