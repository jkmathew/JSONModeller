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

public enum Languagetype : Int {
    case objectiveC = 0, swift = 1
}

private let dateFormatter = DateFormatter()

class ClassWriter: NSObject {
    var writingClassName: String
    var writingClassPrefix: String
    var writingClassData: NSDictionary
    
    
    override class func initialize () {
        dateFormatter.dateFormat = "yyyy"
        dateFormatter.locale = Locale.current
    }
    
    class func writer(forType type:Languagetype, writingClassName: String, forData: NSDictionary) -> ClassWriter {
        if type == .swift {
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
    func writeFiles(_ directory:String) {
        
        var propertyDeclarations = [String]()
        var forwardDeclarations = [String]()
        var importStatements = [String]()
        var keyMap = [String]()
        for (key, value) in self.writingClassData {
            let info = propertyInfo(forKey: key as! String, value: value as AnyObject, owner: self.writingClassName)
            if info.isCustomClass {
                forwardDeclarations.append(info.forwardClassDeclaration)
                importStatements.append(info.importStatement)

                let writer = type(of: self).init(writingClassName: info.elementTypeName, forData: info.customElement as! NSDictionary)
                writer.writeFiles(directory)
            }
            if let map = info.keyMapItem {
                keyMap.append(map)
            }
            propertyDeclarations.append(info.propertyDeclaration)
        }
        
        writeFilesTo(directory: directory, forwardDeclarations: forwardDeclarations, propertyDeclarations: propertyDeclarations, importStatements: importStatements, keyMap: keyMap)
        
    }
    
    fileprivate func propertyInfo(forKey key: String,  value: AnyObject, owner: String?) -> PropertyInfo {
        fatalError("implement in subclass")
    }
    
    fileprivate func writeFilesTo(directory directoryPath: String, forwardDeclarations: [String], propertyDeclarations: [String], importStatements: [String], keyMap: [String]) {
        fatalError("implement in subclass")
    }
    
    fileprivate func replacementFor(_ items: [String], joiner: String) -> String {
        let replacementString = items.count > 0 ? "\n" + items.joined(separator: joiner) + "\n" : ""
        return replacementString;
    }
    
    fileprivate func writeContents(_ fileContents: NSMutableString, inFolder pathToFilder:String, withType type: Filetype) {
        let fileURL = self.urlFor(type, inFolder: pathToFilder)
        do {
            try fileContents.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8.rawValue)
        } catch _ {
        }
    }
    
    fileprivate func templateFor(_ type: Filetype) -> NSMutableString {
        let path = Bundle.main.path(forResource: type.rawValue, ofType: "filetemplate")
        let fileContents: NSMutableString
        do {
            fileContents = try NSMutableString(contentsOfFile:path!, encoding: String.Encoding.utf8.rawValue)
        } catch _ as NSError {
            fileContents = NSMutableString(string: "")
        }
        
        let createdOnDateString = DateFormatter.localizedString(from: Date(), dateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.none)
        let copyrightYear = self.copyrightYear()

        let authorName = self.authorName()
        let companyName = self.companyName()
        
        let fullClassName = self.fullClassName()
        
        _ = fileContents.replaceOccurrencesOfString(kClassNamePlaceholder, withString: fullClassName)
        _ = fileContents.replaceOccurrencesOfString(kCreatedDatePlaceholder, withString: createdOnDateString)
        _ = fileContents.replaceOccurrencesOfString(kCopyrightYearPlaceholder, withString: copyrightYear)
        _ = fileContents.replaceOccurrencesOfString(kAuthorNamePlaceholder, withString: authorName)
        _ = fileContents.replaceOccurrencesOfString(kCompanyNamePlaceholder, withString: companyName)
        
        return fileContents
    }
    
    fileprivate func urlFor(_ type: Filetype, inFolder pathToFilder: String) -> URL {
        let fullClassName = self.fullClassName()
        let directoryURL = URL(fileURLWithPath: pathToFilder, isDirectory: true)
        let fileURL = directoryURL.appendingPathComponent(fullClassName).appendingPathExtension(type.rawValue)
        print(fileURL)
        return fileURL
    }
    
    
    //MARK: Getters
    fileprivate func fullClassName() -> String {
        return self.writingClassPrefix + self.writingClassName
    }
    
    fileprivate func copyrightYear() -> String {
        return dateFormatter.string(from: Date())
    }
    
    fileprivate func authorName() -> String {
        return NSFullUserName()
    }
    
    fileprivate func companyName() -> String {
        let person = ABAddressBook.shared().me()
        if let me = person {
            if let company = me.value(forProperty: kABOrganizationProperty) as? String {
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
        _ = hFileContents.replaceOccurrencesOfString(kForwardDeclarationsPlaceholder, withString: forwardDeclarationsString)
        
        let propertyDeclarationsString = self.replacementFor(propertyDeclarations, joiner: "\n")
        _ = hFileContents.replaceOccurrencesOfString(kPropertyDeclarationsPlaceholder, withString: propertyDeclarationsString)
        
        let importStatementsString = self.replacementFor(importStatements, joiner: "\n")
        _ = mFileContents.replaceOccurrencesOfString(kImportsPlaceholder, withString: importStatementsString)
        
        let keyMapString = self.replacementFor(keyMap, joiner: ",\n")
        _ = mFileContents.replaceOccurrencesOfString(kKeymapperPlaceholder, withString: keyMapString)
        
        
        self.writeContents(hFileContents, inFolder: directoryPath, withType: .ObjectiveC_H)
        self.writeContents(mFileContents, inFolder: directoryPath, withType: .ObjectiveC_M)
    }
    
    fileprivate override func propertyInfo(forKey key: String,  value: AnyObject, owner: String?) -> PropertyInfo {
        return PropertyInfo.info(forType: .objectiveC, key: key, value: value, owner: owner)
    }
}

private class SwiftWriter: ClassWriter {
    override func writeFilesTo(directory directoryPath: String, forwardDeclarations: [String], propertyDeclarations: [String], importStatements: [String], keyMap: [String]) {
        let swiftFileContents = self.templateFor(.Swift)
        
        let propertyDeclarationsString = self.replacementFor(propertyDeclarations, joiner: "\n")
        _ = swiftFileContents.replaceOccurrencesOfString(kPropertyDeclarationsPlaceholder, withString: propertyDeclarationsString)

        let keyMapString = self.replacementFor(keyMap, joiner: ",\n")
        _ = swiftFileContents.replaceOccurrencesOfString(kKeymapperPlaceholder, withString: keyMapString)
        
        _ = self.writeContents(swiftFileContents, inFolder: directoryPath, withType: .Swift)
        
    }
    
    fileprivate override func propertyInfo(forKey key: String,  value: AnyObject, owner: String?) -> PropertyInfo {
        return PropertyInfo.info(forType: .swift, key: key, value: value, owner: owner)
    }
}
