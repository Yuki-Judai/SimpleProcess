//
//  AppsDataModel.swift
//  SimpleProcess
//
//  Created by THotaru on 2018/9/6.
//  Copyright © 2018年 THotaru. All rights reserved.
//

import Cocoa

struct AppDataModel {
    
    let bundleURL : URL?
    let icon : NSImage?
    let localizedName : String?
    let launchDate : Date?
    let processIdentifier : pid_t
    
    init(bundleURL : URL?, icon : NSImage?, localizedName : String?, launchDate : Date?, processIdentifier : pid_t) {
        
        self.bundleURL = bundleURL
        self.icon = icon
        self.localizedName = localizedName
        self.launchDate = launchDate
        self.processIdentifier = processIdentifier
    }
    
}
