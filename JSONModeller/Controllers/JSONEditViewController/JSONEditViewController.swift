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
        validateJSON()
    }
    
    @IBAction func compareJSON(sender: AnyObject) {
        
    }
    
    @IBAction func generateFiles(sender: AnyObject) {
        if !validateJSON() {
            return
        }
        let openPanel = NSOpenPanel()
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = true
        openPanel.canChooseFiles = false
        openPanel.prompt = "Chose Directory"
        let saveAccessoryView = SaveAccessoryView(frame: NSMakeRect(0, 0, 400, 125))
        openPanel.accessoryView = saveAccessoryView
        
        openPanel.beginSheetModalForWindow(self.view.window!, completionHandler: { (result: Int) -> Void in
            if result == NSFileHandlingPanelOKButton, let URL = openPanel.URL{
                let rootClassName = saveAccessoryView.rootClassName()
                let classPrefix = saveAccessoryView.clasPrefix()
                let language = saveAccessoryView.language()
                self.createFilesFilesFor(rootClassName, classPrefix: classPrefix, useCoreData: false, language: language, path: URL.path!)
            }
        })
    }
    
    func createFilesFilesFor(writingClassName: String, classPrefix: String, useCoreData: Bool, language: Languagetype, path: String) {
        print(path)
        if let jsonString = jsonTextView.string where jsonString.characters.count > 0 {
            
            let data: NSData = jsonString.dataUsingEncoding(NSUTF8StringEncoding)!
            
            let anyObj: AnyObject?
            do {
                anyObj = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
            } catch let error as NSError {
                anyObj = nil
                showError(error)
            }
            
            if let dict = anyObj as? NSDictionary {
                let writer =  ClassWriter.writer(forType: language, writingClassName: writingClassName, forData: dict)
                
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
    
    func showError(error: NSError) {
        print(error, terminator: "")
        let description = error.localizedDescription
        let alert = NSAlert()
        alert.messageText = "Error!"
        alert.informativeText = description
        alert.alertStyle = .CriticalAlertStyle
        alert.runModal()
    }
    
    func validateJSON() -> Bool {
        if let error = self.jsonTextView.formatJson() {
            showError(error)
            return false
        }
        return true
    }
}
