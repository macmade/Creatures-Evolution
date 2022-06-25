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

public class DetailViewController: NSViewController
{
    @objc public private( set ) dynamic var node:  SpriteNode
    @objc        private        dynamic var image: NSImage?
    
    public init( node: SpriteNode )
    {
        self.node = node
        
        super.init( nibName: nil, bundle: nil )
    }
    
    public required init?( coder: NSCoder )
    {
        nil
    }
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        self.update()
    }
    
    public func update()
    {
        if let texture = self.node.texture as? ImageTexture
        {
            self.image = texture.image
        }
        else
        {
            self.image = nil
        }
    }
    
    @IBAction public func close( _ sender: Any? )
    {
        guard let windowController = self.view.window?.windowController as? MainWindowController else
        {
            NSSound.beep()
            
            return
        }
        
        windowController.hideDetails( sender )
    }
}
