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

public class MainWindowController: NSWindowController
{
    @objc public private( set ) dynamic var scene:                    Scene?
    @objc public private( set ) dynamic var settingsWindowController: SettingsWindowController?
    @objc public private( set ) dynamic var detailViewController:     DetailViewController?
    @objc public private( set ) dynamic var statsViewController:      StatsViewController?
    
    @IBOutlet private var contentView: NSView!
    @IBOutlet private var statsView:   NSView!
    
    private var view:                     SKView?
    private var gameOverObserver:         NSKeyValueObservation?
    private var eventLogWindowController: EventLogWindowController?
    
    @objc public dynamic var isPaused: Bool = false
    {
        didSet
        {
            guard let scene = self.scene else
            {
                NSSound.beep()
                
                return
            }
            
            scene.isPaused = self.isPaused
        }
    }
    
    public override var windowNibName: NSNib.Name?
    {
        "MainWindowController"
    }
    
    public override func windowDidLoad()
    {
        super.windowDidLoad()
    }
    
    @IBAction func show( _ sender: Any? )
    {
        let settingsController              = SettingsWindowController()
        settingsController.showCancelButton = self.scene != nil
        
        guard let window = self.window, let settingsWindow = settingsController.window else
        {
            NSSound.beep()
            
            return
        }
        
        window.center()
        window.makeKeyAndOrderFront( nil )
        window.beginSheet( settingsWindow )
        {
            response in
            
            self.settingsWindowController = nil
            
            if response != .OK, let scene = self.scene
            {
                self.isPaused = scene.isGameOver ? true : false
                
                return
            }
            
            try? settingsController.settings.save()
            
            self.detailViewController?.view.removeFromSuperview()
            
            self.detailViewController = nil
            
            let view              = SKView( frame: self.contentView.bounds )
            let scene             = Scene( size: view.bounds.size, settings: settingsController.settings )
            self.view             = view
            self.scene            = scene
            self.gameOverObserver = scene.observe( \.isGameOver )
            {
                [ weak self ] _, _ in guard let self = self else { return }
                
                self.isPaused = true
                
                self.hideDetails( nil )
            }
            
            let stats                = StatsViewController()
            stats.scene              = scene
            self.statsViewController = stats
            
            self.statsView.addFillingSubview( stats.view, removeAllExisting: true )
            self.contentView.addFillingSubview( view, removeAllExisting: true )
            view.presentScene( scene )
            
            self.isPaused = false
            
            view.showsFPS       = Preferences.shared.showsFPS
            view.showsDrawCount = Preferences.shared.showsDrawCount
            view.showsNodeCount = Preferences.shared.showsNodeCount
            view.showsQuadCount = Preferences.shared.showsQuadCount
        }
    }
    
    @IBAction public func reset( _ sender: Any? )
    {
        self.isPaused = true
        
        self.show( sender )
    }
    
    @IBAction public func togglePause( _ sender: Any? )
    {
        if self.scene?.isGameOver ?? false
        {
            NSSound.beep()
            
            return
        }
        
        self.isPaused = self.isPaused == false
    }
    
    @IBAction public func pause( _ sender: Any? )
    {
        self.isPaused = true
    }
    
    @IBAction public func resume( _ sender: Any? )
    {
        self.isPaused = false
    }
    
    public func showDetails( node: SpriteNode )
    {
        if self.scene?.isGameOver ?? false
        {
            return
        }
        
        if let detail = self.detailViewController
        {
            detail.node.highlight( false )
            detail.view.removeFromSuperview()
        }
        
        var controller: DetailViewController?
        
        if let creature = node as? Creature
        {
            controller = CreatureDetailViewController( creature: creature )
        }
        else if let food = node as? Food
        {
            controller = FoodDetailViewController( food: food )
        }
        
        guard let controller = controller else
        {
            NSSound.beep()
            
            return
        }
        
        var frame = controller.view.frame
        
        if let detail = self.detailViewController
        {
            frame.origin = detail.view.frame.origin
        }
        else
        {
            frame.origin.x = 20
            frame.origin.y = 20
        }
        
        controller.view.frame = frame
        
        node.highlight( true )
        self.contentView.addSubview( controller.view )
        
        self.detailViewController = controller
    }
    
    public func hideDetails( _ sender: Any? )
    {
        if let detail = self.detailViewController
        {
            detail.node.highlight( false )
            detail.view.removeFromSuperview()
        }
    }
    
    @IBAction public func toggleFPS( _ sender: Any? )
    {
        guard let view = self.view else
        {
            NSSound.beep()
            
            return
        }
        
        view.showsFPS               = view.showsFPS == false
        Preferences.shared.showsFPS = view.showsFPS
    }
    
    @IBAction public func toggleDrawCount( _ sender: Any? )
    {
        guard let view = self.view else
        {
            NSSound.beep()
            
            return
        }
        
        view.showsDrawCount               = view.showsDrawCount == false
        Preferences.shared.showsDrawCount = view.showsDrawCount
    }
    
    @IBAction public func toggleNodeCount( _ sender: Any? )
    {
        guard let view = self.view else
        {
            NSSound.beep()
            
            return
        }
        
        view.showsNodeCount               = view.showsNodeCount == false
        Preferences.shared.showsNodeCount = view.showsNodeCount
    }
    
    @IBAction public func toggleQuadCount( _ sender: Any? )
    {
        guard let view = self.view else
        {
            NSSound.beep()
            
            return
        }
        
        view.showsQuadCount               = view.showsQuadCount == false
        Preferences.shared.showsQuadCount = view.showsQuadCount
    }
    
    @IBAction public func viewEventLog( _ sender: Any? )
    {
        if self.eventLogWindowController == nil
        {
            self.eventLogWindowController = EventLogWindowController()
            
            self.eventLogWindowController?.window?.center()
        }
        
        self.eventLogWindowController?.window?.makeKeyAndOrderFront( nil )
    }
}
