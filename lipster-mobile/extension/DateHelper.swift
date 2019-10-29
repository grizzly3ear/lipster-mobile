//
//  DateHelper.swift
//  lipster-mobile
//
//  Created by Bank on 27/10/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import Foundation

extension Date {
    func timeAgoDisplay() -> String {
        let secondAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * 60
        let day = 60 * 60 * 24
        let week = 60 * 60 * 24 * 7
        
//        if secondAgo < minute {
//            return "\(secondAgo) seconds ago."
//        } else if secondAgo < hour {
//            return "\(secondAgo / minute) minutes ago."
//        } else if secondAgo < day {
//            return "\(secondAgo / hour) hours ago."
//        } else if secondAgo < week {
//            return "\(secondAgo / day) days ago."
//        }
        
        if secondAgo < minute {
            return "Just now."
        } else if secondAgo < hour / 2 {
            return "Few minutes ago."
        } else if secondAgo < hour {
            return "\(secondAgo / minute) minutes ago."
        } else if secondAgo < day {
            return "\(secondAgo / hour) hours ago."
        } else if secondAgo < week {
            return "\(secondAgo / day) days ago."
        }
        return "\(secondAgo / week) weeks ago."
    }

}
