//
//  JSONEditViewController.swift
//  JSONModeller
//
//  Created by Johnykutty on 28/05/15.
//  Copyright (c) 2015 Johnykutty. All rights reserved.
//

import Cocoa

class JSONEditViewController: NSViewController {

    @IBOutlet var jsonTextView: DraggDroppTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func formatJSON(sender: AnyObject) {
        if let error = self.jsonTextView.formatJson() {
            print(error, terminator: "")
        }
    }
    
    @IBAction func generateFiles(sender: AnyObject) {
        
        let openPanel = NSOpenPanel()
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = true
        openPanel.canChooseFiles = false
        openPanel.prompt = "Chose Directory"
        let saveAccessoryView = SaveAccessoryView(frame: NSMakeRect(0, 0, 300, 100))
        openPanel.accessoryView = saveAccessoryView
        
        openPanel.beginSheetModalForWindow(self.view.window!, completionHandler: { (result: Int) -> Void in
            if result == NSFileHandlingPanelOKButton, let URL = openPanel.URL{
                self.createFilesFilesFor(saveAccessoryView.rootClassName(), classPrefix:saveAccessoryView.clasPrefix(),useCoreData:false, path:URL.path!)
            }
        })
    }
    
    func createFilesFilesFor(writingClassName:String, classPrefix:String, useCoreData:Bool, path:String) {
        print(path)
        if let jsonString = jsonTextView.string where jsonString.characters.count > 0 {
            
            let data: NSData = jsonString.dataUsingEncoding(NSUTF8StringEncoding)!
            var error: NSError?
            
            let anyObj: AnyObject?
            do {
                anyObj = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
            } catch let error1 as NSError {
                error = error1
                anyObj = nil
            }
            print("Error: \(error)")
            
            if let dict = anyObj as? NSDictionary {
                let writer =  ClassWriter.writer(forType: .Swift, writingClassName: writingClassName, forData: dict)
                
                writer.writeFiles(path)
            }
            else {
                //TODO: Handle array case later
                print("Handle array case later")
            }
            
            let showFolder = NSTask()
            showFolder.launchPath = "/usr/bin/open"
            showFolder.arguments = [path]
            showFolder.launch()
        }
    }
    
    
}
