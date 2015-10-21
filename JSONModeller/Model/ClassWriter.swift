//
//  ClassWriter.swift
//  JSONModelCreator
//
//  Created by Johnykutty Mathew on 24/05/15.
//  Copyright (c) 2015 Johnykutty. All rights reserved.
//

import Foundation
import AddressBook

enum Filetype : String {
    case ObjectiveC_H = "h", ObjectiveC_M = "m" //,Swift = "swift"
}

private let dateFormatter = NSDateFormatter()

class ClassWriter: NSObject {
    var writingClassName: String
    var writingClassPrefix: String
    var writingClassData: NSDictionary
    
    
    override class func initialize () {
        dateFormatter.dateFormat = "yyyy"
        dateFormatter.locale = NSLocale.systemLocale()
    }
    
    init(writingClassName:String,forData:NSDictionary) {
        self.writingClassName = writingClassName.isEmpty ? "MyModel" : writingClassName
        self.writingClassPrefix = ""
        self.writingClassData = forData
    }
    
    //MARK: File operations
    func writeFiles(directory:String) {
        let hFileContents = self.templateFor(Filetype.ObjectiveC_H)

        let mFileContents = self.templateFor(Filetype.ObjectiveC_M)
        
        var propertyDeclarations = [String]()
        var forwardDeclarations = [String]()
        var importStatements = [String]()
        var keyMap = [String]()
        for (key, value) in self.writingClassData {
            let info = PropertyInfo(key: key as! String, value: value, owner: self.writingClassName)
            if info.isCustomClass {
                forwardDeclarations.append(info.forwardClassDeclaration)
                importStatements.append(info.importStatement)
                
                let writer = ClassWriter(writingClassName: info.type, forData: value as! NSDictionary)
                writer.writeFiles(directory)
            }
            if let map = info.keyMapItem {
                keyMap.append(map)
            }
            propertyDeclarations.append(info.propertyDeclaration)
        }
        
        let forwardDeclarationsString = self.replacementFor(forwardDeclarations, joiner: "\n")
            hFileContents.replaceOccurrencesOfString(kForwardDeclarationsPlaceholder, withString: forwardDeclarationsString)
        
        let propertyDeclarationsString = self.replacementFor(propertyDeclarations, joiner: "\n")
            hFileContents.replaceOccurrencesOfString(kPropertyDeclarationsPlaceholder, withString: propertyDeclarationsString)

        let importStatementsString = self.replacementFor(importStatements, joiner: "\n")
            mFileContents.replaceOccurrencesOfString(kImportsPlaceholder, withString: importStatementsString)
        
        let keyMapString = self.replacementFor(keyMap, joiner: ",\n")
            mFileContents.replaceOccurrencesOfString(kKeymapperPlaceholder, withString: keyMapString)
    
       
        self.writeContents(hFileContents, inFolder: directory, withType: Filetype.ObjectiveC_H)
        self.writeContents(mFileContents, inFolder: directory, withType: Filetype.ObjectiveC_M)
    }
    
    func replacementFor(items: [String], joiner: String) -> String {
        let replacementString = items.count > 0 ? "\n" + items.joinWithSeparator("\n") + "\n" : ""
        return replacementString;
    }
    
    func writeContents(fileContents: NSMutableString, inFolder pathToFilder:String, withType type: Filetype) {
        let fileURL = self.urlFor(type, inFolder: pathToFilder)
        do {
            try fileContents.writeToURL(fileURL, atomically: true, encoding: NSUTF8StringEncoding)
        } catch _ {
        }
    }
    
    func templateFor(type: Filetype) -> NSMutableString {
        let path = NSBundle.mainBundle().pathForResource(type.rawValue, ofType: "filetemplate")
        let fileContents: NSMutableString
        do {
            fileContents = try NSMutableString(contentsOfFile:path!, encoding: NSUTF8StringEncoding)
        } catch _ as NSError {
            fileContents = NSMutableString(string: "")
        }
        
        let createdOnDateString = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.NoStyle)
        let copyrightYear = self.copyrightYear()

        let authorName = self.authorName()
        let companyName = self.companyName()
        
        let fullClassName = self.fullClassName()
        
        fileContents.replaceOccurrencesOfString(kClassNamePlaceholder, withString: fullClassName)
        fileContents.replaceOccurrencesOfString(kCreatedDatePlaceholder, withString: createdOnDateString)
        fileContents.replaceOccurrencesOfString(kCopyrightYearPlaceholder, withString: copyrightYear)
        fileContents.replaceOccurrencesOfString(kAuthorNamePlaceholder, withString: authorName)
        fileContents.replaceOccurrencesOfString(kCompanyNamePlaceholder, withString: companyName)
        
        return fileContents
    }
    
    func urlFor(type: Filetype, inFolder pathToFilder: String) -> NSURL {
        let fullClassName = self.fullClassName()
        let directoryURL = NSURL(fileURLWithPath: pathToFilder, isDirectory: true)
        let fileURL = directoryURL.URLByAppendingPathComponent(fullClassName).URLByAppendingPathExtension(type.rawValue)
        print(fileURL)
        return fileURL
    }
    
    
    //MARK: Getters
    func fullClassName() -> String {
        return self.writingClassPrefix + self.writingClassName
    }
    
    func copyrightYear() -> String {
        return dateFormatter.stringFromDate(NSDate())
    }
    
    func authorName() -> String {
        return NSFullUserName()
    }
    
    func companyName() -> String {
        let person = ABAddressBook.sharedAddressBook().me()
        if let me = person {
            if let company = me.valueForProperty(kABOrganizationProperty) as? String {
                return company
            }
        }
        return "_My_Company_"
    }
    
}
