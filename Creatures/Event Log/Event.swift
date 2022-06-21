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

public class Event: NSObject
{
    @objc public private( set ) dynamic      var message:  String
    @objc public private( set ) dynamic      var time:     TimeInterval
    @objc public private( set ) dynamic weak var node:     SKNode?
    @objc public private( set ) dynamic      var image:    NSImage?
    @objc public private( set ) dynamic      var nodeName: String?
    
    private let uid = UUID()
    
    public init( message: String, time: TimeInterval, node: SKNode? )
    {
        self.message  = message
        self.time     = time
        self.node     = node
        
        if let creature = node as? Creature, let name = creature.customName, name.isEmpty == false
        {
            self.nodeName = name
        }
        else if let name = node?.name, name.isEmpty == false
        {
            self.nodeName = name
        }
        else
        {
            self.nodeName = "<unknown>"
        }
        
        if let sprite = node as? SKSpriteNode, let image = sprite.texture?.cgImage()
        {
            self.image = NSImage( cgImage: image, size: NSMakeSize( 1024, 1024 ) )
        }
    }
    
    public override func isEqual( to object: Any? ) -> Bool
    {
        guard let event = object as? Event else
        {
            return false
        }
        
        return self.uid == event.uid
    }
}
