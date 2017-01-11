//
//  NSMutableString+Extension.swift
//  JSONModelCreator
//
//  Created by Johnykutty Mathew on 26/05/15.
//  Copyright (c) 2015 Johnykutty. All rights reserved.
//

import Foundation

extension NSMutableString {
    func replaceOccurrencesOfString(_ target: String, withString: String) -> Int {
        return self.replaceOccurrences(of: target, with:withString, options:NSString.CompareOptions.caseInsensitive, range:NSRange(location: 0, length: self.length))
    }
}
