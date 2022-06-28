/*******************************************************************************
 * The MIT License (MIT)
 *
 * Copyright (c) 2022 Jean-David Gadina - www.xs-labs.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 ******************************************************************************/

import Cocoa

@main public class ApplicationDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate
{
    @objc public private( set ) dynamic var welcomeWindowController = WelcomeWindowController()
    @objc public private( set ) dynamic var aboutWindowController   = AboutWindowController()
    @objc public private( set ) dynamic var creditsWindowController = CreditsWindowController()
    @objc public private( set ) dynamic var mainWindowController:     MainWindowController?
    
    public private( set ) var exiting = false
    
    public func applicationDidFinishLaunching( _ notification: Notification )
    {
        self.showWelcomeWindow( nil )
    }
    
    public func applicationWillTerminate( _ notification: Notification )
    {
        try? self.mainWindowController?.settings?.save()
        
        self.exiting                   = true
        Preferences.shared.firstLaunch = false
    }
    
    public func applicationSupportsSecureRestorableState( _ app: NSApplication ) -> Bool
    {
        return false
    }
    
    public func applicationShouldTerminateAfterLastWindowClosed( _ sender: NSApplication ) -> Bool
    {
        true
    }
    
    @IBAction public func showWelcomeWindow( _ sender: Any? )
    {
        if self.welcomeWindowController.window?.isVisible == false
        {
            self.welcomeWindowController.window?.layoutIfNeeded()
            self.welcomeWindowController.window?.center()
        }
        
        self.welcomeWindowController.window?.delegate = self
        
        self.welcomeWindowController.window?.makeKeyAndOrderFront( sender )
    }
    
    @IBAction public func showAboutWindow( _ sender: Any? )
    {
        if self.aboutWindowController.window?.isVisible == false
        {
            self.aboutWindowController.window?.layoutIfNeeded()
            self.aboutWindowController.window?.center()
        }
        
        self.aboutWindowController.window?.makeKeyAndOrderFront( sender )
    }
    
    @IBAction public func showCreditsWindow( _ sender: Any? )
    {
        if self.creditsWindowController.window?.isVisible == false
        {
            self.creditsWindowController.window?.layoutIfNeeded()
            self.creditsWindowController.window?.center()
        }
        
        self.creditsWindowController.window?.makeKeyAndOrderFront( sender )
    }
    
    @IBAction public func showMainWindow( customizeSettings: Bool )
    {
        if self.mainWindowController == nil
        {
            self.mainWindowController = MainWindowController()
        }
        
        if self.mainWindowController?.window?.isVisible == false
        {
            self.mainWindowController?.window?.layoutIfNeeded()
        }
            
        self.mainWindowController?.window?.delegate = self
        
        self.mainWindowController?.show( customizeSettings: customizeSettings )
    }
    
    @IBAction public func reset( _ sender: Any? )
    {
        guard let mainWindowController = self.mainWindowController else
        {
            NSSound.beep()
            
            return
        }
        
        mainWindowController.reset( sender )
    }
    
    @IBAction public func togglePause( _ sender: Any? )
    {
        guard let mainWindowController = self.mainWindowController else
        {
            NSSound.beep()
            
            return
        }
        
        mainWindowController.togglePause( sender )
    }
    
    @IBAction public func viewEventLog( _ sender: Any? )
    {
        guard let mainWindowController = self.mainWindowController else
        {
            NSSound.beep()
            
            return
        }
        
        mainWindowController.viewEventLog( sender )
    }
    
    @IBAction public func viewGeneticStatistics( _ sender: Any? )
    {
        guard let mainWindowController = self.mainWindowController else
        {
            NSSound.beep()
            
            return
        }
        
        mainWindowController.viewGeneticStatistics( sender )
    }
    
    @IBAction public func toggleCreaturesNames( _ sender: Any? )
    {
        guard let mainWindowController = self.mainWindowController else
        {
            NSSound.beep()
            
            return
        }
        
        mainWindowController.toggleCreaturesNames( sender )
    }
    
    @IBAction public func killCreatures( _ sender: Any? )
    {
        guard let mainWindowController = self.mainWindowController else
        {
            NSSound.beep()
            
            return
        }
        
        mainWindowController.killCreatures( sender )
    }
    
    public func windowWillClose( _ notification: Notification )
    {
        guard let window = notification.object as? NSWindow else
        {
            return
        }
        
        if window == self.mainWindowController?.window
        {
            NSApp.terminate( nil )
        }
        
        if window == self.welcomeWindowController.window && self.mainWindowController == nil
        {
            NSApp.terminate( nil )
        }
    }
    
    @objc func validateMenuItem( _ menuItem: NSMenuItem ) -> Bool
    {
        if menuItem.action == #selector( reset( _: ) )
        {
            return self.mainWindowController != nil && self.mainWindowController?.window?.sheets.count == 0
        }
        
        if menuItem.action == #selector( togglePause( _: ) )
        {
            return self.mainWindowController != nil && self.mainWindowController?.window?.sheets.count == 0
        }
        
        if menuItem.action == #selector( toggleCreaturesNames( _: ) )
        {
            return self.mainWindowController != nil && self.mainWindowController?.window?.sheets.count == 0
        }
        
        if menuItem.action == #selector( viewEventLog( _: ) )
        {
            return self.mainWindowController != nil && self.mainWindowController?.window?.sheets.count == 0
        }
        
        if menuItem.action == #selector( viewGeneticStatistics( _: ) )
        {
            return self.mainWindowController != nil && self.mainWindowController?.window?.sheets.count == 0
        }
        
        if menuItem.action == #selector( killCreatures( _: ) )
        {
            return self.mainWindowController != nil && self.mainWindowController?.window?.sheets.count == 0
        }
        
        return true
    }
}
