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
    var state: Bool = false {
        didSet {
            arrowImage.image = UIImage(
                named: state ? "arrowUp": "arrowDown"
            )
        }
    }
    
    override init(frame : CGRect){
        super.init(frame: frame)
        self.addSubview(button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var arrowImage: UIImageView!
    
    lazy var button: UIButton = {
        let button = UIButton(frame: CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height))
        button.backgroundColor = .black
        button.titleLabel?.textColor = .black
        button.addTarget(self, action: #selector(onClickBrandLipstick), for: .touchUpInside)
        button.layer.cornerRadius = 10.0
       // button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.contentHorizontalAlignment = .left
        
        
        arrowImage = UIImageView(image: UIImage(named: state ? "arrowUp": "arrowDown"))
        arrowImage.translatesAutoresizingMaskIntoConstraints = false
        button.bringSubviewToFront(arrowImage)
        button.addSubview(arrowImage)
        NSLayoutConstraint.activate([
            arrowImage.rightAnchor.constraint(equalTo: button.rightAnchor, constant: -15),
            arrowImage.widthAnchor.constraint(equalToConstant: 18),
            arrowImage.heightAnchor.constraint(equalToConstant: 18),
            arrowImage.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
        return button
    }()
    
    @objc func onClickBrandLipstick(){
        print("click lipstick brand")
        if state {
            arrowImage.image = UIImage(named: "arrowDown")
        } else {
            arrowImage.image = UIImage(named: "arrowUp")
        }
        state.toggle()
        if let onClick = self.onClickFunction {
            onClick(self.index)
        }
    }
    
}
