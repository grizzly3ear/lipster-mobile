//
//  TryMeViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 17/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class TryMeViewController: UIViewController  {
 
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func clickedLipColorBtn(_ sender: Any) {
        print("clicked color button")
    }
    
    let colorCode:[UIColor] = [UIColor(rgb: 0xB74447),UIColor(rgb: 0xFA4855),UIColor(rgb: 0xFE486B),UIColor(rgb: 0xFF9A94) ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension TryMeViewController : UICollectionViewDataSource ,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  colorCode.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! LipSelectedColorCollectionViewCell
        cell.lipColorButton.backgroundColor = colorCode[indexPath.item]
        
        return cell
    }
    
}
