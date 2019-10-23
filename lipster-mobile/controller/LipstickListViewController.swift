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
    
    @IBOutlet weak var customTitle: UILabel!
    
    var lipHexColor: String?
    var searchController : UISearchController!
    var resultController = UITableViewController()
    var lipstickList = [Lipstick]()
    var customTitleString: String?
    
    let lipstickListPipe = Signal<[Lipstick], NoError>.pipe()
    var lipstickListObserver: Signal<[Lipstick], NoError>.Observer?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        }
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initHero()
        initReactiveLipstickList()
        
        tableView.contentInsetAdjustmentBehavior = .never
        if self.lipHexColor != nil {
            fetchData()
        }
        if let title = customTitleString {
            customTitle.text = title
        }
        
        let footer = UIView(frame: .zero)
        footer.backgroundColor = .white
        tableView.tableFooterView = footer
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
    @IBAction func goBack(_ sender: Any) {
        hero.dismissViewController()
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
        
        let selectedBackgroundView = UIView(frame: .zero)
        selectedBackgroundView.backgroundColor = .lightGray
        
        cell.selectedBackgroundView = selectedBackgroundView
        cell.hero.modifiers = [
            .whenPresenting(
                .translate(y: CGFloat(500 + (Double(indexPath.item) * 30))),
                .fade,
                .spring(stiffness: 100, damping: 15)
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
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let lipstick = lipstickList[indexPath.item]
        let state = Lipstick.isLipstickFav(lipstick)
        let title = state ? "REMOVE" : "ADD"
        let imageName = state ? "favoritePopup" : "favoritePopup"
        let action = UIContextualAction(style: .normal, title: title) { (action, view, completion) in
            Lipstick.toggleFavLipstick(lipstick)
            completion(true)
        }
        let image = UIImage(named: imageName)
        let resizeImage = image?.sd_resizedImage(with: CGSize(width: 36, height: 36), scaleMode: .aspectFill)
        action.image = resizeImage
        action.backgroundColor = state ? .black : .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
}

// MARK: Reactive init
extension LipstickListViewController {
    func initReactiveLipstickList() {
        lipstickListObserver = Signal<[Lipstick], NoError>.Observer(value: { (lipsticks) in
            self.lipstickList = lipsticks
            self.lipListTableView.reloadData()
            self.lipListTableView.layoutIfNeeded()
            self.reloadData()
        })
        lipstickListPipe.output.observe(lipstickListObserver!)
    }
}

extension LipstickListViewController {
    
}

extension LipstickListViewController {
    func initHero() {
        self.hero.isEnabled = true
        self.lipListTableView.hero.modifiers = [.cascade]
    }
}
