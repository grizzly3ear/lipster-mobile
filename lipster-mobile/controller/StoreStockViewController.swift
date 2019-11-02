//
//  StoreStockViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 28/10/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class StoreStockViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
   
    @IBOutlet weak var storeStockTableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    let lipstickDataPipe = Signal<[Lipstick], NoError>.pipe()
    var lipstickDataObserver: Signal<[Lipstick], NoError>.Observer?
    
    var lipstickDictionary = Dictionary<String, Dictionary<String, [Lipstick]>>()
    var lipstickExpandState: [Bool]!
    var lipsticks = [Lipstick]()
    var filterLipsticks = [Lipstick]()
    var store: Store?
    
    @IBAction func goBack(_ sender: Any) {
        hero.dismissViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initReactive()
        storeStockTableView.tableFooterView = UIView(frame: .zero)
        self.textField.delegate = self
        self.textField.autocorrectionType = .no
        self.textField.autocapitalizationType = .none
        self.fetchData()
    }
    
    func fetchData() {
        LipstickRepository.fetchLipstickInStore(store: store!) { (lipsticks) in
            self.lipsticks = lipsticks
            self.lipstickDataPipe.input.send(value: lipsticks)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let lipstickBrandView = BrandLipstickView(frame: CGRect(x: 0, y: 0, width: storeStockTableView.frame.size.width, height: 40))
        let brand = Array(lipstickDictionary.keys)[section]
        lipstickBrandView.brandTitle = "\(brand)"
        lipstickBrandView.index = section
        lipstickBrandView.onClickFunction = toggleExpandState
        lipstickBrandView.state = lipstickExpandState[section]
        
        return lipstickBrandView
    }
    
    func toggleExpandState(index: Int) -> Void {
        lipstickExpandState[index].toggle()
        storeStockTableView.reloadSections([index], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showLipstickList", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return lipstickDictionary.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let brand = Array(lipstickDictionary.keys)[section]
        if lipstickExpandState[section] {
            return lipstickDictionary[brand]!.count
        } else {
            return 0
        }
        
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "storeStockTableViewCell") as! StoreStockTableViewCell
        
        let brand = Array(lipstickDictionary.keys)[indexPath.section]
        let name = Array(lipstickDictionary[brand]!.keys)[indexPath.row]
        cell.stockLipstickBrand?.text = name
        return cell
    }
    
    func formatData() {
        lipstickDictionary.removeAll()
        self.filterLipsticks.forEach { (lipstick) in
            if let _ = lipstickDictionary[lipstick.lipstickBrand] {
                // Already have this brand
                if let _ = lipstickDictionary[lipstick.lipstickBrand]![lipstick.lipstickName] {
                    // Have this name
                    lipstickDictionary[lipstick.lipstickBrand]![lipstick.lipstickName]?.append(lipstick)
//                    dictionaryName.append(lipstick)
                } else {
                    // Does not have this name yet
                    lipstickDictionary[lipstick.lipstickBrand]![lipstick.lipstickName] = [lipstick]

                }
            } else {
                // not have this brand yet
                lipstickDictionary[lipstick.lipstickBrand] = [
                    lipstick.lipstickName: [lipstick]
                ]
            }
        }
        print(lipstickDictionary.count)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        if identifier == "showLipstickList" {
            let destination = segue.destination as! LipstickListViewController
            let indexPath = sender as! IndexPath
            let brand = Array(lipstickDictionary.keys)[indexPath.section]
            let detail = Array(lipstickDictionary[brand]!.keys)[indexPath.row]
            let lipsticks = lipstickDictionary[brand]![detail]
            destination.lipstickList = lipsticks!
            destination.customTitleString = "\(brand): \(detail)"
        }
    }
}

// MARK: UITextFieldDelegate
extension StoreStockViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if var text = textField.text {
            if string == "" {
                text.removeLast()
            }
            text += string
            
            lipstickDataPipe.input.send(value: filter(text))
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.lipstickDataPipe.input.send(value: self.lipsticks)
        return true
    }
    
    func filter(_ text: String) -> [Lipstick] {
        var lipsticks = [Lipstick]()
        for lipstick in self.lipsticks {
            if lipstick.lipstickBrand.lowercased().contains(text.lowercased()) {
                lipsticks.append(lipstick)
            } else if lipstick.lipstickName.lowercased().contains(text.lowercased()) {
                lipsticks.append(lipstick)
            }
        }
        return lipsticks
    }
}

extension StoreStockViewController {
    func initReactive() {
        lipstickDataObserver = Signal<[Lipstick], NoError>.Observer(value: { (lipsticks) in
            self.filterLipsticks = lipsticks
            self.formatData()
            self.lipstickExpandState = Array(repeating: false, count: self.lipstickDictionary.count)
            self.storeStockTableView.reloadData()
        })
        lipstickDataPipe.output.observe(lipstickDataObserver!)
    }
}
