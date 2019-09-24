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
    var searchLipstickArray = [Lipstick] ()
    var searchLipstickFilter = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad()")
        searchTableView.delegate = self
        searchTableView.dataSource = self
      
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayFilter.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        
      // cell.textLabel?.text = searchLipstickFilter[indexPath.row]
       cell.textLabel?.text = arrayFilter[indexPath.row]
        
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("updateSearchResults")
        arrayFilter.removeAll()
        
        if let text = searchController.searchBar.text {
            for string in array {
                if string.contains(text) {
                    arrayFilter.append(string)
                }
            }
        }
        
        searchTableView.reloadData()
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        arrayFilter.removeAll()
        
        if let text = searchBar.text {
            for string in array {
                if string.contains(text) {
                    arrayFilter.append(string)
                }
            }
        }
        
        searchTableView.reloadData()
        
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        arrayFilter.removeAll()
        searchTableView.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        arrayFilter.removeAll()
        searchTableView.reloadData()
        
        return true
    }
    
}

