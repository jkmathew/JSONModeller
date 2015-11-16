//
//  SaveAccessoryView.swift
//  JSONModeller
//
//  Created by Johnykutty on 28/05/15.
//  Copyright (c) 2015 Johnykutty.All rights reserved.
//

import Cocoa

class SaveAccessoryView :  NSView {

    private var useCoreDataButton: NSButton
    private var rootClassNameField: NSTextField
    private var classPrefixField: NSTextField
    private var languageSelector: NSPopUpButton
    override init(frame frameRect: NSRect) {
        
        var y: CGFloat = 0.0
        let labelX: CGFloat = 0.0
        let fieldX: CGFloat = 117.0
        
        self.useCoreDataButton = NSButton(frame: NSMakeRect(fieldX, y, 350.0, 22.0))
        self.useCoreDataButton.setButtonType(.SwitchButton)
        self.useCoreDataButton.bezelStyle = .SmallSquareBezelStyle
        self.useCoreDataButton.title = "Use core data - (currently unavailable)"
        self.useCoreDataButton.enabled = false
       
        y += 30.0
        self.languageSelector = NSPopUpButton(frame: NSMakeRect(fieldX, y, 150, 25))
        self.languageSelector.addItemsWithTitles(["Objective C", "Swift"])
        
        y += 5.0
        let languageLabel = NSTextField(frame: NSMakeRect(labelX, y, 115, 17))
        languageLabel.stringValue = "Language :"
        languageLabel.bezeled = false
        languageLabel.drawsBackground = false
        languageLabel.editable = false
        languageLabel.selectable = false
        languageLabel.alignment = .Right
        
        y += 30.0
        self.classPrefixField = NSTextField(frame: NSMakeRect(fieldX, y, 150, 21))
        (self.classPrefixField.cell as! NSTextFieldCell).placeholderString = "CP"
        (self.classPrefixField.cell as! NSTextFieldCell).stringValue = ""
        
        y += 3.0
        let classPrefixLabel = NSTextField(frame: NSMakeRect(labelX, y, 115, 17))
        classPrefixLabel.stringValue = "Class Prefix :"
        classPrefixLabel.bezeled = false
        classPrefixLabel.drawsBackground = false
        classPrefixLabel.editable = false
        classPrefixLabel.selectable = false
        classPrefixLabel.alignment = .Right
        
        y += 30.0
        self.rootClassNameField = NSTextField(frame: NSMakeRect(fieldX, y, 150, 21))
        (self.rootClassNameField.cell as! NSTextFieldCell).placeholderString = "RootClass"
        (self.rootClassNameField.cell as! NSTextFieldCell).stringValue = ""

        y += 3.0
        let rootClassLabel = NSTextField(frame: NSMakeRect(labelX, y, 115, 17))
        rootClassLabel.stringValue = "Root Class Name :"
        rootClassLabel.bezeled = false
        rootClassLabel.drawsBackground = false
        rootClassLabel.editable = false
        rootClassLabel.selectable = false
        rootClassLabel.alignment = .Right
        
        super.init(frame: frameRect)
        self.useCoreDataButton.target = self
        self.addSubview(self.useCoreDataButton)
        self.addSubview(self.languageSelector)
        self.addSubview(languageLabel)
        self.addSubview(self.classPrefixField)
        self.addSubview(classPrefixLabel)
        self.addSubview(self.rootClassNameField)
        self.addSubview(rootClassLabel)
        
        
    }
    
    func rootClassName() -> String {
        
        return (self.rootClassNameField.stringValue.characters.count == 0) ? "RootClass" : self.rootClassNameField.stringValue
    }
    
    func clasPrefix() -> String {
        return self.classPrefixField.stringValue
    }

    func language() -> Languagetype {
        return Languagetype(rawValue: languageSelector.indexOfSelectedItem)!
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
}
