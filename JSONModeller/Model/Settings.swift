//
//  Settings.swift
//  JSONModeller
//
//  Created by Johnykutty Mathew on 05/06/15.
//  Copyright (c) 2015 Johnykutty Mathew. All rights reserved.
//

import Cocoa

class Settings: NSObject {
    
    private static var _shared: Settings? = nil
    
    static var shared: Settings {
        if _shared == nil, let data =  UserDefaults.standard.object(forKey: "SavedSettings") as? Data,
                let object = NSKeyedUnarchiver.unarchiveObject(with: data) as? Settings {
                    _shared = object
            }
        
        else {
            _shared = Settings()
        }
        return _shared!
    }
    
    
    var usePrimitiveTypes = true
    
    fileprivate override init() {
        print(#function)
    }
    
    required init(coder aDecoder: NSCoder) {
        self.usePrimitiveTypes = aDecoder.decodeBool(forKey: "usePrimitiveTypes")
    }
    
    func encodeWithCoder(_ aCoder: NSCoder) {
        aCoder.encode(usePrimitiveTypes, forKey: "usePrimitiveTypes")
    }
}
