//
//  PropertyCreator.swift
//  JSONModeller
//
//  Created by Johnykutty Mathew on 30/05/15.
//  Copyright (c) 2015 Johnykutty Mathew. All rights reserved.
//

import Cocoa

class PropertyCreator: NSObject {
    var usePrimitiveTypes = true

    func propertyDeclarationFor(key: String, value: AnyObject) {
        println("key: \"\(key )\"")
        println("value: \"\(value )\"")
        println("value class_getName: \"\(String.fromCString(class_getName(value.classForCoder)) )\"")
        
    }
    
    func propertyNameFrom(key: String) -> String {
        let unwantedCharacters = NSCharacterSet(charactersInString: "0987654321abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ").invertedSet
        let components = key.componentsSeparatedByCharactersInSet(unwantedCharacters)
        
        var propertyName = ""
        if !components.isEmpty {
            propertyName += components.first!.lowercaseString

            for (var i = 1; i < components.count; i++) {
                let component = components[i]
                propertyName += component.capitalizedString
            }
        }
        
        return propertyName
    }
}
