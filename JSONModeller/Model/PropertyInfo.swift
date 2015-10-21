//
//  PropertyInfo.swift
//  JSONModeller
//
//  Created by Johnykutty Mathew on 30/05/15.
//  Copyright (c) 2015 Johnykutty Mathew. All rights reserved.
//

import Cocoa

class PropertyInfo: NSObject {
   
    private static let unwantedCharacters = NSCharacterSet(charactersInString: "0987654321abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ").invertedSet
    
    var ownerClass = ""
    var classPrefix = ""
    var type = "id"
    var propertyName = ""
    var isCustomClass = false
    private var isPrimitiveType = false
    
    private var originalJSONKey: String = ""
    
    var propertyDeclaration: String {
        get {
            let ownership = self.isPrimitiveType ? "assign" : "strong"
            let pointer = (self.isPrimitiveType || self.type == "id") ? "" : "*"
            return "@property (" + ownership + ", nonatomic) " + self.type + " " + pointer + "" + self.propertyName + ";"
        }
    }
    
    var keyMapItem: String! {
        get {
            if self.originalJSONKey == self.propertyName {
                return nil
            }
            let item = "@\"" + self.originalJSONKey + "\" : @\"" + self.propertyName + "\""
            return item
        }
    }
    
    var forwardClassDeclaration: String {
        get {
            return "@class " + self.type + ";"
        }
    }
    
    var importStatement: String {
        get {
            return "#import \"" + self.type + ".h\""
        }
    }
    
    override init() {
        
    }
    
    init(key: String, value: AnyObject, owner: String?) {
        super.init()
        self.originalJSONKey = key
        print("\n\n\n\nkey: \"\(key )\"")
        print("value: \"\(value )\"")
        print("value class_getName: \"\(String.fromCString(class_getName(value.classForCoder)) )\" ")
        
        if let ownerName = owner {
            self.ownerClass = ownerName
        }
        self.propertyName = self.propertyNameFrom(key)
        if value.isKindOfClass(NSDictionary) {
            self.isCustomClass = true
            self.type = self.classPrefix + self.pascalCaseStringFrom(key).capitalizedString
        }
        else if let number = value as? NSNumber where Settings.sharedInstance().usePrimitiveTypes{
            self.type = self.numberTypeFrom(number)
            self.isPrimitiveType = true
        }
        else if let type = String.fromCString(class_getName(value.classForCoder)) {
            self.type = type
        }
    }
    
    func propertyNameFrom(key: String) -> String {

        var propertyName = self.pascalCaseStringFrom(key)

        // If its empty just create a dummy
        if propertyName.isEmpty {
            propertyName = "_Item_"
        }
        // If the propertyname is description make it to classNameDescription format
        else if propertyName.lowercaseString == "description" {
            if self.ownerClass.isEmpty {
                propertyName = "objectDescription"
            }
            else {
                propertyName = self.ownerClass.firstLetterLoweredString() + "Description"
            }
        }
        // If the propertyname is id make it to classID format
        else if propertyName.lowercaseString == "id" {
            propertyName = self.ownerClass.firstLetterLoweredString() + "ID"
        }
        // If starts with digit or property name is any property of NSObject adding a leading _(underscore)
        else if propertyName.startsWithDigit() || NSObject.instancesRespondToSelector(Selector(propertyName)) {
            propertyName = "_" + propertyName
        }
        // Finally make first character lowercase
        else {
            propertyName = propertyName.firstLetterLoweredString()
        }
        
        return propertyName
    }
    
    func pascalCaseStringFrom(string: String) -> String {
        // Make each alphabet whith leading non alphabet to upercase
        let capitalizedMutableString = NSMutableString(string: string)
        
        let regEx = try? NSRegularExpression(pattern: "[^a-zA-Z][a-zA-Z]", options: [])
        regEx?.enumerateMatchesInString(string, options: [], range: string.range(), usingBlock: { (checkingResult, flags, stop) in
            var replacingRange = checkingResult!.range
            replacingRange.location += 1
            replacingRange.length = 1
            let replacingString = string.substring(replacingRange).uppercaseString
            capitalizedMutableString.replaceCharactersInRange(replacingRange, withString: replacingString)
        })
        
        let capitalized = capitalizedMutableString as String
        // Extracts only alphabets and digits
        let components = capitalized.componentsSeparatedByCharactersInSet(PropertyInfo.unwantedCharacters)
        let filteredComponents = components.filter {
            return !$0.isEmpty
        }
        let propertyName = filteredComponents.joinWithSeparator("")
        
        return propertyName
    }
    
    func numberTypeFrom(number: NSNumber) -> String {
        print(String.fromCString(number.objCType))

        /********************************************************
        Test output added below
        
        input - "bool": true,
        key: "bool"
        value: "1"
        value class_getName: "Optional("NSNumber")"
        Optional("c")
        ---------------------------------------------------------
        input - "int": 1,
        key: "int"
        value: "1"
        value class_getName: "Optional("NSNumber")"
        Optional("q")
        ---------------------------------------------------------
        input - "highInteger": 5000000000,
        key: "highInteger"
        value: "5000000000"
        value class_getName: "Optional("NSNumber")"
        Optional("q")
        ---------------------------------------------------------
        input - "muchhighinteger": 5000000000000000000000,
        key: "muchhighinteger"
        value: "5000000000000000000000"
        value class_getName: "Optional("NSDecimalNumberPlaceholder")"
        Optional("d")
        ---------------------------------------------------------
        input - "float": 1.1,
        key: "float"
        value: "1.1"
        value class_getName: "Optional("NSNumber")"
        Optional("d")
        ---------------------------------------------------------
        input - "morehigherfloat": 1111111122122222222222222222221111111111.1,
        key: "morehigherfloat"
        value: "1.111111122122222e+39"
        value class_getName: "Optional("NSNumber")"
        Optional("d")
        ---------------------------------------------------------
        input - "higherfloat": 111111111111111111.1,
        key: "higherfloat"
        value: "1.111111111111111e+17"
        value class_getName: "Optional("NSNumber")" 
        Optional("d")
        *********************************************************/
        if let type = String.fromCString(number.objCType) {
            if type.lowercaseString == "q" {
                return "long long"
            }
            // Assuming json doesn't have char type, boolean is also getting as 'c' from the above test outputs
            if type.lowercaseString == "c" {
                return "BOOL"
            }
        }
        return "double"
    }
}
