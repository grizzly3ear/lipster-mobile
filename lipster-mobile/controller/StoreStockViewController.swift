//
//  StoreStockViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 28/10/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class StoreStockViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
   

    @IBOutlet weak var storeStockTableView: UITableView!
    var lipstickDictionary = Dictionary<String, Dictionary<String, [Lipstick]>>()
    var lipstickExpandState: [Bool]!
    
    var lipsticks = [Lipstick]()
    func createLipstickArray() -> [Lipstick] {
        let lipstick1 : Lipstick = Lipstick(759, [""], "ETUDE","Velvet Matte Lipstick Pencil", "Roman Holiday - vibrant pink sheen", "detailnbhlgdjgyuuftdedo7649bnms", .red, 03, "")
        let lipstick2 : Lipstick = Lipstick(759, [""], "LANCOME","Velvet Matte Lipstick Pencil", "Roman Holiday - vibrant pink sheen", "detailnbhlgdjgyuuftdedo7649bnms", .red, 03, "")
        
        return [lipstick1 , lipstick2 ]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        storeStockTableView.tableFooterView = UIView()
        self.lipsticks = Lipstick.mockArrayData(size: 20)
        
        formatData()
        self.lipstickExpandState = Array(repeating: false, count: lipstickDictionary.count)
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let lipstickBrandView = BrandLipstickView(frame: CGRect(x: 0, y: 0, width: storeStockTableView.frame.size.width, height: 40))
        let brand = Array(lipstickDictionary.keys)[section]
        lipstickBrandView.brandTitle = brand
        lipstickBrandView.index = section
        lipstickBrandView.onClickFunction = toggleExpandState
            
        
        
        return lipstickBrandView
    }
    
    func toggleExpandState(index: Int) -> Void {
        print(index)
        lipstickExpandState[index].toggle()
        storeStockTableView.reloadSections([index], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
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
        self.lipsticks.forEach { (lipstick) in
            if let _ = lipstickDictionary[lipstick.lipstickBrand] {
                // Already have this brand
                if let _ = lipstickDictionary[lipstick.lipstickBrand]![lipstick.lipstickName] {
                    // Have this name
                    lipstickDictionary[lipstick.lipstickBrand]![lipstick.lipstickName]?.append(lipstick)
//                    dictionaryName.append(lipstick)
                } else {
                    // Does not have this name yet
                    lipstickDictionary[lipstick.lipstickBrand]![lipstick.lipstickName] = [lipstick]
//                    dictionaryBrand[lipstick.lipstickName] = [lipstick]
                }
            } else {
                // not have this brand yet
                lipstickDictionary[lipstick.lipstickBrand] = [
                    lipstick.lipstickName: [lipstick]
                ]
            }
        }
        print(lipstickDictionary)
    }
       
}
