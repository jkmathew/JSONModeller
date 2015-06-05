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
    
    
    func writeFiles(directory:String) {
        let hFileContents = self.templateFor(Filetype.ObjectiveC_H)

        let mFileContents = self.templateFor(Filetype.ObjectiveC_M)
        
        let creator = PropertyInfo()
        for (key, value) in self.writingClassData {
            let creator = PropertyInfo(key: key as! String, value: value)
        }
       
        self.writeContents(hFileContents, inFolder: directory, withType: Filetype.ObjectiveC_H)
        self.writeContents(mFileContents, inFolder: directory, withType: Filetype.ObjectiveC_M)
        
    }
    
    func writeContents(fileContents: NSMutableString, inFolder pathToFilder:String, withType type: Filetype) {
        let filePath = self.pathFor(type, inFolder: pathToFilder)
        fileContents.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
    }
    
    func templateFor(type: Filetype) -> NSMutableString {
        let path = NSBundle.mainBundle().pathForResource(type.rawValue, ofType: "filetemplate")
        let fileContents = NSMutableString(contentsOfFile: path!)
        
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
        
        return fileContents!
    }
    
    func pathFor(type: Filetype, inFolder pathToFilder: String) -> String {
        let fullClassName = self.fullClassName()
        let filePath = pathToFilder.stringByAppendingPathComponent(fullClassName).stringByAppendingPathExtension(type.rawValue)
        println(filePath)
        return filePath!
    }
    
    
    //MARK: Getters
    func fullClassName() -> String {
        return self.writingClassPrefix + self.writingClassName
    }
    
    func copyrightYear() -> String {
        return dateFormatter.stringFromDate(NSDate())
    }
    
    func authorName() -> String {
        if let autherName = NSFullUserName(){
            return autherName
        }
        return "User_name"
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
