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

public class SettingsIntMenuViewController: NSViewController, SettingsValueViewController
{
    @objc private dynamic var settings: Settings
    
    @objc private dynamic var value: Int
    {
        didSet
        {
            self.settings[ keyPath: self.key ] = self.value
        }
    }
    
    private var key:    WritableKeyPath< Settings, Int >
    private var values: [ ( String, Int ) ]
    
    @IBOutlet private var popUp: NSPopUpButton!
    
    public init( title: String, settings: Settings, key: WritableKeyPath< Settings, Int >, values: [ ( String, Int ) ] )
    {
        self.settings = settings
        self.key      = key
        self.values   = values
        self.value    = settings[ keyPath: key ]
        
        super.init( nibName: nil, bundle: nil )
        
        self.title = title
    }
    
    required init?( coder: NSCoder )
    {
        nil
    }
    
    public override var nibName: NSNib.Name?
    {
        "SettingsIntMenuViewController"
    }
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.popUp.menu?.removeAllItems()
        
        let items: [ NSMenuItem ] = self.values.map
        {
            let item = $0 == "--" ? NSMenuItem.separator() : NSMenuItem( title: $0, action: nil, keyEquivalent: "" )
            item.tag = $1
            
            return item
        }
        
        self.popUp.menu?.items = items
        
        self.popUp.selectItem( withTag: self.value )
    }
    
    public func updateSettings( _ settings: Settings )
    {
        self.settings = settings
        self.value    = settings[ keyPath: self.key ]
    }
}
