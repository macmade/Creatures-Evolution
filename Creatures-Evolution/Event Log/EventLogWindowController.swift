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

public class EventLogWindowController: NSWindowController, NSTableViewDelegate, NSTableViewDataSource, NSWindowDelegate
{
    @objc private dynamic var log      = EventLog.shared
    @objc private dynamic var isPaused = false
    @objc private dynamic var events   = [ Event ]()
    @objc private dynamic var settings:  Settings
    
    @IBOutlet private var eventsController: NSArrayController!
    @IBOutlet private var searchField:      NSSearchField!
    @IBOutlet private var stackView:        NSStackView!
    
    private var pauseObserver: NSKeyValueObservation?
    private var updateTimer:   Timer?
    
    public init( settings: Settings )
    {
        self.settings = settings
        
        super.init( window: nil )
    }
    
    required init?( coder: NSCoder )
    {
        nil
    }
    
    deinit
    {
        self.updateTimer?.invalidate()
    }
    
    public override var windowNibName: NSNib.Name?
    {
        "EventLogWindowController"
    }
    
    public override func windowDidLoad()
    {
        super.windowDidLoad()
        
        self.window?.delegate = self
        
        if Preferences.shared.firstLaunch
        {
            self.window?.center()
        }
        
        self.eventsController.sortDescriptors =
        [
            NSSortDescriptor( key: "time",  ascending: false ),
            NSSortDescriptor( key: "index", ascending: false )
        ]
        
        guard let delegate             = NSApp.delegate as? ApplicationDelegate,
              let mainWindowController = delegate.mainWindowController
        else
        {
            return
        }
        
        self.updateTimer = Timer.scheduledTimer( withTimeInterval: 1, repeats: true )
        {
            [ weak self ] _ in self?.update()
        }
        
        self.pauseObserver = mainWindowController.observe( \.isPaused )
        {
            [ weak self ] _, _ in self?.isPaused = mainWindowController.isPaused
        }
        
        self.isPaused = mainWindowController.isPaused
        
        self.focusSearchField()
        self.update()
        
        let keyPaths: [ ( String, WritableKeyPath< Settings, Bool > )? ] =
        [
            ( "Mutations",        \.eventLog.logMutations ),
            ( "Births",           \.eventLog.logBirths ),
            ( "Deaths",           \.eventLog.logDeaths ),
            ( "Kills",            \.eventLog.logKills ),
            ( "Combats",          \.eventLog.logCombats ),
            ( "Energy Transfers", \.eventLog.logEnergyTransfers ),
            ( "Energy Changes",   \.eventLog.logEnergyChanges ),
        ]
        .sorted
        {
            $0.0 < $1.0
        }
        
        let views: [ NSView ] = [ keyPaths ].map
        {
            let stack                 = NSStackView()
            stack.orientation         = .horizontal
            stack.distribution        = .equalSpacing
            stack.alignment           = .centerY
            stack.spacing             = 8
            stack.detachesHiddenViews = true
            
            let views: [ NSView ] = $0.compactMap
            {
                guard let value = $0 else
                {
                    return nil
                }
                
                let checkbox                     = NSButton( checkboxWithTitle: value.0, target: self, action: #selector( toggleEvent( _: ) ) )
                checkbox.controlSize             = .small
                checkbox.state                   = self.settings[ keyPath: value.1 ] ? .on : .off
                checkbox.cell?.representedObject = value.1
                
                return checkbox
            }
            
            stack.setViews( views, in: .leading )
            
            return stack
        }
        
        self.stackView.setViews( views, in: .leading )
    }
    
    @IBAction private func toggleEvent( _ sender: Any? )
    {
        guard let button = sender as? NSButton,
              let keyPath = button.cell?.representedObject as? WritableKeyPath< Settings, Bool >
        else
        {
            NSSound.beep()
            
            return
        }
        
        self.settings[ keyPath: keyPath ] = self.settings[ keyPath: keyPath ] == false
    }
    
    private func update()
    {
        self.events = self.log.events
    }
    
    @IBAction @objc public func showNode( _ event: Event )
    {
        guard let node                 = event.node     as? SpriteNode,
              let delegate             = NSApp.delegate as? ApplicationDelegate,
              let mainWindowController = delegate.mainWindowController
        else
        {
            NSSound.beep()
            
            return
        }
        
        if mainWindowController.detailViewController?.node == node
        {
            mainWindowController.hideDetails( nil )
        }
        else
        {
            mainWindowController.showDetails( node: node )
        }
    }
    
    @IBAction @objc public func pause( _ sender: Any? )
    {
        guard let delegate             = NSApp.delegate as? ApplicationDelegate,
              let mainWindowController = delegate.mainWindowController
        else
        {
            NSSound.beep()
            
            return
        }
        
        mainWindowController.pause( nil )
    }
    
    @IBAction @objc public func resume( _ sender: Any? )
    {
        guard let delegate             = NSApp.delegate as? ApplicationDelegate,
              let mainWindowController = delegate.mainWindowController
        else
        {
            NSSound.beep()
            
            return
        }
        
        mainWindowController.resume( nil )
    }
    
    @IBAction @objc public func clear( _ sender: Any? )
    {
        self.log.clear()
    }
    
    @IBAction public func performFindPanelAction( _ sender: Any? )
    {
        self.focusSearchField()
    }
    
    public func focusSearchField()
    {
        self.window?.makeFirstResponder( self.searchField )
    }
    
    public func windowDidBecomeKey( _ notification: Notification )
    {
        if notification.object as? NSWindow == self.window
        {
            Preferences.shared.openEventLog = true
        }
    }
    
    public func windowWillClose( _ notification: Notification )
    {
        if let delegate = NSApp.delegate as? ApplicationDelegate, delegate.exiting
        {
            return
        }
        
        if notification.object as? NSWindow == self.window
        {
            Preferences.shared.openEventLog = false
        }
    }
}
