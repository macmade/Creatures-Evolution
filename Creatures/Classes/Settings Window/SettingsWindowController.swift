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

public class SettingsWindowController: NSWindowController
{
    @objc public dynamic var showCancelButton = true
    @objc public dynamic var settings         = Settings()
    
    @objc private dynamic var items: [ SettingsItem ]
    
    @IBOutlet private var itemsController: NSArrayController!
    @IBOutlet private var contentView:     NSView!
    
    private var selectionObserver: NSKeyValueObservation?
    
    public override init( window: NSWindow? )
    {
        self.items = [
            SettingsItem( title: "Creatures",       symbol: "allergens", controller: CreaturesSettingsViewController(      settings: self.settings ) ),
            SettingsItem( title: "Plants",          symbol: "allergens", controller: PlantsSettingsViewController(         settings: self.settings ) ),
            SettingsItem( title: "Meat",            symbol: "allergens", controller: MeatSettingsViewController(           settings: self.settings ) ),
            SettingsItem( title: "Mitosis",         symbol: "allergens", controller: MitosisSettingsViewController(        settings: self.settings ) ),
            SettingsItem( title: "Sex",             symbol: "allergens", controller: SexSettingsViewController(            settings: self.settings ) ),
            SettingsItem( title: "Herbivore",       symbol: "allergens", controller: HerbivoreSettingsViewController(      settings: self.settings ) ),
            SettingsItem( title: "Scavenger",       symbol: "allergens", controller: ScavengerSettingsViewController(      settings: self.settings ) ),
            SettingsItem( title: "Carnivore",       symbol: "allergens", controller: CarnivoreSettingsViewController(      settings: self.settings ) ),
            SettingsItem( title: "Vampire",         symbol: "allergens", controller: VampireSettingsViewController(        settings: self.settings ) ),
            SettingsItem( title: "Cannibal",        symbol: "allergens", controller: CannibalSettingsViewController(       settings: self.settings ) ),
            SettingsItem( title: "Plant Sense",     symbol: "allergens", controller: PlantSenseSettingsViewController(     settings: self.settings ) ),
            SettingsItem( title: "Meat Sense",      symbol: "allergens", controller: MeatSenseSettingsViewController(      settings: self.settings ) ),
            SettingsItem( title: "Creature Sense",  symbol: "allergens", controller: CreatureSenseSettingsViewController(  settings: self.settings ) ),
            SettingsItem( title: "Sex Sense",       symbol: "allergens", controller: SexSenseSettingsViewController(       settings: self.settings ) ),
            SettingsItem( title: "Carnivore Sense", symbol: "allergens", controller: CarnivoreSenseSettingsViewController( settings: self.settings ) ),
            SettingsItem( title: "Vampire Sense",   symbol: "allergens", controller: VampireSenseSettingsViewController(   settings: self.settings ) ),
        ]
        
        super.init( window: window )
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
    }
    
    private func selectionChanged()
    {
        guard let selected = self.itemsController.selectedObjects.first as? SettingsItem else
        {
            return
        }
        
        self.contentView.addFillingSubview( selected.controller.view, removeAllExisting: true )
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
            $0.controller.settings = self.settings
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
}
