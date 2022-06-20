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

public class Meat: Food, Updatable
{
    public  var isAvailable   = true
    private var peremptionTime: TimeInterval?
    private var removalTime:    TimeInterval?
    
    @objc public private( set ) dynamic var born: TimeInterval = -1
    @objc public private( set ) dynamic var age:  TimeInterval = -1
    
    public required init( energy: Int, settings: Settings )
    {
        super.init( energy: energy, settings: settings, texture: SKTexture( imageNamed: "Meat" ), color: NSColor.clear, size: NSSize( width: 20, height: 20 ) )
        
        let physicsBody                = SKPhysicsBody( circleOfRadius: self.size.height / 2 )
        physicsBody.affectedByGravity  = false
        physicsBody.isDynamic          = true
        physicsBody.categoryBitMask    = Constants.organismPhysicsCategory
        
        self.physicsBody = physicsBody
        self.energy      = energy
    }
    
    public required init?( coder: NSCoder )
    {
        nil
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
            if peremptionTime <= elapsedTime
            {
                self.energy           = self.settings.meat.decayEnergy
                self.colorBlendFactor = 0
                self.color            = NSColor.purple
                
                self.run( SKAction.colorize( withColorBlendFactor: 0.75, duration: 1 ) )
            }
        }
        else if self.settings.meat.canDecay
        {
            self.peremptionTime = elapsedTime + self.settings.meat.decayAfter + Double.random( in: 0 ... self.settings.meat.decayAfterRange )
        }
        
        if let removalTime = self.removalTime
        {
            if removalTime <= elapsedTime
            {
                self.remove()
            }
        }
        else if self.settings.meat.canDisappear
        {
            self.removalTime = elapsedTime + self.settings.meat.disappearAfter + Double.random( in: 0 ... self.settings.meat.disappearAfterRange )
        }
    }
}
