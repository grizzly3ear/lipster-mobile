//
//  BrandLipstickView.swift
//  lipster-mobile
//
//  Created by Mainatvara on 28/10/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class BrandLipstickView: UIView {

    var brandTitle: String? {
        didSet {
            self.button.setTitle(self.brandTitle, for: .normal)
        }
    }
    
    var onClickFunction: ((Int) -> Void)?
    var index: Int!
    
    override init(frame : CGRect){
        super.init(frame: frame)
        self.addSubview(button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var button: UIButton = {
        let button = UIButton(frame: CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height))
        button.backgroundColor = .black
        button.titleLabel?.textColor = .black
        button.addTarget(self, action: #selector(onClickBrandLipstick), for: .touchUpInside)
        return button
        
    }()
    
    @objc func onClickBrandLipstick(){
        print("click lipstick brand")
        if let onClick = self.onClickFunction {
            onClick(self.index)
        }
    }
    
}
