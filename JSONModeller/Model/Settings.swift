//
//  Settings.swift
//  JSONModeller
//
//  Created by Johnykutty Mathew on 05/06/15.
//  Copyright (c) 2015 Johnykutty Mathew. All rights reserved.
//

import Cocoa

class Settings: NSObject {
    
    class func sharedInstance() -> Settings {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: Settings? = nil
        }
        dispatch_once(&Static.onceToken) {
            if let data =  NSUserDefaults.standardUserDefaults().objectForKey("SavedSettings") as? NSData {
                if let object = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Settings {
                    Static.instance = object
                }
            }
            if Static.instance == nil {// since we have two nested if can't simply write else
                Static.instance = Settings()
            }
        }
        return Static.instance!
    }
    
    var usePrimitiveTypes = true
    
    private override init() {
        print(#function)
    }
    
    required init(coder aDecoder: NSCoder) {
        self.usePrimitiveTypes = aDecoder.decodeBoolForKey("usePrimitiveTypes")
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeBool(usePrimitiveTypes, forKey: "usePrimitiveTypes")
    }
}
