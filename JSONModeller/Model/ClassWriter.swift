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
    case ObjectiveC_H = "h", ObjectiveC_M = "m", Swift = "swift"
}

enum Languagetype : Int {
    case ObjectiveC = 1, Swift = 2
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
    
    class func writer(forType type:Languagetype, writingClassName: String, forData: NSDictionary) -> ClassWriter {
        if type == .Swift {
            return SwiftWriter(writingClassName: writingClassName, forData: forData)
        }
        return ObjectiveCWriter(writingClassName: writingClassName, forData: forData)
    }
    
    internal required init(writingClassName: String, forData: NSDictionary) {
        self.writingClassName = writingClassName.isEmpty ? "MyModel" : writingClassName
        self.writingClassPrefix = ""
        self.writingClassData = forData
    }
    
    //MARK: File operations
    func writeFiles(directory:String) {
        
        var propertyDeclarations = [String]()
        var forwardDeclarations = [String]()
        var importStatements = [String]()
        var keyMap = [String]()
        for (key, value) in self.writingClassData {
            let info = propertyInfo(forKey: key as! String, value: value, owner: self.writingClassName)
            if info.isCustomClass {
                forwardDeclarations.append(info.forwardClassDeclaration)
                importStatements.append(info.importStatement)

                let writer = self.dynamicType.init(writingClassName: info.elementTypeName, forData: info.customElement as! NSDictionary)
                writer.writeFiles(directory)
            }
            if let map = info.keyMapItem {
                keyMap.append(map)
            }
            propertyDeclarations.append(info.propertyDeclaration)
        }
        
        writeFilesTo(directory: directory, forwardDeclarations: forwardDeclarations, propertyDeclarations: propertyDeclarations, importStatements: importStatements, keyMap: keyMap)
        
    }
    
    private func propertyInfo(forKey key: String,  value: AnyObject, owner: String?) -> PropertyInfo {
        fatalError("implement in subclass")
    }
    
    private func writeFilesTo(directory directoryPath: String, forwardDeclarations: [String], propertyDeclarations: [String], importStatements: [String], keyMap: [String]) {
        fatalError("implement in subclass")
    }
    
    private func replacementFor(items: [String], joiner: String) -> String {
        let replacementString = items.count > 0 ? "\n" + items.joinWithSeparator("\n") + "\n" : ""
        return replacementString;
    }
    
    private func writeContents(fileContents: NSMutableString, inFolder pathToFilder:String, withType type: Filetype) {
        let fileURL = self.urlFor(type, inFolder: pathToFilder)
        do {
            try fileContents.writeToURL(fileURL, atomically: true, encoding: NSUTF8StringEncoding)
        } catch _ {
        }
    }
    
    private func templateFor(type: Filetype) -> NSMutableString {
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
    
    private func urlFor(type: Filetype, inFolder pathToFilder: String) -> NSURL {
        let fullClassName = self.fullClassName()
        let directoryURL = NSURL(fileURLWithPath: pathToFilder, isDirectory: true)
        let fileURL = directoryURL.URLByAppendingPathComponent(fullClassName).URLByAppendingPathExtension(type.rawValue)
        print(fileURL)
        return fileURL
    }
    
    
    //MARK: Getters
    private func fullClassName() -> String {
        return self.writingClassPrefix + self.writingClassName
    }
    
    private func copyrightYear() -> String {
        return dateFormatter.stringFromDate(NSDate())
    }
    
    private func authorName() -> String {
        return NSFullUserName()
    }
    
    private func companyName() -> String {
        let person = ABAddressBook.sharedAddressBook().me()
        if let me = person {
            if let company = me.valueForProperty(kABOrganizationProperty) as? String {
                return company
            }
        }
        return "_My_Company_"
    }
    
}


private class ObjectiveCWriter: ClassWriter {
    
    override func writeFilesTo(directory directoryPath: String, forwardDeclarations: [String], propertyDeclarations: [String], importStatements: [String], keyMap: [String]) {
        let hFileContents = self.templateFor(.ObjectiveC_H)
        
        let mFileContents = self.templateFor(.ObjectiveC_M)
        
        let forwardDeclarationsString = self.replacementFor(forwardDeclarations, joiner: "\n")
        hFileContents.replaceOccurrencesOfString(kForwardDeclarationsPlaceholder, withString: forwardDeclarationsString)
        
        let propertyDeclarationsString = self.replacementFor(propertyDeclarations, joiner: "\n")
        hFileContents.replaceOccurrencesOfString(kPropertyDeclarationsPlaceholder, withString: propertyDeclarationsString)
        
        let importStatementsString = self.replacementFor(importStatements, joiner: "\n")
        mFileContents.replaceOccurrencesOfString(kImportsPlaceholder, withString: importStatementsString)
        
        let keyMapString = self.replacementFor(keyMap, joiner: ",\n")
        mFileContents.replaceOccurrencesOfString(kKeymapperPlaceholder, withString: keyMapString)
        
        
        self.writeContents(hFileContents, inFolder: directoryPath, withType: .ObjectiveC_H)
        self.writeContents(mFileContents, inFolder: directoryPath, withType: .ObjectiveC_M)
    }
    
    private override func propertyInfo(forKey key: String,  value: AnyObject, owner: String?) -> PropertyInfo {
        return PropertyInfo.info(forType: .ObjectiveC, key: key, value: value, owner: owner)
    }
}

private class SwiftWriter: ClassWriter {
    override func writeFilesTo(directory directoryPath: String, forwardDeclarations: [String], propertyDeclarations: [String], importStatements: [String], keyMap: [String]) {
        let swiftFileContents = self.templateFor(.Swift)

//        let forwardDeclarationsString = self.replacementFor(forwardDeclarations, joiner: "\n")
//        swiftFileContents.replaceOccurrencesOfString(kForwardDeclarationsPlaceholder, withString: forwardDeclarationsString)
        
        let propertyDeclarationsString = self.replacementFor(propertyDeclarations, joiner: "\n")
        swiftFileContents.replaceOccurrencesOfString(kPropertyDeclarationsPlaceholder, withString: propertyDeclarationsString)
        
        self.writeContents(swiftFileContents, inFolder: directoryPath, withType: .Swift)
        
    }
    
    private override func propertyInfo(forKey key: String,  value: AnyObject, owner: String?) -> PropertyInfo {
        return PropertyInfo.info(forType: .Swift, key: key, value: value, owner: owner)
    }
}