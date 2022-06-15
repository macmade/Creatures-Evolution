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

public class Meat: SpriteNode, Food, Updatable
{
    public  var energy        = 1
    public  var isAvailable   = true
    private var peremptionDate: Date?
    private var removalDate:    Date?
    
    public required init( energy: Int )
    {
        super.init( texture: SKTexture( imageNamed: "Meat" ), color: NSColor.clear, size: NSSize( width: 20, height: 20 ) )
        
        let physicsBody                = SKPhysicsBody( circleOfRadius: self.size.height / 2 )
        physicsBody.affectedByGravity  = false
        physicsBody.isDynamic          = false
        
        self.physicsBody = physicsBody
        self.energy      = energy
    }
    
    public required init?( coder: NSCoder )
    {
        nil
    }
    
    public func update()
    {
        guard let scene = self.scene as? Scene else
        {
            return
        }
        
        if let peremptionDate = self.peremptionDate
        {
            if peremptionDate.timeIntervalSinceNow < 0
            {
                self.energy           = scene.settings.meat.decayEnergy
                self.colorBlendFactor = 0
                self.color            = NSColor.purple
                
                self.run( SKAction.colorize( withColorBlendFactor: 0.75, duration: 1 ) )
            }
        }
        else if scene.settings.meat.canDecay
        {
            self.peremptionDate = Date( timeIntervalSinceNow: scene.settings.meat.decayAfter + Double.random( in: 0 ... scene.settings.meat.decayAfterRange ) )
        }
        
        if let removaleDate = self.removalDate
        {
            if removaleDate.timeIntervalSinceNow < 0
            {
                self.remove()
            }
        }
        else if scene.settings.meat.canDisappear
        {
            self.removalDate = Date( timeIntervalSinceNow: scene.settings.meat.disappearAfter + Double.random( in: 0 ... scene.settings.meat.disappearAfterRange ) )
        }
    }
}
