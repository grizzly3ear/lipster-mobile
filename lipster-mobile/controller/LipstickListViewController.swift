//
//  ViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 13/3/2562 BE.
//  Copyright © 2562 Mainatvara. All rights reserved.
//
// Not use this file
import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result
import Hero

class LipstickListViewController: UITableViewController  {

    @IBOutlet var lipListTableView: UITableView!
    
    var lipHexColor: String?
    var searchController : UISearchController!
    var resultController = UITableViewController()
    var lipstickList = [Lipstick]()
    
    let lipstickListPipe = Signal<[Lipstick], NoError>.pipe()
    var lipstickListObserver: Signal<[Lipstick], NoError>.Observer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initReactiveLipstickList()
        lipListTableView.delegate = self
        lipListTableView.dataSource = self
        navigationController?.isNavigationBarHidden = false
        initHero()
        if self.lipHexColor != nil {
            fetchData()
        }
        reloadData()
        
    }
    
    func reloadData() {
        if lipstickList.count == 0 {
            
            let label = UILabel()
            label.frame.size.height = 42
            label.frame.size.width = self.lipListTableView.frame.size.width
            label.center = self.lipListTableView.center
            label.center.y = self.lipListTableView.frame.size.height / 3
            label.numberOfLines = 2
            label.textColor = .darkGray
            label.text = "Sorry, There are no lipstick color you looking for."
            label.textAlignment = .center
            label.tag = 1
            
            self.lipListTableView.addSubview(label)
        } else {
            self.lipListTableView.viewWithTag(1)?.removeFromSuperview()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? LipstickDetailViewcontroller {
            let index = sender as! IndexPath
            destination.lipstick = lipstickList[index.row]
        }
    }
}

extension LipstickListViewController {
    func fetchData() {
        LipstickRepository.fetchSimilarLipstickHexColor(self.lipHexColor ?? "") { (lipsticks) in
            self.lipstickListPipe.input.send(value: lipsticks)
        }
    }
}

extension LipstickListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lipstickList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LipstickListTableViewCell") as! LipstickListTableViewCell
        let lipstick = lipstickList[indexPath.item]
        cell.setLipstick(lipstick: lipstick)
        cell.hero.isEnabled = true
        cell.hero.modifiers = [
            .whenPresenting(
                .delay(Double(indexPath.row) * 0.1),
                .fade,
                .translate(y: CGFloat(500 + (indexPath.item * 50))),
                .spring(stiffness: 100, damping: 17)
            )
        ]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showLipstickDetail" , sender: indexPath)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
}

// logo and NavBar
extension LipstickListViewController{
    
    func addNavBarImage(){
        let navController = navigationController!
        let image = UIImage(named: "logo-3")
        let imageView = UIImageView(image : image)
        
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        
        let bannerX = (bannerWidth / 2 ) - (image!.size.width / 2 )
        let bannerY = (bannerHeight / 2 ) - (image!.size.height / 2 )
        
        imageView.frame = CGRect( x : bannerX, y: bannerY , width: bannerWidth , height : bannerHeight)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView  = imageView
    }

}
extension LipstickListViewController : UISearchControllerDelegate , UISearchBarDelegate{
    
    func searchBarLip() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        
        if #available(iOS 11.0, *) {
            let search = UISearchController(searchResultsController: nil)
            search.delegate = self
            let searchBackground = search.searchBar
            searchBackground.placeholder = "Brand, Color, ..."
            
            if let textfield = searchBackground.value(forKey: "searchField") as? UITextField {
                textfield.textColor = UIColor.black
                if let backgroundview = textfield.subviews.first {
                    
                    backgroundview.backgroundColor = UIColor.white
                    
                    backgroundview.layer.cornerRadius = 10;
                    backgroundview.clipsToBounds = true;
                }
            }
            
            if let navigationbar = self.navigationController?.navigationBar {
                navigationbar.barTintColor = UIColor.black
            }
            navigationItem.searchController = search
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
}

// MARK: Reactive init
extension LipstickListViewController {
    func initReactiveLipstickList() {
        lipstickListObserver = Signal<[Lipstick], NoError>.Observer(value: { (lipsticks) in
            self.lipstickList = lipsticks
            print(lipsticks.count)
            self.lipListTableView.reloadData()
            self.lipListTableView.layoutIfNeeded()
            self.reloadData()
        })
        lipstickListPipe.output.observe(lipstickListObserver!)
    }
}

extension LipstickListViewController {
    func initHero() {
        self.hero.isEnabled = true
        self.lipListTableView.hero.modifiers = [.cascade]
        print("hero")
    }
}
