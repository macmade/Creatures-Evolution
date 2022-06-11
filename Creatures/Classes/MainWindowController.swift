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
    @objc public private( set ) dynamic var scene: Scene?
    
    @IBOutlet private var view: SKView?
    
    public override var windowNibName: NSNib.Name?
    {
        "MainWindowController"
    }
    
    public override func windowDidLoad()
    {
        super.windowDidLoad()
        
        guard let view = self.view else
        {
            return
        }
        
        let scene  = Scene( size: view.bounds.size )
        self.scene = scene
        
        view.presentScene( scene )
        
        view.showsFPS       = true
        view.showsFields    = true
        view.showsPhysics   = false
        view.showsDrawCount = true
        view.showsNodeCount = true
        view.showsQuadCount = true
    }
    
    @IBAction public func reset( _ sender: Any? )
    {
        guard let scene = self.scene else
        {
            NSSound.beep()
            
            return
        }
        
        scene.reset()
    }
}
