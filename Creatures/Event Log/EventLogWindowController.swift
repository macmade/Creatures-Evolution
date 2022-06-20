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
import SpriteKit

public class EventLogWindowController: NSWindowController, NSTableViewDelegate, NSTableViewDataSource
{
    @objc private dynamic var log = EventLog.shared
    
    @IBOutlet private var eventsController: NSArrayController!
    
    public override var windowNibName: NSNib.Name?
    {
        "EventLogWindowController"
    }
    
    public override func windowDidLoad()
    {
        super.windowDidLoad()
        
        self.eventsController.sortDescriptors = [ NSSortDescriptor( key: "time", ascending: false ) ]
    }
    
    @IBAction @objc public func showNode( _ event: Event )
    {
        guard let delegate = NSApp.delegate as? ApplicationDelegate, let node = event.node as? SpriteNode else
        {
            NSSound.beep()
            
            return
        }
        
        delegate.mainWindowController.showDetails( node: node )
    }
    
    @IBAction @objc public func clear( _ sender: Any? )
    {
        self.log.clear()
    }
}
