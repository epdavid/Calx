//
//  AppDelegate.swift
//  Calx
//
//  Created by Evan David on 8/1/18.
//  Copyright © 2018 Evan David. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    static let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    public static var popover = NSPopover()
    var eventMonitor: EventMonitor?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if let button = AppDelegate.statusItem.button {
            button.image = NSImage(named: NSImage.Name("calxicon40"))
            button.action = #selector(togglePopover(_:))
        }
        AppDelegate.popover.contentViewController = ViewController.freshController()
        
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let strongSelf = self, AppDelegate.popover.isShown {
                strongSelf.closePopover(sender: event)
            }
        }
    }
    
    public static func getButton() -> NSView {
        let button = AppDelegate.statusItem.button
        return button!
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func togglePopover(_ sender: Any?) {
        if AppDelegate.popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
            NSApplication.shared.activate(ignoringOtherApps: true)
        }
    }
    
    func showPopover(sender: Any?) {
        if let button = AppDelegate.statusItem.button {
            AppDelegate.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
        eventMonitor?.start()
    }
    
    func closePopover(sender: Any?) {
        AppDelegate.popover.performClose(sender)
        eventMonitor?.stop()
    }
    
    @IBAction func closeEsc(_ sender: Any) {
        closePopover(sender: sender)
    }
    

}

