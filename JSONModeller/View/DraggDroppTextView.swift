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
                        let jsonText = String(contentsOfFile: fiepath, encoding: NSUTF8StringEncoding, error: nil)
                        self.string = jsonText
                        return true
                    }
                }
            }
        }
        return false
    }
    
}
