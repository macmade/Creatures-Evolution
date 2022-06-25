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

public class EditNameWindowController: NSWindowController
{
    @objc public private( set ) dynamic var creature: Creature
    @objc public private( set ) dynamic var name:     String
    @objc public private( set ) dynamic var image:    NSImage?
    
    public init( creature: Creature )
    {
        self.creature = creature
        self.name     = creature.customName ?? ""
        
        super.init( window: nil )
        
        if let texture = self.creature.texture as? ImageTexture
        {
            self.image = texture.image
        }
    }
    
    required init?( coder: NSCoder )
    {
        nil
    }
    
    public override var windowNibName: NSNib.Name?
    {
        "EditNameWindowController"
    }
    
    public override func windowDidLoad()
    {
        super.windowDidLoad()
    }
    
    @IBAction public func cancel( _ sender: Any? )
    {
        self.endSheet( response: .cancel )
    }
    
    @IBAction public func save( _ sender: Any? )
    {
        self.endSheet( response: .OK )
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
