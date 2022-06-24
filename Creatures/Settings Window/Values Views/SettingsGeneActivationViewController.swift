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

public class SettingsGeneActivationViewController: NSViewController, SettingsValueViewController
{
    @objc private dynamic var settings: Settings
    
    private var gene: AnyClass
    private var key:  WritableKeyPath< Settings, [ String ] >
    
    public override var description: String
    {
        let info  = GeneInfo.allGenes( settings: self.settings )
        let value = self.settings[ keyPath: self.key ]
        let names = value.compactMap
        {
            name in info.first { String( describing: $0.geneClass ) == name }?.name
        }
        
        return names.isEmpty ? "--" : names.joined( separator: ", " )
    }
    
    public init( title: String, gene: AnyClass, settings: Settings, key: WritableKeyPath< Settings, [ String ] > )
    {
        self.gene     = gene
        self.settings = settings
        self.key      = key
        
        super.init( nibName: nil, bundle: nil )
        
        self.title = title
    }
    
    required init?( coder: NSCoder )
    {
        nil
    }
    
    public override var nibName: NSNib.Name?
    {
        "SettingsGeneActivationViewController"
    }
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    public func updateSettings( _ settings: Settings )
    {
        self.willChangeValue( for:\.description )
        
        self.settings = settings
        
        self.didChangeValue( for:\.description )
    }
    
    @IBAction private func choose( _ sender: Any? )
    {
        let controller = SettingsGeneSelectionWindowController( gene: self.gene, settings: self.settings, values: self.settings[ keyPath: self.key ] )
        
        guard let sheet = controller.window, let window = self.view.window else
        {
            NSSound.beep()
            
            return
        }
        
        window.beginSheet( sheet )
        {
            if $0 != .OK
            {
                return
            }
            
            self.willChangeValue( for:\.description )
            
            self.settings[ keyPath: self.key ] = controller.values
            
            self.didChangeValue( for:\.description )
        }
    }
}
