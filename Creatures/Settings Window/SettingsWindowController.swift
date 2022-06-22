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

public class SettingsWindowController: NSWindowController, NSTableViewDelegate, NSTableViewDataSource
{
    @objc public dynamic var showCancelButton = true
    @objc public dynamic var settings:          Settings
    
    @objc private dynamic var items: [ SettingsItem ]
    
    @IBOutlet private var itemsController: NSArrayController!
    @IBOutlet private var contentView:     NSView!
    
    private var selectionObserver:    NSKeyValueObservation?
    private var animating           = false
    private let controllerMinHeight = 400.0
    
    public init( settings: Settings? )
    {
        self.settings = settings ?? Settings.restore()
        self.items    = [
            SettingsItem( title: "World",          symbol: "globe.europe.africa.fill",           controller: WorldSettingsViewController(         settings: self.settings ) ),
            SettingsItem( title: "Creatures",      symbol: "allergens",                          controller: CreaturesSettingsViewController(     settings: self.settings ) ),
            SettingsItem( title: "Plants",         symbol: "takeoutbag.and.cup.and.straw.fill",  controller: PlantsSettingsViewController(        settings: self.settings ) ),
            SettingsItem( title: "Meat",           symbol: "takeoutbag.and.cup.and.straw.fill",  controller: MeatSettingsViewController(          settings: self.settings ) ),
            SettingsItem( title: "Speed",          symbol: "hare.fill",                          controller: SpeedSettingsViewController(         settings: self.settings ) ),
            SettingsItem( title: "Mitosis",        symbol: "heart.fill",                         controller: MitosisSettingsViewController(       settings: self.settings ) ),
            SettingsItem( title: "Sex",            symbol: "heart.fill",                         controller: SexSettingsViewController(           settings: self.settings ) ),
            SettingsItem( title: "Herbivore",      symbol: "fork.knife.circle.fill",             controller: HerbivoreSettingsViewController(     settings: self.settings ) ),
            SettingsItem( title: "Scavenger",      symbol: "fork.knife.circle.fill",             controller: ScavengerSettingsViewController(     settings: self.settings ) ),
            SettingsItem( title: "Predator",       symbol: "fork.knife.circle.fill",             controller: PredatorSettingsViewController(      settings: self.settings ) ),
            SettingsItem( title: "Vampire",        symbol: "fork.knife.circle.fill",             controller: VampireSettingsViewController(       settings: self.settings ) ),
            SettingsItem( title: "Cannibal",       symbol: "fork.knife.circle.fill",             controller: CannibalSettingsViewController(      settings: self.settings ) ),
            SettingsItem( title: "Plant Sense",    symbol: "sensor.tag.radiowaves.forward.fill", controller: PlantSenseSettingsViewController(    settings: self.settings ) ),
            SettingsItem( title: "Meat Sense",     symbol: "sensor.tag.radiowaves.forward.fill", controller: MeatSenseSettingsViewController(     settings: self.settings ) ),
            SettingsItem( title: "Prey Sense",     symbol: "sensor.tag.radiowaves.forward.fill", controller: PreySenseSettingsViewController(     settings: self.settings ) ),
            SettingsItem( title: "Sex Sense",      symbol: "sensor.tag.radiowaves.forward.fill", controller: SexSenseSettingsViewController(      settings: self.settings ) ),
            SettingsItem( title: "Predator Sense", symbol: "sensor.tag.radiowaves.forward.fill", controller: PredatorSenseSettingsViewController( settings: self.settings ) ),
            SettingsItem( title: "Vampire Sense",  symbol: "sensor.tag.radiowaves.forward.fill", controller: VampireSenseSettingsViewController(  settings: self.settings ) ),
        ]
        
        super.init( window: nil )
    }
    
    required init?( coder: NSCoder )
    {
        nil
    }
    
    public override var windowNibName: NSNib.Name?
    {
        "SettingsWindowController"
    }
    
    public override func windowDidLoad()
    {
        super.windowDidLoad()
        
        self.selectionObserver = self.itemsController.observe( \.selectionIndex )
        {
            [ weak self ] _, _ in self?.selectionChanged()
        }
        
        self.selectionChanged()
    }
    
    @IBAction public func save( _ sender: Any? )
    {
        self.endSheet( response: .OK )
    }
    
    @IBAction public func cancel( _ sender: Any? )
    {
        self.endSheet( response: .cancel )
    }
    
    @IBAction public func restoreDefaults( _ sender: Any? )
    {
        self.settings = Settings()
        
        self.items.forEach
        {
            $0.controller.updateSettings( settings: self.settings )
        }
    }
    
    private func endSheet( response: NSApplication.ModalResponse )
    {
        guard let window = self.window else
        {
            NSSound.beep()
            
            return
        }
        
        if let parent = window.sheetParent
        {
            parent.endSheet( window, returnCode: response )
        }
        else
        {
            window.close()
        }
    }
    
    public func tableView( _ tableView: NSTableView, rowViewForRow row: Int ) -> NSTableRowView?
    {
        TableRowView( frame: NSZeroRect )
    }
    
    private func selectionChanged()
    {
        guard let item = self.itemsController.selectedObjects.first as? SettingsItem else
        {
            return
        }
        
        self.showController( item.controller )
    }
    
    private func windowFrame( for controller: NSViewController ) -> NSRect
    {
        guard let container = self.contentView,
              let window    = self.window
        else
        {
            return NSRect.zero
        }
        
        let diffX = container.frame.size.width  - controller.view.frame.size.width
        let diffY = container.frame.size.height - controller.view.frame.size.height
        var rect  = window.frame
        
        rect.origin.x    += diffX / 2
        rect.origin.y    += diffY
        rect.size.width  -= diffX
        rect.size.height -= diffY
        
        return rect
    }
    
    private func showController( _ controller: NSViewController )
    {
        guard let container = self.contentView, let window = self.window else
        {
            return
        }
        
        if controller.view == container.subviews.first
        {
            return
        }
        
        if controller.view.frame.size.height < self.controllerMinHeight
        {
            var frame             = controller.view.frame
            frame.size.height     = self.controllerMinHeight
            controller.view.frame = frame
        }
        
        let rect = self.windowFrame( for: controller )
        
        container.subviews.forEach { $0.removeFromSuperview() }
        
        if window.isVisible
        {
            self.animating             = true
            controller.view.alphaValue = 0
            
            self.window?.layoutIfNeeded()
            container.layoutSubtreeIfNeeded()
            controller.view.layoutSubtreeIfNeeded()
            
            NSAnimationContext.runAnimationGroup(
                {
                    context in
                    
                    self.window?.layoutIfNeeded()
                    container.layoutSubtreeIfNeeded()
                    controller.view.layoutSubtreeIfNeeded()
                    
                    window.animator().setFrame( rect, display: true, animate: true )
                },
                completionHandler:
                {
                    container.addSubview( controller.view )
                    container.addConstraint( NSLayoutConstraint( item: container, attribute: .width,   relatedBy: .equal, toItem: controller.view, attribute: .width,   multiplier: 1, constant: 0 ) )
                    container.addConstraint( NSLayoutConstraint( item: container, attribute: .height,  relatedBy: .equal, toItem: controller.view, attribute: .height,  multiplier: 1, constant: 0 ) )
                    container.addConstraint( NSLayoutConstraint( item: container, attribute: .centerX, relatedBy: .equal, toItem: controller.view, attribute: .centerX, multiplier: 1, constant: 0 ) )
                    container.addConstraint( NSLayoutConstraint( item: container, attribute: .centerY, relatedBy: .equal, toItem: controller.view, attribute: .centerY, multiplier: 1, constant: 0 ) )
                    
                    controller.view.animator().alphaValue = 1
                    self.animating                        = false
                }
            )
        }
        else
        {
            self.window?.setFrame( rect, display: false, animate: false )
            container.addSubview( controller.view )
            container.addConstraint( NSLayoutConstraint( item: container, attribute: .width,   relatedBy: .equal, toItem: controller.view, attribute: .width,   multiplier: 1, constant: 0 ) )
            container.addConstraint( NSLayoutConstraint( item: container, attribute: .height,  relatedBy: .equal, toItem: controller.view, attribute: .height,  multiplier: 1, constant: 0 ) )
            container.addConstraint( NSLayoutConstraint( item: container, attribute: .centerX, relatedBy: .equal, toItem: controller.view, attribute: .centerX, multiplier: 1, constant: 0 ) )
            container.addConstraint( NSLayoutConstraint( item: container, attribute: .centerY, relatedBy: .equal, toItem: controller.view, attribute: .centerY, multiplier: 1, constant: 0 ) )
        }
    }
    
    public func tableView( _ tableView: NSTableView, shouldSelectRow row: Int ) -> Bool
    {
        return self.animating == false
    }
}
