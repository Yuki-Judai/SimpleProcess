//
//  ViewController.swift
//  SimpleProcess
//
//  Created by THotaru on 2018/9/6.
//  Copyright © 2018年 THotaru. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var tableView: NSTableView!
    
    private let workspace : NSWorkspace = NSWorkspace.shared
    internal var appsDataArray : [AppDataModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.addCurrentRunningApplicationsDatas()
        
        self.workspace.notificationCenter.addObserver(self, selector: #selector(didLaunchOrTerminateApplication), name: NSWorkspace.didLaunchApplicationNotification, object: nil)
        self.workspace.notificationCenter.addObserver(self, selector: #selector(didLaunchOrTerminateApplication), name: NSWorkspace.didTerminateApplicationNotification, object: nil)
        
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func addCurrentRunningApplicationsDatas() {
        
        let runningApps : [NSRunningApplication] = self.workspace.runningApplications
        
        for app : NSRunningApplication in runningApps {
            let appData : AppDataModel = AppDataModel(bundleURL: app.bundleURL, icon: app.icon, localizedName: app.localizedName, launchDate: app.launchDate, processIdentifier: app.processIdentifier)
            
            self.appsDataArray.append(appData)
        }
        
        self.appsDataArray.sort { (pre, cur) -> Bool in
            guard pre.localizedName != nil && cur.localizedName != nil else {
                return pre.processIdentifier < cur.processIdentifier
            }
            return pre.localizedName! < cur.localizedName!
        }
        self.tableView.reloadData()
    }
    
    func switchStopProcessBtnState() {
        if let windowController : WindowController = self.view.window?.windowController as? WindowController {
            if self.tableView.selectedRow != -1 {
                windowController.stopProcessBtn.isEnabled = true
            }
            else {
                windowController.stopProcessBtn.isEnabled = false
            }
        }
    }
    
    @objc func didLaunchOrTerminateApplication(noti : NSNotification) {
        self.appsDataArray.removeAll()
        self.addCurrentRunningApplicationsDatas()
        switchStopProcessBtnState()
    }
    
}

extension ViewController {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.appsDataArray.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let appIconAndNameCellView : NSTableCellView? = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier.init("appIconAndNameCellView"), owner: self) as? NSTableCellView
        let appLaunchTimeCellView : NSTableCellView? = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier.init("appLaunchTimeCellView"), owner: self) as? NSTableCellView
        let appPIDCellView : NSTableCellView? = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier.init("appPIDCellView"), owner: self) as? NSTableCellView
        
        let appData : AppDataModel = self.appsDataArray[row]
        
        switch tableColumn?.identifier {
            
        case NSUserInterfaceItemIdentifier.init("appIconAndNameColumn"):
            
            appIconAndNameCellView?.imageView?.image = appData.icon
            appIconAndNameCellView?.textField?.stringValue = appData.localizedName ?? ""
            appIconAndNameCellView?.toolTip = appData.bundleURL?.path
            
            return appIconAndNameCellView
            
        case NSUserInterfaceItemIdentifier.init("appLaunchTimeColumn"):
            
            let dateFormatter : DateFormatter = DateFormatter()
            dateFormatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd HH:mm:ss zzz")
            
            let currentDateString : String?
            if let launchDate = appData.launchDate {
                currentDateString = dateFormatter.string(from: launchDate)
                appLaunchTimeCellView?.textField?.stringValue = currentDateString ?? ""
            }
            
            return appLaunchTimeCellView
            
        case NSUserInterfaceItemIdentifier.init("appPIDColumn"):
            
            appPIDCellView?.textField?.stringValue = String(stringInterpolationSegment: appData.processIdentifier)
            
            return appPIDCellView
            
        default:
            return nil
        }
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        switchStopProcessBtnState()
    }
    
}
