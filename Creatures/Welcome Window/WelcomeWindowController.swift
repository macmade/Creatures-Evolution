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

public class WelcomeWindowController: NSWindowController, NSTableViewDelegate, NSTableViewDataSource
{
    @objc private dynamic var tips: [ WelcomeTipItem ] = []
    
    @IBOutlet private var tipsController: NSArrayController!
    
    public override var windowNibName: NSNib.Name?
    {
        "WelcomeWindowController"
    }
    
    public override func windowDidLoad()
    {
        super.windowDidLoad()
        
        self.tips =
        [
            WelcomeTipItem( title: "Statistics",    text: "View a complete genetic analysis by using the statistics window.", symbol: "chart.line.uptrend.xyaxis" ),
            WelcomeTipItem( title: "View Details",  text: "Get detailed informations and edit creatures by clicking on them.",       symbol: "eye" ),
            WelcomeTipItem( title: "Customization", text: "Most parameters of the simulation can be customized in the settings.",    symbol: "slider.horizontal.3" ),
            WelcomeTipItem( title: "Save Settings", text: "Settings can be saved an restored at any time from the settings window.", symbol: "arrow.down.doc.fill" ),
        ]
    }
    
    @IBAction private func start( _ sender: Any? )
    {
        guard let delegate = NSApp.delegate as? ApplicationDelegate else
        {
            NSSound.beep()
            
            return
        }
        
        delegate.showMainWindow( customizeSettings: false )
        self.window?.performClose( sender )
    }
    
    @IBAction private func customizeSettings( _ sender: Any? )
    {
        guard let delegate = NSApp.delegate as? ApplicationDelegate else
        {
            NSSound.beep()
            
            return
        }
        
        delegate.showMainWindow( customizeSettings: true )
        self.window?.performClose( sender )
    }
    
    public func tableView( _ tableView: NSTableView, shouldSelectRow row: Int ) -> Bool
    {
        false
    }
}
