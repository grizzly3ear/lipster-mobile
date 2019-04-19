//
//  TrendViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 19/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class TrendViewController: UIViewController ,UICollectionViewDelegate, UICollectionViewDataSource{
   

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    
    let trendImage : [UIImage] = [#imageLiteral(resourceName: "user2") ,#imageLiteral(resourceName: "bgDetail") , #imageLiteral(resourceName: "user1")]
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return trendImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TrendsOfHomeCollectionViewCell
        cell.trendImgView.image = trendImage[indexPath.item]
        
        return cell
    }

}
