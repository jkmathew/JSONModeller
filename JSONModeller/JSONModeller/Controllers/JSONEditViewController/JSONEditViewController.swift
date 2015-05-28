//
//  JSONEditViewController.swift
//  JSONModeller
//
//  Created by Johnykutty on 28/05/15.
//  Copyright (c) 2015 Johnykutty. All rights reserved.
//

import Cocoa

class JSONEditViewController: NSViewController {

    @IBOutlet var jsonTextView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func generateFiles(sender: AnyObject) {
        
        let openPanel = NSOpenPanel()
        openPanel.canChooseDirectories = true
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
        println(path)
       
    }
}
