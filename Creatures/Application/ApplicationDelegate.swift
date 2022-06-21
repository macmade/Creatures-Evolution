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

@main public class ApplicationDelegate: NSObject, NSApplicationDelegate
{
    @objc public private( set ) dynamic var aboutWindowController   = AboutWindowController()
    @objc public private( set ) dynamic var creditsWindowController = CreditsWindowController()
    @objc public private( set ) dynamic var mainWindowController    = MainWindowController()
    
    public func applicationDidFinishLaunching( _ notification: Notification )
    {
        self.mainWindowController.show( nil )
    }
    
    public func applicationWillTerminate( _ notification: Notification )
    {
        try? self.mainWindowController.settings?.save()
    }
    
    public func applicationSupportsSecureRestorableState( _ app: NSApplication ) -> Bool
    {
        return false
    }
    
    public func applicationShouldTerminateAfterLastWindowClosed( _ sender: NSApplication ) -> Bool
    {
        true
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
    
    @IBAction public func reset( _ sender: Any? )
    {
        self.mainWindowController.reset( sender )
    }
    
    @IBAction public func togglePause( _ sender: Any? )
    {
        self.mainWindowController.togglePause( sender )
    }
    
    @IBAction public func pause( _ sender: Any? )
    {
        self.mainWindowController.pause( sender )
    }
    
    @IBAction public func resume( _ sender: Any? )
    {
        self.mainWindowController.resume( sender )
    }
    
    @IBAction public func toggleFPS( _ sender: Any? )
    {
        self.mainWindowController.toggleFPS( sender )
    }
    
    @IBAction public func toggleDrawCount( _ sender: Any? )
    {
        self.mainWindowController.toggleDrawCount( sender )
    }
    
    @IBAction public func toggleNodeCount( _ sender: Any? )
    {
        self.mainWindowController.toggleNodeCount( sender )
    }
    
    @IBAction public func toggleQuadCount( _ sender: Any? )
    {
        self.mainWindowController.toggleQuadCount( sender )
    }
    
    @IBAction public func viewEventLog( _ sender: Any? )
    {
        self.mainWindowController.viewEventLog( sender )
    }
    
    @IBAction public func toggleCreaturesNames( _ sender: Any? )
    {
        self.mainWindowController.toggleCreaturesNames( sender )
    }
}
