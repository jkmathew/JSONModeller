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
        self.register(forDraggedTypes: [NSFilenamesPboardType])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.registerForDragging()
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let files: AnyObject? = sender.draggingPasteboard().propertyList(forType: NSFilenamesPboardType) as AnyObject?
        if let filePaths = files as? NSArray {
            if filePaths.count == 1 {
                if let fiepath = filePaths.firstObject as? String {
                    Swift.print(fiepath)
                    let fileExtension = URL(fileURLWithPath: fiepath).pathExtension
                    if fileExtension == "json"{
                        let jsonData = try? Data(contentsOf: URL(fileURLWithPath: fiepath))
                        _ = self.setFormattedJsonWithData(jsonData)
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func formatJson() -> NSError? {
        let data = self.string?.data(using: String.Encoding.utf8, allowLossyConversion: true)
        return self.setFormattedJsonWithData(data)
    }
    
    func setFormattedJsonWithData(_ data: Data?) -> NSError? {
        var error: NSError? = nil
        if let validData = data {
            let json: Any?
            do {
                json = try JSONSerialization.jsonObject(with: validData, options: [])
            } catch let error1 as NSError {
                error = error1
                json = nil
            }
            if (error != nil) {
                return error;
            }
            let formattedJSONData: Data?
            do {
                formattedJSONData = try JSONSerialization.data(withJSONObject: json!, options: .prettyPrinted)
            } catch let error1 as NSError {
                error = error1
                formattedJSONData = nil
            }
            if (error != nil) {
                return error;
            }
            let formattedJSONString = NSString(data: formattedJSONData!, encoding: String.Encoding.utf8.rawValue)
            self.string = formattedJSONString as? String
            return error;
        }
        return nil
    }
}
