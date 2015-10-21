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
    override init(frame frameRect: NSRect) {
        
     
        
        self.useCoreDataButton = NSButton(frame: NSMakeRect(117, 0.0, 324.0, 22.0))
        self.useCoreDataButton.setButtonType(.SwitchButton)
        self.useCoreDataButton.bezelStyle = .SmallSquareBezelStyle
        self.useCoreDataButton.title = "Use core data"
       
         
        self.rootClassNameField = NSTextField(frame: NSMakeRect(117, 65, 150, 21))
        (self.rootClassNameField.cell as! NSTextFieldCell).placeholderString = "RootClass"
        (self.rootClassNameField.cell as! NSTextFieldCell).stringValue = ""

        let rootClassLabel = NSTextField(frame: NSMakeRect(0, 67, 115, 17))
        rootClassLabel.stringValue = "Root Class Name :"
        rootClassLabel.bezeled = false
        rootClassLabel.drawsBackground = false
        rootClassLabel.editable = false
        rootClassLabel.selectable = false
        rootClassLabel.alignment = .Right
        
        
        self.classPrefixField = NSTextField(frame: NSMakeRect(117, 30, 150, 21))
        (self.classPrefixField.cell as! NSTextFieldCell).placeholderString = "CP"
        (self.classPrefixField.cell as! NSTextFieldCell).stringValue = ""
        
        let classPrefixLabel = NSTextField(frame: NSMakeRect(0, 32, 115, 17))
        classPrefixLabel.stringValue = "Class Prefix :"
        classPrefixLabel.bezeled = false
        classPrefixLabel.drawsBackground = false
        classPrefixLabel.editable = false
        classPrefixLabel.selectable = false
        classPrefixLabel.alignment = .Right
        
        super.init(frame: frameRect)
        self.useCoreDataButton.target = self
        self.addSubview(self.useCoreDataButton)
        self.addSubview(self.rootClassNameField)
        self.addSubview(rootClassLabel)
        self.addSubview(self.classPrefixField)
        self.addSubview(classPrefixLabel)
        
    }
    
    func rootClassName() -> String {
        
        return (self.rootClassNameField.stringValue.characters.count == 0) ? "RootClass" : self.rootClassNameField.stringValue
    }
    
    func clasPrefix() -> String {
        return self.classPrefixField.stringValue
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
}
