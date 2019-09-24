//
//  SearchViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 23/9/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController ,UISearchResultsUpdating, UISearchBarDelegate{
    
    @IBOutlet weak var searchTableView: UITableView!
 
    var array = ["Brazil", "Bolivia", "United States", "Canada", "England", "Germany", "France", "Portugal"]
    var arrayFilter = [String]()
    
    var searching = false
   
    var searchLipsticks = [Lipstick]()
    var searchLipstickFilter = [Lipstick]()
    func createSearchLipstickArray() -> [Lipstick] {
        let searhLipstick1 : Lipstick = Lipstick( 33,  ["Sephora_black_logo"], "MAC", "mmmm",  "pinky", "Lorem ipsum dolor sit amet, consecetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco ",  UIColor(), 6798)
        let searhLipstick2 : Lipstick = Lipstick( 33,  ["Sephora_black_logo"], "YSL", "mmmm",  "pinky", "Lorem ipsum dolor sit amet, consecetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco ",  UIColor(), 6798)
        let searhLipstick3 : Lipstick = Lipstick( 33,  ["Sephora_black_logo"], "ETUDE", "mmmm",  "pinky", "Lorem ipsum dolor sit amet, consecetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco ",  UIColor(), 6798)
        
        return [searhLipstick1 , searhLipstick2 , searhLipstick3]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad()")
        searchTableView.delegate = self
        searchTableView.dataSource = self
      
        self.searchLipsticks = self.createSearchLipstickArray()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchLipstickFilter.count
       
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        
            cell.textLabel?.text = searchLipstickFilter[indexPath.item].lipstickBrand
        
        
//        let lipstick = searchLipstickArray[indexPath.item]
//        cell.setSearchLipstick(searchLipstick: lipstick)
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("updateSearchResults -- \(searchLipstickFilter.count)--")
//        searchLipstickFilter.removeAll()
        
        if let text = searchController.searchBar.text {
            print("text \(text)")
            print("searchLipstick\(searchLipsticks.count)")
            for lipstick in searchLipsticks {
                print("lipstick \(lipstick)")
                if lipstick.lipstickBrand.contains(text) {
                    searchLipstickFilter.append(lipstick)
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
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        searchLipsticks.removeAll()
        searchTableView.reloadData()
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        searchLipsticks.removeAll()
        searchTableView.reloadData()
        
        return true
    }
    
}

