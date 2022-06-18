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

@objc public class Food: SpriteNode
{
    @objc public                dynamic var energy:   Int
    @objc public private( set ) dynamic var settings: Settings
    
    @objc public dynamic var isAlive: Bool
    {
        get
        {
            self.isBeingRemoved == false && self.scene != nil
        }
    }
    
    init( energy: Int, settings: Settings, texture: SKTexture?, color: NSColor, size: CGSize )
    {
        self.energy   = energy
        self.settings = settings
        
        super.init( texture: texture, color: color, size: size )
    }
    
    required init?( coder: NSCoder )
    {
        nil
    }
    
    public override func remove()
    {
        self.willChangeValue( for: \.isAlive )
        super.remove()
        self.didChangeValue( for: \.isAlive )
    }
}
