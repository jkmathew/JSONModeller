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
        let regex = NSRegularExpression(pattern: "^[0-9].*", options: nil, error: nil)!
        if nil != regex.firstMatchInString(self, options: nil, range: self.range()) {
            return true
            
        }
        return false
    }
    
    func range() -> NSRange {
        return NSMakeRange(0, count(self))
    }
    
    func substring(range: NSRange) -> String {
        let from = range.location
        let end = range.location + range.length
        return self[from..<end]
    }
    
    subscript (r: Range<Int>) -> String {
        get {
            let subStart = advance(self.startIndex, r.startIndex, self.endIndex)
            let subEnd = advance(subStart, r.endIndex - r.startIndex, self.endIndex)
            return self.substringWithRange(Range(start: subStart, end: subEnd))
        }
    }
    
    func substring(#from: Int) -> String {
        let end = count(self)
        return self[from..<end]
    }
    
    func substring(#to: Int) -> String {
        let from = 0
        return self[from..<to]
    }
    
    func substring(from: Int, length: Int) -> String {
        let end = from + length
        return self[from..<end]
    }
}