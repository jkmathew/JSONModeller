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
    
    func writeFiles(toPath:String) {
        let hFile = self.templateFor(Filetype.ObjectiveC_H)

        let mFile = self.templateFor(Filetype.ObjectiveC_M)
        
        for (key, value) in self.writingClassData {
            println("key: \"\(key )\"")
            println("value: \"\(value )\"")
        }
       
        let hFilePath = self.filePathFor(Filetype.ObjectiveC_H, toPath: toPath)
        hFile.writeToFile(hFilePath, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
    }
    
    func templateFor(fileType: Filetype) -> NSMutableString {
        let path = NSBundle.mainBundle().pathForResource(fileType.rawValue, ofType: "filetemplate")
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
    
    func filePathFor(fileType: Filetype, toPath:String) -> String {
        let fullClassName = self.fullClassName()
        let filePath = toPath + "/" + fullClassName + "." + fileType.rawValue
        println(filePath)
        return filePath
    }
    
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
