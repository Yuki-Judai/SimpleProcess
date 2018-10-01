//
//  WindowController.swift
//  SimpleProcess
//
//  Created by THotaru on 2018/9/7.
//  Copyright © 2018年 THotaru. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
    
    @IBOutlet weak var stopProcessBtn: NSButton!
    internal var vc : ViewController!

    @IBAction func handleStopProcess(_ sender: NSButton) {
        
        vc = (self.contentViewController as! ViewController)
        
        let selectedRow : Int = vc.tableView.selectedRow
        
        let app : AppDataModel? = vc.appsDataArray[selectedRow]
            
        let alert : NSAlert = NSAlert()
        alert.informativeText = "Do you want to kill the process ?"
        alert.messageText = "Warnning"
        alert.alertStyle = .warning
        
        alert.addButton(withTitle: "Yes")
        alert.addButton(withTitle: "No")
        
        alert.beginSheetModal(for: self.window!) { (modalResponse : NSApplication.ModalResponse) in
                if modalResponse.rawValue == 1000 {
                    kill((app?.processIdentifier)!, SIGKILL)
                    self.vc.appsDataArray.remove(at: selectedRow)
                    self.vc.tableView.reloadData()
                }
            }
        
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }

}
