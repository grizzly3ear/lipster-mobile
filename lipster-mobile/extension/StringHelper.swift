//
//  UITextViewHelper.swift
//  lipster-mobile
//
//  Created by Bank on 20/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//
import UIKit

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet(charactersIn: " "))
    }
}
