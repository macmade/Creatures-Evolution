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

@objc public class Food: SpriteNode, Updatable
{
    @objc public                dynamic var energy:   Int
    @objc public private( set ) dynamic var settings: Settings
    @objc public private( set ) dynamic var born:     TimeInterval = -1
    @objc public private( set ) dynamic var age:      TimeInterval = -1
    
    private var peremptionTime: TimeInterval?
    private var removalTime:    TimeInterval?
    private var emitter:        SKEmitterNode?
    
    @objc public dynamic var isAlive: Bool
    {
        get
        {
            self.isBeingRemoved == false && self.scene != nil
        }
    }
    
    public var decayEnergy: Int
    {
        0
    }
    
    public var canDecay: Bool
    {
        false
    }
    
    public var decayAfter: Double
    {
        0.0
    }
    
    public var decayAfterRange: Double
    {
        0.0
    }
    
    public var canDisappear: Bool
    {
        false
    }
    
    public var disappearAfter: Double
    {
        0.0
    }
    
    public var disappearAfterRange: Double
    {
        0.0
    }
    
    public init( energy: Int, settings: Settings, texture: String )
    {
        self.energy   = energy
        self.settings = settings
        
        super.init( texture: SKTexture( imageNamed: texture ), color: NSColor.clear, size: NSSize( width: 30, height: 30 ) )
        
        let physicsBody                = SKPhysicsBody( circleOfRadius: self.size.height / 2 )
        physicsBody.affectedByGravity  = false
        physicsBody.isDynamic          = true
        physicsBody.categoryBitMask    = Constants.foodPhysicsCategory
        self.physicsBody               = physicsBody
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
    
    public override func toggleHighlight()
    {
        self.toggleHighlight( radius: 20 )
    }
    
    public override func highlight( _ flag: Bool )
    {
        self.highlight( flag, radius: 20 )
    }
    
    public func update( elapsedTime: TimeInterval )
    {
        if self.born < 0
        {
            self.born = elapsedTime
            self.age  = 0
        }
        else
        {
            self.age = elapsedTime - born
        }
        
        if let peremptionTime = self.peremptionTime
        {
            if peremptionTime <= elapsedTime && self.emitter == nil
            {
                self.energy = self.decayEnergy
                
                if let emitter = SKEmitterNode( fileNamed: "Rot.sks" )
                {
                    self.colorBlendFactor = 0
                    self.color            = NSColor.black
                    emitter.targetNode    = self
                    self.emitter          = emitter
                    
                    self.addChild( emitter )
                    self.run( SKAction.colorize( withColorBlendFactor: 0.5, duration: 1 ) )
                }
            }
        }
        else if self.canDecay
        {
            self.peremptionTime = elapsedTime + self.decayAfter + Double.random( in: 0 ... self.decayAfterRange )
        }
        
        if let removalTime = self.removalTime
        {
            if removalTime <= elapsedTime
            {
                self.remove()
            }
        }
        else if self.canDisappear
        {
            self.removalTime = elapsedTime + self.disappearAfter + Double.random( in: 0 ... self.disappearAfterRange )
        }
    }
}
