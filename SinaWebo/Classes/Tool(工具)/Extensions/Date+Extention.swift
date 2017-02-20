//
//  Date+Extention.swift
//  SinaWebo
//
//  Created by Hearsay on 2017/2/10.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import Foundation

private let dateFormatter = DateFormatter()

private let calendar = Calendar.current

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
    
    var dateDescription: String {
        
        if calendar.isDateInToday(self) {
            
            let dalte = -Int(timeIntervalSinceNow)
            if dalte < 60 { return "刚刚" }
            if dalte < 3600 { return "\(dalte / 60) 分钟前" }
            return "\(dalte / 3600) 小时前"
        }
        
        var fmt = " HH:mm"
        
        if calendar.isDateInYesterday(self) {
            fmt = "昨天" + fmt
        } else {
            let year = calendar.component(.year, from: self)
            let thisYear = calendar.component(.year, from: Date())
            if year == thisYear {
                fmt = "MM-dd" + fmt
            } else {
                fmt = "yyyy-" + fmt
            }
        }
        
        dateFormatter.dateFormat = fmt
        
        return dateFormatter.string(from: self)
    }
}
