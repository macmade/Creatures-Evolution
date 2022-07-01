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

public class SpriteNode: SKSpriteNode
{
    private static let flashActionKey = "Flash"
    
    public private( set ) var isBeingRemoved = false
    public private( set ) var isHighlighted  = false
    
    @objc public private( set ) dynamic var born: TimeInterval = -1
    @objc public private( set ) dynamic var age:  TimeInterval = -1
    
    private var initialized = false
    private var highlight:    SKShapeNode?
    private var emitter:      SKEmitterNode?
    
    public var hasEmitter: Bool
    {
        self.emitter != nil
    }
    
    public func initialize()
    {}
    
    public func update( elapsedTime: TimeInterval )
    {
        if initialized == false
        {
            self.initialized = true
            
            self.initialize()
        }
        
        if self.born < 0
        {
            self.born = elapsedTime
            self.age  = 0
        }
        else
        {
            self.age = elapsedTime - born
        }
    }
    
    public func shutDown()
    {
        if let emitter = self.emitter
        {
            emitter.targetNode = nil
            
            emitter.removeFromParent()
        }
        
        self.removeAllActions()
    }
    
    public func emit( effect: String, duration: Double = -1 )
    {
        if let emitter = self.emitter
        {
            emitter.targetNode = nil
            
            emitter.removeFromParent()
        }
        
        if let emitter = SKEmitterNode( fileNamed: effect )
        {
            emitter.targetNode = self
            emitter.zPosition  = CGFloat.infinity
            
            if duration <= 0
            {
                self.addChild( emitter )
                
                self.emitter = emitter
            }
            else
            {
                let emit = SKAction.run { [ weak self ] in self?.addChild( emitter ) }
                let wait = SKAction.wait( forDuration: duration )
                
                self.run( SKAction.sequence( [ emit, wait ] ) )
                {
                    emitter.targetNode = nil
                    
                    emitter.removeFromParent()
                }
            }
        }
    }
    
    public func flash( _ flash: Bool, alpha: Double = 0.25, duration: Double = 0.5 )
    {
        self.alpha = 1
        
        if flash && self.action( forKey: SpriteNode.flashActionKey ) == nil
        {
            let fadeOut = SKAction.fadeAlpha( to: alpha, duration: duration )
            let fadeIn  = SKAction.fadeAlpha( to: 1,     duration: duration )
            let flash   = SKAction.sequence( [ fadeOut, fadeIn ] )
            let group   = SKAction.repeatForever( flash )
            
            self.run( group, withKey: SpriteNode.flashActionKey )
        }
        else if flash == false
        {
            self.removeAction( forKey: SpriteNode.flashActionKey )
        }
    }
    
    public func remove()
    {
        self.isBeingRemoved = true
        self.physicsBody    = nil
        
        let actions = [
            SKAction.fadeOut( withDuration: 0.5 ),
            SKAction.scale( to: NSSize( width:  0, height: 0 ), duration: 0.5 )
        ]
        
        self.run( SKAction.group( actions ) )
        {
            [ weak self ] in self?.removeFromParent()
        }
    }
    
    public func toggleHighlight()
    {
        self.highlight( self.highlight == nil )
    }
    
    public func toggleHighlight( radius: Double )
    {
        self.highlight( self.highlight == nil, radius: radius )
    }
    
    public func highlight( _ flag: Bool )
    {
        let size = max( self.size.width / self.xScale, self.size.height / self.yScale )
        
        self.highlight( flag, radius: ( size / 2.0 ) + 5 )
    }
    
    public func highlight( _ flag: Bool, radius: Double )
    {
        if flag && self.highlight != nil
        {
            return
        }
        
        self.isHighlighted = flag
        
        if flag
        {
            let highlight         = SKShapeNode( circleOfRadius: radius )
            highlight.fillColor   = NSColor.systemPink.withAlphaComponent( 0.5 )
            highlight.strokeColor = NSColor.white
            highlight.zPosition   = 0
            self.highlight        = highlight
            
            self.addChild( highlight )
        }
        else
        {
            self.highlight?.removeFromParent()
            
            self.highlight = nil
        }
    }
}
