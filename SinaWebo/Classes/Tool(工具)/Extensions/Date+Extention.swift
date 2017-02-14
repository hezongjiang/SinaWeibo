//
//  Date+Extention.swift
//  SinaWebo
//
//  Created by Hearsay on 2017/2/10.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import Foundation

private let dateFormatter = DateFormatter()

extension Date {
    
    static func dateString(dalte: TimeInterval) -> String {
        
        let date = Date(timeIntervalSinceNow: dalte)
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: date)
    }
    
    static func stringToData(string: String) -> Date? {
        
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss zzz yyy"
        
        return dateFormatter.date(from: string)
    }
    
}
