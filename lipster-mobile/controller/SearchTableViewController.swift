//
//  SearchViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 23/9/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit
import Hero

class SearchTableViewController: UITableViewController , UISearchResultsUpdating, UISearchBarDelegate {
    
    var searchController : UISearchController!
    @IBOutlet weak var searchTableView: UITableView!

    var searching = false
    var searchLipsticks = [Lipstick]()
    var searchLipstickFilter = [Lipstick]()
    var searchLipstickDictionary: Dictionary<Int, [String: Lipstick]> = Dictionary()
    
    var searchStoreLipstick = [Store]()
    var searchStoreLipstickFilter = [Store]()
    var searchStoreLipstickDictionary: Dictionary<Int, [String: Store]> = Dictionary()
    
    var searchFilterDictionary: Dictionary<Int, [String: Any]> = Dictionary()
    
    func createSearchLipstickArray() -> [Lipstick] {
        let searhLipstick1 : Lipstick = Lipstick( 33,  ["Sephora_black_logo"], "MAC", "name1",  "cool red", "Lorem ipsum dolor sit amet, consecetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco ",  UIColor(), 6798)
        let searhLipstick2 : Lipstick = Lipstick( 33,  ["Sephora_black_logo"], "YSL", "EE name2",  "pinky", "Lorem ipsum dolor sit amet, consecetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco ",  UIColor(), 6798)
        let searhLipstick3 : Lipstick = Lipstick( 33,  ["Sephora_black_logo"], "ETUDE", "name 3",  "hot hot pinky", "Lorem ipsum dolor sit amet, consecetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco ",  UIColor(), 6798)
        
        return [searhLipstick1 , searhLipstick2 , searhLipstick3]
    }
    func createStoreLipstickArray() -> [Store] {
        let store1 : Store = Store(id: 1, storeLogoImage: "UIImage(named: Sephora_black_logo)!", storeName: "Sephora CentralPlaza Ladprao", storeHours: "Mon - Sun  10AM-10PM", storeAddress: "1693 CentralPlaza Ladprao, Level 2, Unit 217 Phahonyothin Rd, Chatuchak Sub-district , Chatuchak District, Bangkok", storeLatitude: 50.0, storeLongitude: 50.0, storePhoneNumber: "00")
        let store2 : Store = Store(id: 2, storeLogoImage: "UIImage(named: Sephora_black_logo)!", storeName: "Sephora ", storeHours: "Mon - Sun  10AM-10PM", storeAddress: "7/222 Central Plaza Pinklao, Unit 106, Level 1 Boromratchonni Road, Arun-Amarin, Bangkoknoi, Bangkok 10700", storeLatitude: 50.0, storeLongitude: 50.0, storePhoneNumber: "00")
        let store3 : Store = Store(id: 3, storeLogoImage: "UIImage(named: nopic)!", storeName: "Etude House Central Plaza Rama 2", storeHours: "Mon - Sun  10AM-10PM", storeAddress: "L1, Central Plaza Rama 2, 128 Rama II Rd, Khwaeng Samae Dam, Samae Dum, Krung Thep Maha Nakhon 10150", storeLatitude: 50.0, storeLongitude: 50.0, storePhoneNumber: "00")
        
        return [store1 , store2 , store3]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hero.isEnabled = true
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        self.definesPresentationContext = true
        let searchbar = searchController.searchBar

        searchbar.hero.id = "searchbar"
        searchbar.showsCancelButton = true
        searchbar.delegate = self
        searchbar.searchBarStyle = .minimal
        
        navigationItem.titleView = searchbar
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.hidesBackButton = true
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        
        
        self.searchLipsticks = self.createSearchLipstickArray()
        self.searchStoreLipstick = self.createStoreLipstickArray()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchFilterDictionary.count
       
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        performSegue(withIdentifier: "showLipstickDetailFromSearch" , sender: self)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell

        cell.searchLabel.text = searchFilterDictionary[indexPath.row]?.keys.first
        
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            searchFilterDictionary.removeAll()
            if let text = searchController.searchBar.text?.lowercased() {
                var index = 0
                for lipstick in searchLipsticks {
                    
                    if lipstick.lipstickBrand.lowercased().contains(text) {
                        searchFilterDictionary[index] = [
                            lipstick.lipstickBrand: lipstick
                        ]
                        index += 1
                    }
                    if lipstick.lipstickName.lowercased().contains(text) {
                        searchFilterDictionary[index] = [
                            lipstick.lipstickName: lipstick
                        ]
                        index += 1
                    }
                    if lipstick.lipstickColorName.lowercased().contains(text) {
                        searchFilterDictionary[index] = [
                            lipstick.lipstickColorName: lipstick
                        ]
                        index += 1
                    }
                }
                for store in searchStoreLipstick {
                    if store.name.lowercased().contains(text) {
                        searchFilterDictionary[index] = [
                            store.name: store
                        ]
                        index += 1
                    }
                }
            }
        }
        searchTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchLipsticks.removeAll()
        if let text = searchBar.text {
            for lipstick in searchLipsticks {
                if lipstick.lipstickBrand.contains(text) {
                    searchLipstickFilter.append(lipstick)
                }
                
            }
        }
        searchTableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        searchLipsticks.removeAll()
        searchTableView.reloadData()
        
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hero.dismissViewController()
    }
    
}

