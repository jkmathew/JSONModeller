//
//  DraggDroppTextView.swift
//  JSONModeller
//
//  Created by Johnykutty Mathew on 28/05/15.
//  Copyright (c) 2015 Johnykutty. All rights reserved.
//

import Cocoa

class DraggDroppTextView: NSTextView {
    
    func registerForDragging() {
        self.registerForDraggedTypes([NSFilenamesPboardType])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.registerForDragging()
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
    override func performDragOperation(sender: NSDraggingInfo) -> Bool {
        let files: AnyObject? = sender.draggingPasteboard().propertyListForType(NSFilenamesPboardType)
        
        if let filePaths = files as? NSArray {
            if filePaths.count == 1 {
                if let fiepath = filePaths.firstObject as? String {
                    println(fiepath)
                    let fileExtension = fiepath.pathExtension
                    if fileExtension == "json"{
                        let jsonData = NSData(contentsOfFile: fiepath)
                        self.setFormattedJsonWithData(jsonData)
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func formatJson() -> NSError? {
        let data = self.string?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        return self.setFormattedJsonWithData(data)
    }
    
    func setFormattedJsonWithData(data: NSData?) -> NSError? {
        var error: NSError? = nil
        if let validData = data {
            let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(validData, options: nil, error: &error)
            if (error != nil) {
                return error;
            }
            let formattedJSONData = NSJSONSerialization.dataWithJSONObject(json!, options: .PrettyPrinted, error: &error)
            if (error != nil) {
                return error;
            }
            let formattedJSONString = NSString(data: formattedJSONData!, encoding: NSUTF8StringEncoding)
            self.string = formattedJSONString as? String
            return error;
        }
        return nil
    }
}
