//
//  SearchViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 23/9/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class SearchViewTableViewController: UIViewController {
    
    @IBOutlet weak var searchTableView: UITableView!
    var array = ["Brazil", "Bolivia", "United States", "Canada", "England", "Germany", "France", "Portugal"]
    
    var arrayFilter = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad()")
    }
    
}

extension SearchViewTableViewController : UITableViewDelegate , UITableViewDataSource , UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        print("updateSearchResults")
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayFilter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        
        cell.searchLabel?.text = arrayFilter[indexPath.row]
        
        return cell
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked")
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
        print("searchBarCancelButtonClicked")
        arrayFilter.removeAll()
        searchTableView.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        print("searchBarShouldBeginEditing")
        arrayFilter.removeAll()
        searchTableView.reloadData()
        
        return true
    }
    
    
}
