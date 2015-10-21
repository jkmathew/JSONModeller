//
//  String+Extension.swift
//  JSONModeller
//
//  Created by Johnykutty Mathew on 03/06/15.
//  Copyright (c) 2015 Johnykutty Mathew. All rights reserved.
//

import Foundation

extension String {
    func startsWithDigit() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[0-9].*", options: [])
        if nil != regex.firstMatchInString(self, options: [], range: self.range()) {
            return true
            
        }
        return false
    }
    
    func range() -> NSRange {
        return NSMakeRange(0, self.characters.count)
    }
    
    func substring(range: NSRange) -> String {
        if self.isEmpty {
            return ""
        }
        let from = range.location
        let end = range.location + range.length
        return self[from..<end]
    }
    
    subscript (r: Range<Int>) -> String {
        get {
            if self.isEmpty {
                return ""
            }
            let subStart = self.startIndex.advancedBy(r.startIndex, limit: self.endIndex)
            let subEnd = subStart.advancedBy(r.endIndex - r.startIndex, limit: self.endIndex)
            return self.substringWithRange(Range(start: subStart, end: subEnd))
        }
    }
    
    func substring(from from: Int) -> String {
        if self.isEmpty {
            return ""
        }
        let end = self.characters.count
        return self[from..<end]
    }
    
    func substring(to to: Int) -> String {
        if self.isEmpty {
            return ""
        }
        let from = 0
        return self[from..<to]
    }
    
    func substring(from: Int, length: Int) -> String {
        if self.isEmpty {
            return ""
        }
        let end = from + length
        return self[from..<end]
    }
    
    func firstLetterLoweredString() -> String {
        if self.isEmpty {
            return ""
        }
        let lowercase = self.substring(to: 1).lowercaseString
        let value = lowercase + self.substring(from: 1)
        return value
    }
}