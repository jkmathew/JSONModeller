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
   
    let unwantedCharacters = NSCharacterSet(charactersInString: "0987654321abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ").invertedSet

    func propertyDeclarationFor(key: String, value: AnyObject) {
        println("key: \"\(key )\"")
        println("value: \"\(value )\"")
        println("value class_getName: \"\(String.fromCString(class_getName(value.classForCoder)) )\"")
        
    }
    
    func propertyNameFrom(key: String) -> String {

        //Make each alphabet whith leading non alphabet to upercase
        let capitalized = key.capitalizedString
        
        //Extracts only alphabets and digits
        let components = capitalized.componentsSeparatedByCharactersInSet(unwantedCharacters)
        let filteredComponents = components.filter {
            return !$0.isEmpty
        }
        var propertyName = "".join(filteredComponents)

        //if its empty just create a dummy
        if propertyName.isEmpty {
            propertyName = "_Item_"
        }
        //If starts with digit add _ to begining
        else if propertyName.startsWithDigit() {
            propertyName = "_" + propertyName
        }
        // Make first character lowercase
        else {
            let lowercaseBegining = propertyName.substring(to: 1).lowercaseString
            propertyName = lowercaseBegining + propertyName.substring(from: 1)
        }
        

        return propertyName
    }
}
